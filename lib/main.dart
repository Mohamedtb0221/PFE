import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:testing/pages/login.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {

  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(    
    theme: ThemeData(
      fontFamily: 'myfont',
      primaryColor:const Color.fromARGB(255, 120, 100, 156),
      //primarySwatch: Colors.grey,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary:const Color.fromARGB(255, 120, 100, 156),
        ),
      ),
    ),
    debugShowCheckedModeBanner: false,
    home:const LoginPage(),
  ));
}


