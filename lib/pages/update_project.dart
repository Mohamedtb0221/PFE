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

class Update_project extends StatefulWidget {
  Update_project({super.key});

  @override
  State<Update_project> createState() => _Update_projectState();
}

class _Update_projectState extends State<Update_project> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskdeadline = TextEditingController();
  TextEditingController taskStart = TextEditingController();
  var record = Get.arguments;
  Future updateProject(
    String name,
    String description,
    String startdate,
    String deadline,
  ) async {
    //await check();
    print(record['name']);
    print(record['description']);
    print(record['date_start']);
    print(record['date']);
    var res = await orpc.callKw({
      'model': 'project.project',
      'method': 'write',
      'args': [
         record['id'],
        {
          'name':  name.isEmpty ? record['name'] : name,
          'description': description.isEmpty ?record['description'] : description,
          'date_start': startdate.isEmpty ? record['date_start'] : startdate,
          'date': deadline.isEmpty ? record['date'] : deadline,
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
                  "update your project",
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
                            hintText: 'project deadline date',
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
                                  if (taskStart.text.isEmpty ) {
                                    taskStart.text=record['date_start'];
                                  }
                                  if (taskdeadline.text.isEmpty) {
                                    taskdeadline.text=record['date'];
                                  }
                                  if (DateTime.parse(taskStart.text).isBefore(
                                            DateTime.parse(
                                                taskdeadline.text)) &&
                                        DateTime.parse(taskStart.text)
                                            .isAfter(DateTime.now())) {

                                    await updateProject(
                                    taskName.text,
                                    taskDescription.text,
                                    taskStart.text,
                                    taskdeadline.text,
                                  );
                                  Fluttertoast.showToast(
                                    msg: "Project updated !",
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                  /*sendNotificaton(
                                            "Task added",
                                            "task '${taskName.text}' added in project : $ProjectName",
                                            ProjectId.toString());*/

                                  Get.back();
                                  }else{
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
                                  
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color.fromARGB(
                                          255, 120, 100, 156)),
                                  child: const Text(
                                    "Save",
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
