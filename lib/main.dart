import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testing/pages/offline.dart';
import 'package:testing/pages/swipe.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    home:await checkConnection()? await testLogin() ? const Swipe() : const LoginPage() : const Offline(),
  ));
}
bool connected = true;
testLogin()async{
  
  box1 = await Hive.openBox('loginData');
  if (box1.get('username') != null && box1.get('password') != null){
    x = await orpc.authenticate('testdb',
                            box1.get('username'), box1.get('password'));
                        name = box1.get('username');
                        pass = box1.get('password');
    session = x;
    return true;
  }
  return false;
}
checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      connected = false;
      print("----------------$connected");
    } else {
      connected = true;
      print("----------------$connected");
    }
    return connected;
  }
late Box box1;
late Box box3;
  void createBox() async {
    box1 = await Hive.openBox('loginData');
    box3 = await Hive.openBox('loginDataRemembered');
    getData();
  }

  void getData() async {
    if (box3.get('username') != null) {
      usernameController.text = box3.get('username');
    }    
  }



