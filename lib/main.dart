import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/enlist_car_screen.dart';
import 'test_file.dart';
import "screens/booking_screen.dart";




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseAuth.instance.currentUser!=null?Test():
  runApp(MaterialApp(home: FirebaseAuth.instance.currentUser!=null?ListingScreen(FirebaseAuth.instance.currentUser!.uid):RegisterScreen()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container(child:Text("hello world"))));
  }
}
