import 'package:animate_do/animate_do.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:testing/pages/pagethree.dart';
import 'package:testing/pages/profil.dart';
import 'home.dart';
import 'notifications_history.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int project_id = 0;
  Future<dynamic> fetchtasks() async {
    await check();

    var res = await orpc.callKw({
      'model': 'project.task',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['stage_id', '!=', 3],
          ['kanban_state','!=','done'],
          ['user_ids', 'in', session.userId]
        ],
        'fields': [
          'id',
          'name',
          'create_date',
          'description',
          'date_deadline',
        ],
        'limit': 20,
      }
    });

    return res;
  }

  Future<dynamic> fetchProjects() async {
    await check();
    return await orpc.callKw({
      'model': 'project.project',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['id', '=', project_id]
        ],
        'fields': ['id', 'name'],
        'limit': 1,
      }
    });
  }

  var selecteddate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 100, 156),
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        /*title: const Text(
          "Home Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),*/
        actions: [
          GestureDetector(
              /*onTap: () {
              Get.to(const ProfilPage());
            },*/
              child: Center(
                  child: Text(session.userName,
                      style: const TextStyle(
                        fontSize: 15,
                      )))),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 5),
            child: IconButton(
                onPressed: () {
                  Get.to(() => const NotificationHistory());
                },
                icon: const Icon(Icons.notifications)),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: GoogleFonts.lato(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 70,
              initialSelectedDate: DateTime.now(),
              selectionColor: Colors.black26,
              selectedTextColor: Colors.white,
              dateTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
              onDateChange: (selectedDate) {
                setState(() {
                  selecteddate = selectedDate;
                });
                print(selecteddate);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
                future: fetchtasks(),
                builder: (context, snapshot) {
                  var mytasks = [];
                  if (snapshot.hasData) {
                    mytasks = snapshot.data;
                    List<dynamic> filteredData = mytasks
                        .where((element) =>
                            element['date_deadline'] != false &&
                            DateTime.parse(element['create_date'])
                                .isBefore(selecteddate) &&
                            DateTime.parse(element['date_deadline'])
                                .isAfter(selecteddate))
                        .toList();
                    print('----------------------');
                    print(filteredData);
                    print('----------------------');
                    return filteredData.length != 0
                        ? Column(
                            children: [
                              Text(
                                "Current tasks",
                                style: GoogleFonts.lato(
                                    fontSize: 21, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filteredData.length,
                                  itemBuilder: (context, index) {
                                    final record = filteredData[index]
                                        as Map<String, dynamic>;
                                    return FadeInRight(
                                      child: Container(
                                        margin: const EdgeInsets.all(17),
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              record['name'].toString(),
                                              style: const TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: Colors.white),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'From : ${record['create_date'] != false ? DateFormat('dd/MM/yyyy').format(DateTime.parse(record['create_date'])) : '/'}',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white70),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'To : ${record['date_deadline'] != false ? DateFormat('dd/MM/yyyy').format(DateTime.parse(record['date_deadline'])) : '/'}',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white70),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 100),
                            child: Text(
                              "You have no tasks today !",
                              style: GoogleFonts.lato(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          );
                  } else {
                    if (snapshot.hasError) {
                      return const Text("something went wrong");
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 120, 100, 156),
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
