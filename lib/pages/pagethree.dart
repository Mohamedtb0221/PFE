import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/notifications_history.dart';
import 'package:testing/pages/tasks.dart';
import 'package:testing/pages/tasksswipe.dart';
import 'package:testing/pages/update_project.dart';
import 'add_project.dart';

int ProjectId = 0;
int managerId = 0;
String ProjectName = "";
String Project_deadline = "";

bool is_admin = false;
Future<dynamic> isAdmin() async {
  //await check();
  var res = await orpc.callKw({
    'model': 'res.users',
    'method': 'search_read',
    'args': [],
    'kwargs': {
      'context': {'bin_size': true},
      'domain': [
        ['id', '=', session.userId]
      ],
      'fields': ['id', 'groups_id'],
      'limit': 1,
    }
  });
  List permissions = res[0]['groups_id'];

  if (permissions.contains(17)) {
    return is_admin = true;
  } else {
    return is_admin = false;
  }
}

Future<dynamic> fetchProjects() async {
  //await check();

  return await orpc.callKw({
    'model': 'project.project',
    'method': 'search_read',
    'args': [],
    'kwargs': {
      'context': {'bin_size': true},
      'domain': [],
      'fields': [
        'id',
        'name',
        'description',
        'task_count',
        'date_start',
        'date',
        'user_id'
      ],
      'limit': 50,
    }
  });
}

class pagethree extends StatefulWidget {
  pagethree({super.key});

  @override
  State<pagethree> createState() => _pagethreeState();
}

class _pagethreeState extends State<pagethree> {
  Future<dynamic> fetchtasks(id) async {
    //await check();
    return orpc.callKw({
      'model': 'project.task',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['project_id', '=', id]
        ],
        'fields': [
          'id',
          'name',
        ],
        'limit': 10,
      }
    });
  }

  Widget builditem(Map<String, dynamic> record) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        //set border radius more than 50% of height and width to make circle
      ),
      margin: const EdgeInsets.all(20),
      color: const Color.fromARGB(255, 120, 100, 156).withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              record['name'].toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'from : ${record['date_start'] != false ? record['date_start'] : '---'}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            Text(
              'to : ${record['date'] != false ? record['date'] : '---'}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            Text(
              "${record['task_count']} tasks",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    isAdmin();
    print("---------------");
    print(is_admin);
    print("---------------");
  }

  var record;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 100, 156),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        title: const Text(
          "Projects",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
      body: Center(
        child: RefreshIndicator(
          color: const Color.fromARGB(255, 120, 100, 156),
          onRefresh: refresh,
          child: FutureBuilder(
            future: fetchProjects(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final record = snapshot.data[index] as Map<String, dynamic>;
                    return FadeIn(
                      child: GestureDetector(
                        child: builditem(record),
                        onLongPress: () async {
                          print("long pressed ");
                          is_admin
                              ? showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30))),
                                  builder: (context) {
                                    return Container(
                                      height: Get.height * 0.35,
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(Update_project(),
                                                  transition:
                                                      Transition.rightToLeft,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  arguments: record);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              height: 55,
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(),
                                                    flex: 4,
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "Update",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const Expanded(
                                                      flex: 3,
                                                      child: Icon(
                                                        Iconsax.edit,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        title: const Center(
                                                            child: Text(
                                                          'Project details',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                        content: Container(
                                                          height:
                                                              Get.height * 0.5,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 25.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                RichText(
                                                                  text: TextSpan(
                                                                      children: [
                                                                        const TextSpan(
                                                                          text:
                                                                              "manager :",
                                                                          style:
                                                                              TextStyle(
                                                                                fontSize: 18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                                color: Colors.black,
                                                                            decoration:
                                                                                TextDecoration.underline,
                                                                          ),
                                                                        ),
                                                                        TextSpan(
                                                                          // ignore: prefer_interpolation_to_compose_strings
                                                                          text: " "+record['user_id'][1] ,
                                                                          style:
                                                                              const TextStyle(
                                                                                color: Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        )
                                                                      ]),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                RichText(
                                                                  text: TextSpan(
                                                                      children: [
                                                                        const TextSpan(
                                                                          text:
                                                                              "description :",
                                                                          style:
                                                                              TextStyle(
                                                                                fontSize: 18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                                color: Colors.black,
                                                                            decoration:
                                                                                TextDecoration.underline,
                                                                          ),
                                                                        ),
                                                                        TextSpan(
                                                                          // ignore: prefer_interpolation_to_compose_strings, unrelated_type_equality_checks
                                                                          text: record['description'] == false || record['description'] == ""
                                                                              ? " there's no description"
                                                                              : " ${parse(record['description']).documentElement!.text}",
                                                                          style:
                                                                              const TextStyle(
                                                                                color: Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        
                                                                      ]),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                RichText(
                                                                  text: TextSpan(
                                                                      children: [
                                                                        const TextSpan(
                                                                          text:
                                                                              "days left :",
                                                                          style:
                                                                              TextStyle(
                                                                                fontSize: 18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                                color: Colors.black,
                                                                            decoration:
                                                                                TextDecoration.underline,
                                                                          ),
                                                                        ),
                                                                        TextSpan(
                                                                          // ignore: prefer_interpolation_to_compose_strings, unrelated_type_equality_checks
                                                                          text: " "+int.parse(formatDuration(DateTime.parse(record['date']).difference(DateTime.now()))).toString()+" days",
                                                                          style:
                                                                              const TextStyle(
                                                                                color: Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        
                                                                      ]),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ));
                                                  });
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              height: 55,
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(),
                                                    flex: 4,
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "Details",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const Expanded(
                                                      flex: 3,
                                                      child: Icon(
                                                        Iconsax.clipboard_text,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Delete this project ?",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            "No",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                      TextButton(
                                                          onPressed: () async {
                                                            //await check();
                                                            var res = await orpc
                                                                .callKw({
                                                              'model':
                                                                  'project.project',
                                                              'method':
                                                                  'unlink',
                                                              'args': [
                                                                [record['id']],
                                                              ],
                                                              'domain': [],
                                                              'kwargs': {}
                                                            });
                                                            refresh();
                                                            /*sendNotificaton(
                                            "Task Removed",
                                            "task " +
                                                record['name'] +
                                                " removed from project : $ProjectName",
                                            ProjectId.toString());*/
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "project removed",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                            );
                                                            Get.back();
                                                            return res;
                                                          },
                                                          child: const Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                  color: Colors.red.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              height: 55,
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(),
                                                    flex: 4,
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      "Delete",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const Expanded(
                                                      flex: 3,
                                                      child: Icon(
                                                        Iconsax.trash,
                                                        color: Colors.white,
                                                      ))
                                                ],
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : null;
                        },
                        onTap: () {
                          print(record['id']);
                          ProjectId = record['id'];
                          ProjectName = record['name'];
                          Project_deadline = record['date'];
                          managerId = record['user_id'][0];
                          Get.to(
                            () => TasksSwipe(),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                if (snapshot.hasError) {
                  return const Text("something went wrong");
                }
                return const SpinKitFadingFour(
                  color: Color.fromARGB(255, 120, 100, 156),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: isAdmin(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if (snapshot.data) {
              return FloatingActionButton.extended(
                onPressed: () {
                  Get.to(
                    add_project(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 400),
                  );
                },
                backgroundColor: Colors.white,
                tooltip: 'Increment',
                elevation: 30,
                label: const Text(
                  "Add",
                  style: TextStyle(color: Color.fromARGB(255, 120, 100, 156)),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 120, 100, 156),
                  size: 30,
                ),
              );
            } else {
              return const SizedBox(
                width: 0,
                height: 0,
              );
            }
          } else {
            return const SizedBox(
              width: 0,
              height: 0,
            );
          }
        },

        /* FloatingActionButton.extended(
          onPressed: () {
            Get.to(add_project());
          },
          backgroundColor: Colors.white,
          tooltip: 'Increment',
          elevation: 30,
          label: const Text(
            "Add",
            style: TextStyle(color: Color.fromARGB(255, 120, 100, 156)),
          ),
          icon: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 120, 100, 156),
            size: 30,
          ),
             ),*/
      ),
    );
  }
  String formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String formattedDuration = days.toString();

    return formattedDuration;
  }

  Future<void> refresh() async {
    record = await fetchProjects();
    setState(() {
      record = record;
    });
    print("refresh");
  }
}
