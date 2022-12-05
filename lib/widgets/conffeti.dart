import 'dart:math';
import 'package:demo/constants.dart';
import 'package:demo/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Conffeti extends StatefulWidget {
  late String descuento;
  Conffeti({Key? key, required this.descuento}) : super(key: key);
  @override
  _ConffetiState createState() => _ConffetiState();
}

class _ConffetiState extends State<Conffeti> {
  late SharedPreferences postData;
  String cupon = '';
  int ms = 0;
  ConfettiController controller = ConfettiController();
  @override
  void initState() {
    super.initState();
    getCupon();
    controller = ConfettiController(duration: const Duration(seconds: 2));
    controller.play();
  }

  void getCupon() async {
    final descuento = await SharedPreferences.getInstance();
    setState(() {
      cupon = descuento.getString('cupon') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: controller,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.yellow,
              Colors.green,
              Colors.orange,
              Colors.purple,
            ],
            //child: Center(child: Text('njjksjk')),
            shouldLoop: true,
            blastDirection: -pi / 2,
            //emissionFrequency: 0,
            numberOfParticles: 100,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¡Felicidades!',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 50,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      'Ganaste un descuento del',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      widget.descuento,
                      style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 50,
                          decoration: TextDecoration.none),
                    ),
                    descuen(),
                    GestureDetector(
                      onTap: () {
                        _alert();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              'salir',
                              style: GoogleFonts.bebasNeue(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))),
          ),
        ),
      ],
    );
  }

  Widget descuen() {
    while (descuento.isNotEmpty) {
      return Text(
        descuento,
        style: const TextStyle(
            color: Colors.black, fontSize: 30, decoration: TextDecoration.none),
      );
    }
    return const Center(child: CircularProgressIndicator(color: Colors.black));
  }

  timer() async {
    postData = await SharedPreferences.getInstance();
    var date = DateTime.now();
    var hora = ((date.hour * 60) + (date.minute));
    var rest = time - hora;
    ms = rest.abs() * 60000;
    postData.setInt('horaFinal', ms);
  }

  _alert() async {
    timer();
    Alert(
      context: context,
      type: AlertType.warning,
      style: const AlertStyle(isCloseButton: false),
      title: 'Confirmación',
      desc: '¿Desea salir?',
      buttons: [
        DialogButton(
          onPressed: () {
            setState(() {});
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage(time: ms)),
                (route) => false);
          },
          color: Colors.black,
          child: const Text(
            "Sí",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        DialogButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
      ],
    ).show();
  }
}
