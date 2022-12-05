import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:demo/constants.dart';
import 'package:demo/screen/home_page.dart';
import 'package:demo/widgets/conffeti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Spinning extends StatefulWidget {
  final int genero;
  final int edad;
  final bool beneficios;
  final String captacion;
  final int valoracion;
  Spinning(
      {Key? key,
      required this.edad,
      required this.genero,
      required this.beneficios,
      required this.captacion,
      required this.valoracion})
      : super(key: key);

  @override
  _SpinningState createState() => _SpinningState();
}

class _SpinningState extends State<Spinning> {
  String error = '';
  bool isCount = false;
  late SharedPreferences logindata;
  final uri = Uri.parse(
      'https://enersisuat.azurewebsites.net/api/Promocion/DinamicaRuleta');
  List<CameraDescription> _cameras = [];
  String desc = '';
  String imagen = '';
  double dato = 0.0;
  XFile? imageFile;
  late CameraController _controller;
  final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();
  final selected = BehaviorSubject<int>();
  String rewards = '';
  int count = 1;
  String token = '';
  List<int> items = [
    21,
    22,
    22,
    22,
    23,
    22,
    21,
    22,
    24,
    22,
    21,
    23,
    21,
    24,
    21,
    25,
    21,
    23,
    26,
    22,
    21,
    22,
    27,
    22,
    21,
    22,
    28,
    22,
    21,
    29,
    22,
    21,
    30
  ];

  @override
  void initState() {
    initializeCamera();
    initial();
    super.initState();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      token = logindata.getString('token')!;
    });
  }

  @override
  void dispose() {
    selected.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 280, bottom: 100),
              //   child: Text(
              //     'Intentos: $count',
              //     style:
              //         GoogleFonts.bebasNeue(fontSize: 20, color: Colors.white),
              //   ),
              // ),
              Center(
                child: Text(
                  'Gira y gana',
                  style:
                      GoogleFonts.bebasNeue(fontSize: 50, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width - 5,
                child: FortuneWheel(
                  physics: CircularPanPhysics(
                      curve: Curves.easeInOutCubicEmphasized,
                      duration: const Duration(seconds: 3)),
                  indicators: const <FortuneIndicator>[
                    FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(
                          color: Colors.yellow,
                        ))
                  ],
                  selected: selected.stream,
                  animateFirst: false,
                  items: [
                    for (int i = 0; i < items.length; i++) ...<FortuneItem>{
                      FortuneItem(
                          child: Text(
                            '${items[i]}%',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          style: const FortuneItemStyle(
                              color: Color.fromARGB(255, 0, 140, 255),
                              borderColor: Colors.black,
                              borderWidth: 3)),
                    },
                  ],
                  onAnimationEnd: () {
                    setState(() {
                      rewards = '${items[selected.value]}%';
                      dato = items[selected.value] / 100;
                    });
                    if (validar()) {
                      loading();
                      post();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  takePicturex();
                  setState(() {
                    count--;
                    selected.add(Fortune.randomInt(0, items.length));
                  });
                },
                child: boton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget boton() {
    if (count == 0) {
      return const Center();
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.red),
      height: 40,
      width: 120,
      //color: Colors.redAccent,
      child: Center(
        child: Text(
          "Girar",
          style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  bool validar() {
    if (rewards == ':C') {
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
        title: "Qué mal...",
        desc: "Suerte para la próxima",
        image: Image.asset(
          'assets/triste.png',
          height: 100,
        ),
      ).show();
      return false;
    }

    return true;
  }

  // bool attemps() {
  //   if (count == 0) {
  //     Alert(
  //       context: context,
  //       style: const AlertStyle(isCloseButton: false),
  //       buttons: [
  //         DialogButton(
  //             color: Colors.black,
  //             child: const Text(
  //               "OK",
  //               style: TextStyle(color: Colors.white, fontSize: 20),
  //             ),
  //             onPressed: () => Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => const HomePage()),
  //                 (route) => false))
  //       ],
  //       title: "Lo siento...",
  //       desc: "Ya no te quedan intentos",
  //       image: Image.asset(
  //         'assets/triste.png',
  //         height: 100,
  //       ),
  //     ).show();

  //     return false;
  //   }
  //   return true;
  // }

  initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[1], ResolutionPreset.low);
    await _controller.initialize();
    setState(() {});
  }

  takePicturex() async {
    XFile xfile = await _controller.takePicture();
    Uint8List imagebytes = await xfile.readAsBytes();
    setState(() {
      imagen = base64.encode(imagebytes);
    });
  }

  post() async {
    final headers = {HttpHeaders.authorizationHeader: token};
    if (await internet()) {
      var res = await http.post(uri, headers: headers, body: {
        "Genero": widget.genero.toString(),
        "Edad": widget.edad.toString(),
        "CanalCaptacion": widget.captacion,
        "ExplicaronBeneficios": widget.beneficios.toString(),
        "ValoracionServicio": widget.valoracion.toString(),
        "Fotografia": imagen,
        "Descuento": dato.toString()
      });
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        logindata = await SharedPreferences.getInstance();
        var date = DateTime.now();
        var hora = ((date.hour * 60) + (date.minute)) + 15;
        try {
          desc = body["Cupon"];
          setState(() {
            isCount = true;
            time = hora;
            logindata.setInt('horaInicio', hora);
            logindata.setBool('isCount', isCount);
            log("descuento: $desc");
            descuento = desc;
          });
        } catch (e) {
          print("Error: $e");
        }
      }
      if (desc.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Conffeti(descuento: rewards)),
            (route) => false);
      }
      if (res.statusCode == 400) {
        error = body["ErrorMessage"];
        if (error.isNotEmpty) {
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
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(time: 0)),
                        (route) => false);
                  })
            ],
            title: "Atención",
            desc: error,
            image: Image.asset(
              'assets/triste.png',
              height: 100,
            ),
          ).show();
        }
      }
    }
  }

  void loading() {
    showDialog(
        context: context,
        builder: (context) {
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
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            time: 0,
                          )),
                  (route) => false))
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
