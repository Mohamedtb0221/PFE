import 'package:animate_do/animate_do.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:testing/pages/swipe.dart';

import '../components/my_button.dart';
import '../main.dart';
import 'login.dart';

class Offline extends StatelessWidget {
  const Offline({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInUp(
        child: Column(
          children: [
            Container(
              height: 400,
              width: 500,
              padding: EdgeInsets.only(top: 90),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 120, 100, 156),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      width: 2, color: const Color.fromARGB(255, 120, 100, 156))),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: const Image(
                    image: AssetImage('assets/images/offline.jpg'),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Oops!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(height: 25),
            const Text(
              "There is no internet connection \nPlease check your internet connection",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 18),
            ),
            const SizedBox(height: 100,),
            GestureDetector(
        onTap: ()async{
      
          await checkConnection()? await testLogin() ? Get.to(const Swipe()) :Get.to( const LoginPage()) : Flushbar(
                                          title: "Oops !",
                                          message:
                                              "you still offline",
                                          duration: const Duration(seconds: 3),
                                          padding: const EdgeInsets.all(20),
                                          icon: const Icon(
                                            Icons.warning,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                          flushbarPosition: FlushbarPosition.TOP,
                                          backgroundColor: const Color.fromARGB(
                                              255, 120, 100, 156),
                                        ).show(context);;
        },
        child: Container(
          width: 150,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,          
            borderRadius: BorderRadius.circular(30),
            boxShadow: const[
               BoxShadow(
                color: Color.fromARGB(255, 120, 100, 156),
                spreadRadius: 3,
                blurRadius: 8
              )
            ]
          ),
          child: const Center(
            child: Text("try again",style: TextStyle(
              
                            color: Color.fromARGB(255, 120, 100, 156),
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            letterSpacing: 0),),
          ),
        ),
          )
          ],
        ),
      ),
    );
  }
}
