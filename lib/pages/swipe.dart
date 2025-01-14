import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/login.dart';
import 'package:testing/pages/pagethree.dart';
import 'package:testing/pages/pagetwo.dart';
import 'package:http/http.dart' as http;
import 'package:testing/pages/profil.dart';
import 'home_page.dart';

final FirebaseMessaging messaging = FirebaseMessaging.instance;
List<dynamic> recievedNotifications = [];
getMessage() {
  FirebaseMessaging.onMessage.listen((event) {
    var day = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var time = DateFormat('hh:mm a').format(DateTime.now());
    dynamic data = {
      'id': session.userId,
      'title': event.notification!.title,
      'body': event.notification!.body,
      'day': day,
      'time': time,
    };
    recievedNotifications.insert(0, data);
    //recievedNotifications.clear();
    box2.put('notification', recievedNotifications);
    
    print(event.notification!.title);
    print(event.notification!.body);
  });
}

void createNotifBox() async {
  box2 = await Hive.openBox('NotificationData');
  getData();
}

void getData() async {
  if (box2.get('notification') != null) {
    List<dynamic> data = box2.get('notification');
    recievedNotifications =
        data.where((element) => element['id'] == session.userId).toList();
  }
}

sendNotificaton(String title, String body, String topic) async {
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

Future<dynamic> fetchalltasks() async {
  //await check();
  var res = await orpc.callKw({
    'model': 'project.task',
    'method': 'search_read',
    'args': [],
    'kwargs': {
      'context': {'bin_size': true},
      'domain': [
        ['project_id', '!=', false],
        ['stage_id', '!=', 3],
      ],
      'fields': [
        'project_id',
        'user_ids',
        'kanban_state',
        'id',
        'name',
        'create_date',
        'manager_id',
        'description',
        'date_deadline',
      ],
      'limit': 50,
    }
  });

  return res;
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
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(hours: 12), (timer) async {
      var tasks = await fetchalltasks();
      for (var task in tasks) {
        if (task['date_deadline'] != false) {
          if (int.parse(formatDuration(DateTime.parse(task['date_deadline'])
                  .difference(DateTime.now()))) ==
              0) {
            if (session.userId == task['manager_id'][0]) {
              for (var id in task['user_ids']) {
                print(id.toString());

                sendNotificaton(
                    "Attention",
                    "the deadline is in less than 24 hours for the task ${task['name']}",
                    id.toString());
              }
            }
          }
        }
      }
    });
    timer.cancel();
  }

  String formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String formattedDuration = days.toString();

    return formattedDuration;
  }

  @override
  void initState() {
    print(session);
    //startTimer();
    createNotifBox();
    UserTopics();
    messaging.getToken().then((value) {
      //print(value);
    });
    getMessage();
    print("-------------------");
    //print(session.userId);

    super.initState();
    setState(() {
      selectedIndex = 0;
    });
  }

  UserTopics() async {
    //List projects = await fetchProjects();
    messaging.subscribeToTopic(session.userId.toString());

    //for (var project in projects) {
      //print(project['id']);
      //messaging.subscribeToTopic(project['id'].toString());
      //messaging.subscribeToTopic(session.userId.toString());
    //}
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
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.work,
                  text: 'Projects',
                ),
                GButton(
                  icon: Icons.contact_page,
                  text: 'Contacts',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profil',
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
            const HomePage(),
            pagethree(),
            pagetwo(),
            const ProfilPage(),
          ],
        ));
  }
}
