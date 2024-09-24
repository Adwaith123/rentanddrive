// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:insta_car/services/image_uploader.dart';
// import 'dart:io';
//
// class EnlistCar extends StatefulWidget {
//   // String uid;
//   // EnlistCar(this.uid);
//
//   @override
//   State<EnlistCar> createState() => _EnlistCarState();
// }
//
// class _EnlistCarState extends State<EnlistCar> {
//   List seatFieldNo = [0, 0, 0, 0];
//   GetImage image = GetImage();
//   File? _image;
//   bool imageAvailable = false;
//
//
//   final nameController = TextEditingController();
//   final placeController = TextEditingController();
//   final priceController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   void _create() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       final uid;
//       if (user != null) {
//         if (imageAvailable == true) {
//           // await image.uploadmage(_image);
//           print("called");
//           uid = user.uid;
//           await firestore.collection('users').doc(uid).set({
//             'firstname': user.email,
//             'price': priceController.text,
//             'place': placeController.text,
//           });
//         } else {
//           print("image not selected");
//         }
//       } else {
//         print("uid=null");
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void onTap(int selectedFieldNo) {
//     for (int i = 0; i < seatFieldNo.length; i++) {
//       if (i == selectedFieldNo) {
//         seatFieldNo[i] = 1;
//       } else
//         seatFieldNo[i] = 0;
//     }
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//           child: Form(
//             key: _formKey,
//             child: Column(
//                 children: [
//             Padding(
//             padding: const EdgeInsets.only(
//                 top: 12.0, left: 30, right: 30, bottom: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 7.0, left: 17),
//                   child: const Text(" name",
//                       style: TextStyle(fontFamily: "Roboto", fontSize: 18)),
//                 ),
//                 TextFormField(
//                   controller: nameController,
//                   validator: (value) {
//                     if (value != null) {
//                       if (value.isEmpty) {
//                         return 'Please enter valid phone number';
//                       }
//                     }
//
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding:
//                     const EdgeInsets.symmetric(vertical: 15.0),
//                     prefixIcon: Icon(
//                       Icons.person,
//                     ),
//                     focusColor: Colors.black26,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                     ),
//                     labelText: 'User Name',
//                     hintText: 'Enter Your Name',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 12.0, left: 30, right: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 7.0, left: 17),
//                   child: Text("phone number",
//                       style: TextStyle(fontFamily: "Roboto", fontSize: 18)),
//                 ),
//                 TextFormField(
//                   controller: placeController,
//                   validator: (value) {
//                     if (value != null) {
//                       if (value.isEmpty) {
//                         return 'Please enter valid phone number';
//                       }
//                     }
//
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     contentPadding:
//                     const EdgeInsets.symmetric(vertical: 15.0),
//                     prefixIcon: Icon(
//                       Icons.person,
//                     ),
//                     focusColor: Colors.black26,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     labelText: 'User Name',
//                     hintText: 'Enter Your Name',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 40,
//             width: 150,
//             child: TextButton(
//               child: Text("submit"),
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   // If the form is valid, display a Snackbar.
//                   _create();
//                 }
//               },
//             ),
//
//           ), Container(height:90,
//             child: ListView ( scrollDirection: Axis.horizontal,
//               children: [
//                 SelectSeatnumber("4", onTap, seatFieldNo[0], 0),
//                 SelectSeatnumber("5", onTap, seatFieldNo[1], 1),
//                 SelectSeatnumber("6", onTap, seatFieldNo[2], 2),
//                 SelectSeatnumber("7", onTap, seatFieldNo[3], 3)
//               ],
//             ),
//           ),
//
//        Align(alignment:Alignment.bottomLeft, child: FuelType())],
//         )),)
//     );
//   }
// }
//
// class SelectSeatnumber extends StatelessWidget {
//   final int field;
//   final int fieldSelected;
//   Function onTap;
//   final String seatNo;
//
//   SelectSeatnumber(this.seatNo, this.onTap, this.fieldSelected, this.field);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 10, right: 10),
//       height: 85,
//       width: 85,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(
//             10,
//           ),
//           border: Border.all(color: Colors.blueAccent, width: 3)),
//       child: TextButton(
//         style: TextButton.styleFrom(
//           minimumSize: Size.zero,
//           padding: EdgeInsets.zero,
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ),
//         onPressed: () {
//           onTap(field);
//         },
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.event_seat_outlined,
//                 size: 40,
//                 color: fieldSelected == 1 ? Colors.blueAccent : Colors.grey,
//               ),
//             ),
//             Text(
//               "4 seats ",
//               style: TextStyle(
//                   fontFamily: "Roboto",
//                   fontSize: 13,
//                   color:
//                   fieldSelected == 1 ? Colors.blueAccent : Colors.grey,
//                   fontWeight: FontWeight.w500),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FuelType extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(mainAxisSize:MainAxisSize.min,children: [
//         Container(height: 110, width: 100,
//
//         child: TextButton(style: TextButton.styleFrom(
//           minimumSize: Size.zero,
//           padding: EdgeInsets.zero,
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         ), onPressed: () {}, child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.event_seat_outlined,
//                 size: 40,
//                 color: Colors.grey,
//               ),
//             ),
//             Text(
//               "4 seats ",
//               style: TextStyle(
//                   fontFamily: "Roboto",
//                   fontSize: 13,
//                   color:
//                   Colors.grey,
//                   fontWeight: FontWeight.w500),
//             )
//           ],),),),
//         Container(height: 110, width: 100,
//
//           child: TextButton(style: TextButton.styleFrom(
//             minimumSize: Size.zero,
//             padding: EdgeInsets.zero,
//             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ), onPressed: () {}, child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Icon(
//                   Icons.event_seat_outlined,
//                   size: 40,
//                   color: Colors.grey,
//                 ),
//               ),
//               Text(
//                 "4 seats ",
//                 style: TextStyle(
//                     fontFamily: "Roboto",
//                     fontSize: 13,
//                     color:
//                     Colors.grey,
//                     fontWeight: FontWeight.w500),
//               )
//             ],),),),
//
//         ],),
//     );
//   }
// }

//
// // Row(
// // children: [
// // Container(
// // height: 100,
// // width: 100,
// // color: Colors.red,
// // child: imageAvailable == false
// // ? Image.asset("images/taxi.png")
// // : Image.file(_image!),
// // ),
// // SizedBox(
// // width: 5,
// // ),
// // Container(
// // child: TextButton(
// // onPressed: () async {
// // final img = await GetImage().getImage();
// // if (img != null) {
// // setState(() {
// // _image = img;
// // imageAvailable = true;
// // });
// // } else {
// // print("image not available null");
// // }
// // },
// // child: Text("pick img")),
// // height: 20,
// // width: 50,
// // color: Colors.blueAccent,
// // )
// // ],
// // )
//
//
//
//
//
//
//
//
//
