import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:demo/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController user = TextEditingController();
  final TextEditingController password = TextEditingController();
  String username = '';
  String pass = '';
  bool isLoading = false;
  late bool newUser;
  late SharedPreferences loginData;
  final uri =
      Uri.parse("https://enersisuat.azurewebsites.net/api/Auth/Authenticate");
  late double height, widht;
  @override
  void initState() {
    ifAlreadyLogin();
    super.initState();
  }

  void ifAlreadyLogin() async {
    loginData = await SharedPreferences.getInstance();
    newUser = loginData.getBool('login') ?? true;
    if (newUser == false) {
      _openPage();
      getToken();
    }
  }

  @override
  void dispose() {
    user.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    widht = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: height * .5,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(50))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Image(
                              image: AssetImage('assets/Logo.png'),
                              height: 180),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Container(
                    height: height * .5,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50))),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    height: height * 0.3,
                    width: widht * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(width: 2, color: Colors.white30)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        textInput(user, 'Usuario', false),
                        const SizedBox(height: 10),
                        textInput(password, 'Contraseña', true),
                        const SizedBox(height: 10),
                        Container(
                          height: height * 0.05,
                          width: widht * 0.5,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.redAccent, width: 2)),
                          child: GestureDetector(
                            onTap: () {
                              loginRest();
                            },
                            child: showIcon(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginRest() async {
    if (await internet()) {
      if (validate()) {
        var res = await http.post(uri,
            body: {"username": user.text, "password": password.text});
        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          loginData.setBool('login', false);
          loginData.setString('username', user.text);
          loginData.setString('password', password.text);
          final token = body["access_token"];
          loginData.setString('token', token);
          _openPage();
        } else {
          // ignore: use_build_context_synchronously
          alertas(context, 'Error', 'Usuario o contraseña incorrectos',
              'assets/triste.png');
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  bool validate() {
    if (user.text.isEmpty || password.text.isEmpty) {
      alertas(context, 'Faltan datos', 'Complete todos los campos',
          'assets/triste.png');
      return false;
    } else {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
    return true;
  }

  void alertas(context, String title, String desc, String image) {
    Alert(
      context: context,
      style: const AlertStyle(isCloseButton: false),
      title: title,
      desc: desc,
      image: Image.asset(image, height: 100),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
          color: Colors.black,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  Widget textInput(TextEditingController control, String hint, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextField(
            obscureText: obscure,
            controller: control,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hint),
          ),
        ),
      ),
    );
  }

  void _openPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage(time: 0)),
        (route) => false);
  }

  void getToken() async {
    setState(() {
      username = loginData.getString('username')!;
      pass = loginData.getString('password')!;
    });
    if (await internet()) {
      try {
        var res = await http
            .post(uri, body: {"username": username, "password": pass});
        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          final token = body['access_token'];
          loginData.setString('token', token);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<bool> internet() async {
    try {
      final connection = await InternetAddress.lookup('google.com');
      if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      // alertas(context, 'Sin conexión', 'Necesitas internet para continuar',
      //     'assets/triste.png');
      return false;
    }
    return false;
  }

  Widget showIcon() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      ));
    }
    return Center(
        child: Text('INICIAR SESIÓN',
            style: GoogleFonts.karla(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)));
  }
}
