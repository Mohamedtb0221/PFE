// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:testing/pages/gantt.dart';
import 'package:testing/pages/login.dart';
import 'package:testing/pages/notifications_history.dart';
import 'package:testing/pages/swipe.dart';
import 'home_page.dart';

final orpc = OdooClient('http://192.168.1.103:8069/');
late Box box2;
var session;
Future<dynamic> check() async {
  session = await orpc.authenticate('testdb', name, pass);  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 100, 156),
        title: const Text(
          "Home Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Get.to(() => NotificationHistory());
                },
                icon: Icon(Icons.notifications)),
          )
        ],
      ),
      body: const mywidget(),
    );
  }
}

class mywidget extends StatefulWidget {
  const mywidget({super.key});

  @override
  State<mywidget> createState() => _mywidgetState();
}

class _mywidgetState extends State<mywidget> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInDown(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome here   ",
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  session.userName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () async {
                
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Container(
                  width: 150,
                  height: 50,
                  child: Center(
                    child: const Text(
                      "Contacts",
                      style: TextStyle(fontSize: 19),
                    ),
                  ))),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GanttChart()));
              },
              child: Container(
                  width: 150,
                  height: 50,
                  child: Center(
                    child: const Text(
                      "Projects",
                      style: TextStyle(fontSize: 19),
                    ),
                  ))),
        ],
      ),
    );
  }

  
}
