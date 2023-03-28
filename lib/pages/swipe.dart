import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/login.dart';
import 'package:testing/pages/pagethree.dart';
import 'package:testing/pages/pagetwo.dart';
import 'package:http/http.dart' as http;

final FirebaseMessaging messaging = FirebaseMessaging.instance;
  getMessage() {
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification!.title);
      print(event.notification!.body);
      print(event.data["name"]);
    });
  }

    sendNotificaton(String title, String body,String topic) async {
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            "name": "mohamed"
          },
          'to': "/topics/$topic",
        },
      ),
    );
  }

class Swipe extends StatefulWidget {
  const Swipe({super.key});

  @override
  State<Swipe> createState() => _SwipeState();
}

int selectedIndex = 0;
final pageController = PageController();
var serverToken =
    'AAAAx9sUnmk:APA91bE02Eq8rS9HxtVwMkr4qtkENDjitACn2eYDm4em2c8dEqm1825VTxjyLD61catLpjsIlTnGukSpu-dXmMPMqAY32heILdo5iSuC1JINpd1YCFKvxRYhnmf9uHcxKs8zi5-NBW6g';

class _SwipeState extends State<Swipe> {
  @override
  void initState() { 
    UserTopics();   
    messaging.getToken().then((value) {
      print(value);
    });
    //getMessage();
    super.initState();
    setState(() {
      selectedIndex = 0;
    });
  }



  UserTopics() async {
    List projects = await fetchProjects();
    for (var project in projects) {
      print(project['id']);
      messaging.subscribeToTopic(project['id'].toString());
    }    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 120, 100, 156),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: GNav(
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.black26,
              padding: const EdgeInsets.all(16),
              tabMargin: const EdgeInsets.all(1),
              gap: 8,
              tabs: [
                const GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                const GButton(
                  icon: Icons.work,
                  text: 'Projects',
                ),
                const GButton(
                  icon: Icons.contact_page,
                  text: 'Contacts',
                ),
                GButton(
                  icon: Icons.logout,
                  text: 'Log out',
                  onPressed: () {
                    Get.offAll(() => const LoginPage(),
                        transition: Transition.downToUp);

                    print(selectedIndex);
                  },
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                  pageController.animateToPage(selectedIndex,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear);
                });
              },
            ),
          ),
        ),
        body: PageView(
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          controller: pageController,
          children: [
            const MyApp(),
            pagethree(),
            pagetwo(),
          ],
        ));
  }
}
