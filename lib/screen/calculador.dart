// import 'package:demo/data/descuentos.dart';
// import 'package:demo/screen/home_page.dart';
// import 'package:flutter/material.dart';

// class Calculador extends StatefulWidget {
//   const Calculador({Key? key}) : super(key: key);

//   @override
//   _CalculadorState createState() => _CalculadorState();
// }

// class _CalculadorState extends State<Calculador> {
//   List<String> items = ['h1', 'h2', 'h3'];
//   String? valueItem;
//   String tipo = '';
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Calculador de precios'),
//           leading: IconButton(
//             onPressed: () => Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => const HomePage()),
//                 (route) => false),
//             icon: const Icon(Icons.arrow_back_ios),
//           ),
//         ),
//         body: Stack(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 drop(),
//                 SingleChildScrollView(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height - 200,
//                     child: ListView.builder(
//                       itemCount: demo.length,
//                       itemBuilder: (context, index) {
//                         var item = demo[index];
//                         return ListTile(
//                           leading:
//                               const Image(image: AssetImage('assets/demo.png')),
//                           title: Text('${item.nombre}  \$${item.precio}'),
//                           subtitle: Text('Desc: ${item.descuento}%'),
//                           dense: true,
//                           onTap: () {},
//                           contentPadding: const EdgeInsets.all(10),
//                           trailing: Text(
//                             'Con desc: \$${item.precioDescuento}',
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget drop() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.blue, width: 3),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: DropdownButton(
//             underline: Container(
//               height: 60,
//               width: 60,
//               color: Colors.transparent,
//             ),
//             isExpanded: true,
//             value: valueItem,
//             hint: const Text('Bateria'),
//             items: items
//                 .map((e) => DropdownMenuItem(
//                       value: e,
//                       child: Text(e),
//                     ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 valueItem = value!;
//                 tipo = valueItem!;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
