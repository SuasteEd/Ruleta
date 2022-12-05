import 'package:demo/screen/spinning.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Formulario extends StatefulWidget {
  const Formulario({Key? key}) : super(key: key);

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;
  bool ben = false;
  String genero = '';
  int gen = 0;
  int calificacion = 0;
  String? valueCanal;
  String? valueAge;
  String? status;
  String? yn;
  String beneficios = '';
  String captacion = '';
  String edad = '';
  int range = 0;
  List<String> ageList = ['18-29', '30-49', '50-64', '65+'];
  List<String> canal = [
    'Facebook',
    'Instagram',
    'Televisión',
    'Internet',
    'Ubicación del local',
    'Periódico',
    'Evento reciente',
    'Recomendación'
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text('Formulario'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text('Por favor ingresa tus datos',
                    style: GoogleFonts.bebasNeue(fontSize: 30)),
              ),
              const SizedBox(height: 10),
              text('Género'),
              radioButton(),
              const SizedBox(height: 10),
              text('Edad'),
              dropAge(),
              const SizedBox(height: 10),
              text('¿Cómo nos encontraste?'),
              dropCanal(),
              const SizedBox(height: 10),
              text('¿Te explicaron los beneficios de LTH Enermax?'),
              radioButtonYn(),
              const SizedBox(height: 10),
              text('¿Qué tal tu experiencia con el servicio?'),
              const SizedBox(height: 10),
              stars(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: (() {
              print(range);
              if (validar()) {
                Alert(
                  context: context,
                  style: const AlertStyle(
                      isCloseButton: false, isOverlayTapDismiss: false),
                  title: "Registro completo",
                  desc: "Gracias por tus respuestas",
                  image: Image.asset('assets/listo.png', height: 100),
                  buttons: [
                    DialogButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Spinning(
                                    beneficios: ben,
                                    captacion: captacion,
                                    edad: range,
                                    genero: gen,
                                    valoracion: calificacion)));
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
              } else {
                Alert(
                  context: context,
                  style: const AlertStyle(isCloseButton: false),
                  title: "Datos faltantes",
                  desc: "Completa todos los campos",
                  image: Image.asset('assets/triste.png', height: 100),
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
            }),
            child: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }

  bool validarStars() {
    if ((star1 = false) &
        (star2 = false) &
        (star3 = false) &
        (star4 = false) &
        (star5 = false)) {
      return false;
    }
    return true;
  }

  bool validar() {
    if (edad.isEmpty ||
        captacion.isEmpty ||
        beneficios.isEmpty ||
        genero.isEmpty ||
        (calificacion == 0)) {
      return false;
    }
    return true;
  }

  Widget stars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              star1 ? Icons.star : Icons.star_border,
              color: const Color.fromARGB(255, 255, 226, 59),
              size: 40,
            ),
            onTap: () {
              if (star1) {
                setState(() {
                  star1 = false;
                  star2 = false;
                  star3 = false;
                  star4 = false;
                  star5 = false;
                  calificacion = 0;
                });
              } else {
                setState(() {
                  star1 = true;
                  calificacion = 1;
                });
              }
            },
          ),
          GestureDetector(
            child: Icon(
              star2 ? Icons.star : Icons.star_border,
              color: const Color.fromARGB(255, 255, 226, 59),
              size: 40,
            ),
            onTap: () {
              if (star2) {
                setState(() {
                  star3 = false;
                  star4 = false;
                  star5 = false;
                  calificacion = 1;
                });
              } else {
                setState(() {
                  star1 = true;
                  star2 = true;
                  calificacion = 2;
                });
              }
            },
          ),
          GestureDetector(
            child: Icon(
              star3 ? Icons.star : Icons.star_border,
              color: const Color.fromARGB(255, 255, 226, 59),
              size: 40,
            ),
            onTap: () {
              if (star3) {
                setState(() {
                  star4 = false;
                  star5 = false;
                  calificacion = 2;
                });
              } else {
                setState(() {
                  star1 = true;
                  star2 = true;
                  star3 = true;
                  calificacion = 3;
                });
              }
            },
          ),
          GestureDetector(
            child: Icon(
              star4 ? Icons.star : Icons.star_border,
              color: const Color.fromARGB(255, 255, 226, 59),
              size: 40,
            ),
            onTap: () {
              if (star4) {
                setState(() {
                  star5 = false;
                  calificacion = 3;
                });
              } else {
                setState(() {
                  star1 = true;
                  star2 = true;
                  star3 = true;
                  star4 = true;
                  calificacion = 4;
                });
              }
            },
          ),
          GestureDetector(
            child: Icon(
              star5 ? Icons.star : Icons.star_border,
              color: const Color.fromARGB(255, 255, 226, 59),
              size: 40,
            ),
            onTap: () {
              if (star5) {
                setState(() {
                  star5 = false;
                  calificacion = 4;
                });
              } else {
                setState(() {
                  star1 = true;
                  star2 = true;
                  star3 = true;
                  star4 = true;
                  star5 = true;
                  calificacion = 5;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget radioButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Masculino'),
              Radio(
                  activeColor: Colors.blue,
                  value: 'M',
                  groupValue: status,
                  onChanged: (value) {
                    setState(() {
                      status = value.toString();
                      genero = status!;
                      gen = 0;
                    });
                  }),
              const Text('Femenino'),
              Radio(
                  activeColor: Colors.blue,
                  value: 'F',
                  groupValue: status,
                  onChanged: (value) {
                    setState(() {
                      status = value.toString();
                      genero = status!;
                      gen = 1;
                    });
                  }),
              const Text('Otro'),
              Radio(
                  activeColor: Colors.blue,
                  value: 'O',
                  groupValue: status,
                  onChanged: (value) {
                    setState(() {
                      status = value.toString();
                      genero = status!;
                      gen = 2;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget radioButtonYn() {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sí'),
              Radio(
                  activeColor: Colors.blue,
                  value: 'Sí',
                  groupValue: yn,
                  onChanged: (value) {
                    setState(() {
                      yn = value.toString();
                      beneficios = status!;
                      ben = true;
                    });
                  }),
              const SizedBox(
                width: 60,
              ),
              const Text('No'),
              Radio(
                  activeColor: Colors.blue,
                  value: 'No',
                  groupValue: yn,
                  onChanged: (value) {
                    setState(() {
                      yn = value.toString();
                      beneficios = status!;
                      ben = false;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget starSelected(bool star) {
    return GestureDetector(
      child: Icon(
        star ? Icons.star : Icons.star_border,
        color: const Color.fromARGB(255, 255, 226, 59),
        size: 40,
      ),
      onTap: () {
        if (star) {
          setState(() {
            star = false;
          });
        } else {
          setState(() {
            star = true;
          });
        }
      },
    );
  }

  Widget text(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget textInput(TextEditingController control, String hint) {
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
            controller: control,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: hint),
          ),
        ),
      ),
    );
  }

  Widget dropCanal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton(
            underline: Container(
              height: 60,
              width: 60,
              color: Colors.transparent,
            ),
            isExpanded: true,
            value: valueCanal,
            hint: const Text('Canal de captación'),
            items: canal
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                valueCanal = value!;
                captacion = valueCanal!;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget dropAge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton(
            underline: Container(
              height: 60,
              width: 60,
              color: Colors.transparent,
            ),
            isExpanded: true,
            value: valueAge,
            hint: const Text('Edad'),
            items: ageList
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                valueAge = value!;
                edad = valueAge!;
                range = ageList.indexWhere((element) => element == value);
              });
            },
          ),
        ),
      ),
    );
  }
}
