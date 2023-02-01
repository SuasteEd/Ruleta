import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:demo/screen/formulario.dart';
import 'package:demo/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  int time = 0;
  HomePage({Key? key, required this.time}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    initial();
    counter();
    super.initState();
  }

  Future<bool> backCount() async {
    loading();
    final headers = {HttpHeaders.authorizationHeader: token};
    if (await internet()) {
      var res = await http.get(uri, headers: headers);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        disp = body["Disponible"];
      }
      if (disp) {
        // ignore: use_build_context_synchronously
        Navigator.pop(dialogContext);
        return true;
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(dialogContext);
      }
    }
    return false;
  }

  void initial() async {
    data = await SharedPreferences.getInstance();
    setState(() {
      token = data.getString('token')!;
    });
  }

  void counter() async {
    var date = DateTime.now();
    var hora = ((date.hour * 60) + (date.minute)) * 60000;
    data = await SharedPreferences.getInstance();
    setState(() {
      isCount = data.getBool('isCount') ?? true;
      count = data.getInt('horaInicio')!;
      tf = ((count * 60000) - hora);
      time = tf;
    });

    print("Hora actual: $hora");
    print("Hora inicio: ${count * 60000}");
    if (await backCount()) {
      setState(() {
        time = 0;
        count = 0;
        tf = 0;
      });
    } else {
      iniciar();
    }
  }

  late BuildContext dialogContext;
  String token = '';
  final uri = Uri.parse(
      'https://enersisuat.azurewebsites.net/api/Promocion/RuletaLimite');
  late double height, widht;
  late SharedPreferences data;
  int tiempo = 0;
  bool isLoading = true;
  int time = 0;
  int count = 0;
  int tf = 0;
  bool isCount = true;
  bool disp = false;
  int contadorExtra = 90000;
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    widht = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: height * .5,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(50))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PopupMenuButton(itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  onTap: () async {
                                    final data =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      data.clear();
                                    });
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()),
                                        (route) => false);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.black,
                                      ),
                                      Text('Cerrar sesión')
                                    ],
                                  ))
                            ];
                          })
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: const [
                      //     Image(
                      //         image: AssetImage('assets/buenFin.png'),
                      //         height: 120),
                      //   ],
                      // ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Center(
                        child: Text(
                          '¡Bienvenido!',
                          style: GoogleFonts.bebasNeue(
                              fontSize: 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Text(
                          'Puedes ganar grandes descuentos',
                          style: GoogleFonts.bebasNeue(
                              fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Container(
                    height: height * .5,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                            image: AssetImage('assets/Logo.png'), height: 120),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Center(
                          child: Text(
                            'Regístrate y gana',
                            style: GoogleFonts.bebasNeue(
                                fontSize: 30, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: contador(),
            )
          ],
        ),
      ),
    );
  }

  void iniciar() async {
    if (isCount) {
      if (widget.time == 0) {
        if (time <= 0) {
          time = 0;
        }
        tiempo = time;
      } else {
        tiempo = widget.time;
      }
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (tiempo > 0) {
        setState(() {
          tiempo -= 1000;
        });
      } else {
        setState(() {
          time = 0;
          count = 0;
          tf = 0;
          isCount = false;
        });
        timer.cancel();
      }
    });
  }

  String formato() {
    Duration duration = Duration(milliseconds: tiempo);
    String dosValores(int valor) {
      return valor >= 10 ? '$valor' : '0$valor';
    }

    String minutos = dosValores(duration.inMinutes.remainder(60));
    String segundos = dosValores(duration.inSeconds.remainder(60));

    return "$minutos:$segundos";
  }

  Widget contador() {
    if (tiempo <= 0) {
      return GestureDetector(
        onTap: () async {
          if (await internet()) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Formulario()));
          }
        },
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              'Obten tu descuento',
              style: GoogleFonts.bebasNeue(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            formato(),
            style: GoogleFonts.bebasNeue(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void loading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        });
  }

  Future<bool> internet() async {
    try {
      final connection = await InternetAddress.lookup('google.com');
      if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      Alert(
        context: context,
        style: const AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
              color: Colors.black,
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context))
        ],
        title: "Sin conexión",
        desc: "Necesitas internet para continuar",
        image: Image.asset(
          'assets/triste.png',
          height: 100,
        ),
      ).show();

      return false;
    }
    return false;
  }
}
