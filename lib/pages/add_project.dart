import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:testing/pages/pagethree.dart';
import 'package:testing/pages/swipe.dart';
import '../components/my_formtextfield.dart';
import 'controller/controller.dart';
import 'home.dart';

class add_project extends StatefulWidget {
  add_project({super.key});

  @override
  State<add_project> createState() => _add_projectState();
}

class _add_projectState extends State<add_project> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskdeadline = TextEditingController();
  TextEditingController taskStart = TextEditingController();

  Future addProject(
    String name,
    String description,
    String startdate,
    String deadline,
  ) async {
    // await check();
    var res = await orpc.callKw({
      'model': 'project.project',
      'method': 'create',
      'args': [
        {
          'name': name,
          'description': description,
          'date_start': startdate,
          'date': deadline,
        },
      ],
      'domain': [],
      'kwargs': {}
    });
    print("added");

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: Get.height * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios))),
              const Padding(
                padding: EdgeInsets.only(left: 38.0, top: 20, bottom: 30),
                child: Text(
                  "Add a project",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(137, 3, 3, 3)),
                ),
              ),
              Center(
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MyTextFormField(
                            controller: taskName,
                            hintText: 'Project Name',
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MyTextFormField(
                            controller: taskDescription,
                            hintText: 'project Description',
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          MyTextFormField(
                            controller: taskStart,
                            hintText: 'project start date',
                            obscureText: false,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                showDatePicker(
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Color.fromARGB(
                                                    255,
                                                    120,
                                                    100,
                                                    156), // <-- SEE HERE
                                                // <-- SEE HERE
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  // ignore: deprecated_member_use
                                                  primary: const Color.fromARGB(
                                                      255,
                                                      120,
                                                      100,
                                                      156), // button text color
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2035))
                                    .then((value) {
                                  setState(() {
                                    taskStart.text =
                                        DateFormat('yyyy-MM-dd').format(value!);
                                  });
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          MyTextFormField(
                            controller: taskdeadline,
                            hintText: 'project end date',
                            obscureText: false,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                showDatePicker(
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Color.fromARGB(
                                                    255,
                                                    120,
                                                    100,
                                                    156), // <-- SEE HERE
                                                // <-- SEE HERE
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  // ignore: deprecated_member_use
                                                  primary: const Color.fromARGB(
                                                      255,
                                                      120,
                                                      100,
                                                      156), // button text color
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2035))
                                    .then((value) {
                                  setState(() {
                                    taskdeadline.text =
                                        DateFormat('yyyy-MM-dd').format(value!);
                                  });
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color.fromARGB(
                                          255, 120, 100, 156)),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (taskName.text.isNotEmpty &&
                                      taskDescription.text.isNotEmpty &&
                                      taskStart.text.isNotEmpty &&
                                      taskdeadline.text.isNotEmpty) {
                                    if (DateTime.parse(taskStart.text).isBefore(
                                            DateTime.parse(
                                                taskdeadline.text)) &&
                                        DateTime.parse(taskStart.text)
                                            .isAfter(DateTime.now())) {
                                      await addProject(
                                        taskName.text,
                                        taskDescription.text,
                                        taskStart.text,
                                        taskdeadline.text,
                                      );
                                      Fluttertoast.showToast(
                                        msg: "Project added !",
                                        toastLength: Toast.LENGTH_SHORT,
                                      );

                                      /*sendNotificaton(
                                            "Task added",
                                            "task '${taskName.text}' added in project : $ProjectName",
                                            ProjectId.toString());*/

                                      Get.back();
                                    } else {
                                      Flushbar(
                                        title: "Error !",
                                        message:
                                            "invalid start date or end date",
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
                                      ).show(context);
                                    }
                                  } else {
                                    Flushbar(
                                        title: "Error !",
                                        message:
                                            "fill all the fields Please !",
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
                                      ).show(context);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color.fromARGB(
                                          255, 120, 100, 156)),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
