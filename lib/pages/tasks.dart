import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:testing/pages/add_task.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/pagethree.dart';
import 'package:testing/pages/swipe.dart';
import 'package:testing/pages/tasksswipe.dart';
import 'package:testing/pages/update_task.dart';
import 'package:html/parser.dart' show parse;

class Tasks extends StatefulWidget {
  Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskName1 = TextEditingController();
  TextEditingController taskDescription1 = TextEditingController();
  TextEditingController taskdeadline = TextEditingController();

  var x;

  Future<dynamic> fetchcontacts() async {
    //await check();
    print(tasksList);
    return tasksList.isEmpty ? orpc.callKw({
      'model': 'project.project',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'task_count', 'date_start', 'date'],
        'limit': 10,
      }
    }) : tasksList;
  }

  Widget builditem(Map<String, dynamic> record,
      SpeedDialDirection OpenDirection, double bottomMargin, bool ismanager,int managerId) {
    List<dynamic> assignedUsers = record['user_ids'];
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      margin:
          EdgeInsets.only(top: 10, left: 20, right: 20, bottom: bottomMargin),
      color: const Color.fromARGB(255, 120, 100, 156).withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(record['kanban_state'] == 'normal'
                  ? Icons.hourglass_empty
                  : record['kanban_state'] == 'done'
                      ? Icons.check
                      : Icons.crop_square),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    record['name'].toString(),
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white),
                  ),
                  Text(
                    'created at : ${record['create_date'] != false ? DateFormat('dd/MM/yyyy').format(DateTime.parse(record['create_date'])) : '/'}',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Text(
                    'ends at : ${record['date_deadline'] != false ? DateFormat('dd/MM/yyyy').format(DateTime.parse(record['date_deadline'])) : '/'}',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            ismanager == false
                ? SpeedDial(
                    direction: OpenDirection,
                    spacing: 7,
                    spaceBetweenChildren: 7,
                    animationCurve: Curves.easeInOut,
                    animationDuration: const Duration(milliseconds: 300),
                    animatedIcon: AnimatedIcons.menu_close,
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.3,
                    elevation: 0,
                    children: [
                      SpeedDialChild(
                        child: const Icon(Iconsax.task),
                        label: "complete task",
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Task completed ?",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text(
                                          "No",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          //await check();
                                          var res = await orpc.callKw({
                                            'model': 'project.task',
                                            'method': 'write',
                                            'args': [
                                              record['id'],
                                              {'kanban_state': 'done'}
                                            ],
                                            'domain': [],
                                            'kwargs': {}
                                          });
                                          print("completed");
                                          Fluttertoast.showToast(
                                          msg: "Task completed !",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                        sendNotificaton(
                                            "Task Completed",
                                            "task " +
                                                record['name'] +
                                                " completed in project : $ProjectName",
                                            managerId.toString());
                                        Navigator.pop(context);
                                          return res;                                          
                                        },
                                        child: const Text("Yes",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                );
                              });
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.description),
                        label: "See details",
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Center(
                                        child: Text(
                                      'Task description',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    content: Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Text(
                                        record['description'] == false
                                            ? "there's no description"
                                            : parse(record['description'])
                                                .documentElement!
                                                .text,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ));
                              });
                        },
                      ),
                    ],
                  )
                : SpeedDial(
                    direction: OpenDirection,
                    spacing: 7,
                    spaceBetweenChildren: 7,
                    animationCurve: Curves.easeInOut,
                    animationDuration: const Duration(milliseconds: 300),
                    animatedIcon: AnimatedIcons.menu_close,
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.3,
                    elevation: 0,
                    children: [
                      SpeedDialChild(
                        child: const Icon(Icons.delete),
                        label: "delete",
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Delete this task ?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text(
                                        "No",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                       // await check();
                                        var res = await orpc.callKw({
                                          'model': 'project.task',
                                          'method': 'unlink',
                                          'args': [
                                            [record['id']],
                                          ],
                                          'domain': [],
                                          'kwargs': {}
                                        });
                                        refresh();
                                        sendNotificaton(
                                            "Task Removed",
                                            "task " +
                                                record['name'] +
                                                " removed from project : $ProjectName",
                                            ProjectId.toString());
                                        Fluttertoast.showToast(
                                          msg: "Task removed",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                        Get.back();
                                        return res;
                                      },
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.update),
                        label: "update",
                        onTap: () {
                          Get.to(UpdateTask(), arguments: record);
                          
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.description),
                        label: "See description",
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Center(
                                        child: Text(
                                      'Task description',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    content: Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Text(
                                        record['description'] == false
                                            ? "there's no description"
                                            : parse(record['description'])
                                                .documentElement!
                                                .text,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        maxLines: 3,
                                      ),
                                    ));
                              });
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
  }

  var tasksList = [];
  String searchWord = "";
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          color: const Color.fromARGB(255, 120, 100, 156),
          onRefresh: refresh,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: Get.height * 0.05),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                      ),
                      child: TextField(
                        cursorColor: const Color.fromARGB(255, 120, 100, 156),
                        obscureText: false,
                        decoration: InputDecoration(
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 120, 100, 156),
                                  width: 2),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 120, 100, 156),
                                  width: 2),
                            ),
                            errorStyle: const TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 120, 100, 156)),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 120, 100, 156)),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 120, 100, 156),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            labelText: 'Search',
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 120, 100, 156),
                                fontSize: 15),
                            hintText: 'Search',
                            hintStyle:
                                const TextStyle(color: Colors.transparent)),
                        onChanged: (value) {
                          setState(() {
                            searchWord = value;
                          });
                        },
                        //controller: searchController,
                      ),
                    )),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchtasks(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      tasksList = snapshot.data;
                      print('---------------------');

                      List<dynamic> filteredData = tasksList
                          .where((element) => element['name']
                              .toLowerCase()
                              .contains(searchWord))
                          .toList();
                      return tasksList.length != 0
                          ? ListView.builder(
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                //print(filteredData.length);
                                final record =
                                    filteredData[index] as Map<String, dynamic>;

                                //print(record);
                                return FadeInUp(
                                    child: index >= filteredData.length - 1
                                        ? index == filteredData.length - 1
                                            ? builditem(
                                                record,
                                                SpeedDialDirection.up,
                                                70.0,
                                                tasksList[0]['manager_id'][0] ==
                                                        session.userId
                                                    ? true
                                                    : false,tasksList[0]['manager_id'][0])
                                            : builditem(
                                                record,
                                                SpeedDialDirection.up,
                                                20.0,
                                                tasksList[0]['manager_id'][0] ==
                                                        session.userId
                                                    ? true
                                                    : false,tasksList[0]['manager_id'][0])
                                        : index == filteredData.length - 1
                                            ? builditem(
                                                record,
                                                SpeedDialDirection.down,
                                                70.0,
                                                tasksList[0]['manager_id'][0] ==
                                                        session.userId
                                                    ? true
                                                    : false,tasksList[0]['manager_id'][0])
                                            : builditem(
                                                record,
                                                SpeedDialDirection.down,
                                                20.0,
                                                tasksList[0]['manager_id'][0] ==
                                                        session.userId
                                                    ? true
                                                    : false,tasksList[0]['manager_id'][0]));
                              },
                            )
                          : const Text("there's no tasks !");
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Get.to(AddTask());
        },
        backgroundColor: Colors.white,
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
      ),
    );
  }

  Future<void> refresh() async {
    tasksList = await fetchtasks();
    setState(() {
      tasksList = tasksList;
    });
    print("refresh");
  }

  void searchTask(String value) {
    final suggestions = tasksList.where((task) {
      final taskname = task['name'].toString().toLowerCase();
      final input = value.toLowerCase();
      return taskname.contains(input);
    }).toList();
    setState(() {
      tasksList = suggestions;
    });
    print(tasksList);
  }
}
