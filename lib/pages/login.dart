// ignore_for_file: empty_catches

import 'package:animate_do/animate_do.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:testing/components/LoginPageComponents/PasswordTextfield.dart';
import 'package:testing/components/LoginPageComponents/UsernameTextfiled.dart';
import 'package:testing/main.dart';
import 'package:testing/pages/home.dart';
import 'package:get/get.dart';
import 'package:testing/pages/swipe.dart';
import '../components/my_button.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

String name = '';
String pass = '';
bool? isChecked = false;
final usernameController = TextEditingController();
final passwordController = TextEditingController();
bool visiblePass = true;
var x;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void showflushbar(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.all(20),
      icon: const Icon(
        Icons.warning,
        size: 35,
        color: Colors.white,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 120, 100, 156),
    ).show(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBox();    
  }
  var isloading=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 120,
                  color: Color.fromARGB(255, 120, 100, 156),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Welcome back you',
                  style: TextStyle(
                      color: Color.fromARGB(255, 120, 100, 156),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 35),
                const UsernameTextfield(),
                const SizedBox(height: 30),
                const PasswordTextfield(),
                const SizedBox(height: 30),
                FadeInUp(
                  duration: const Duration(milliseconds: 550),
                  delay: const Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CheckboxListTile(
                      title: Text("Remember me"),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 120, 100, 156),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 1100),
                  child: MyButton(
                    text:isloading ? const Text(
                      " Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          letterSpacing: 1),
                    ) :const SpinKitThreeInOut(
                      color: Colors.white,
                      size: 20,
                    ),
                    onTap: () async {
                      name = usernameController.text;
                      pass = passwordController.text;
                      setState(() {
                        isloading=!isloading;
                      }); 
                      try {
                        print(name);
                        print(pass);
                        x = await orpc.authenticate('testdb',
                            usernameController.text, passwordController.text);
                        name = usernameController.text;
                        pass = passwordController.text;
                        session = x;
                        print(x);
                        // ignore: unused_catch_clause
                      } on OdooException catch (e) {
                      } finally {
                        if (x == null) {
                          setState(() {
                        isloading=!isloading;
                      }); 
                          showflushbar(
                              "Error !", "wrong password or username ");
                        } else {
                          print('connected');
                          if (isChecked!) {
                            box1.put('username', name);
                            box1.put('password', pass);
                            box3.put('username', name);                            
                          }
                          Get.off(() => const Swipe(),
                              transition: Transition.downToUp);
                          Fluttertoast.showToast(
                            msg: "Connected",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
