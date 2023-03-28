import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:testing/pages/controller/controller.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/pagethree.dart';
import 'package:testing/pages/swipe.dart';
import '../components/my_formtextfield.dart';
import '../components/my_textfield.dart';
import 'add_project.dart';
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

  Future<dynamic> fetchtasks() async {
    await check();
    var res = await orpc.callKw({
      'model': 'project.task',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['project_id', '=', ProjectId],
          ['user_ids', 'in', session.userId]
        ],
        'fields': [
          'id',
          'name',
          'create_date',
          'stage_id',
          'description',
          'date_deadline'
        ],
        'limit': 10,
      }
    });

    return res;
  }

  Future addTask(String name, String description,String deadline) async {
    await check();

    var res = await orpc.callKw({
      'model': 'project.task',
      'method': 'create',
      'args': [
        {'name': name, 'description': description,'date_deadline':deadline, 'project_id': ProjectId},
      ],
      'domain': [],
      'kwargs': {}
    });
    print("added");

    return res;
  }

  var x;

  Future<dynamic> fetchcontacts() async {
    await check();
    return orpc.callKw({
      'model': 'project.project',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'task_count', 'date_start', 'date'],
        'limit': 10,
      }
    });
  }

  Widget builditem(Map<String, dynamic> record) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 20,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
      color: const Color.fromARGB(255, 120, 100, 156).withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  record['name'].toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white),
                ),
                Text(
                  'created at : ${record['create_date'] != false ? DateFormat.yMd().format(DateTime.parse(record['create_date'])) : '/'}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  'ends at : ${record['date_deadline'] != false ? DateFormat.yMd().format(DateTime.parse(record['date_deadline'])) : '/'}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            SpeedDial(
              direction: SpeedDialDirection.down,
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
                    await check();
                    var res = await orpc.callKw({
                      'model': 'project.task',
                      'method': 'unlink',
                      'args': [
                        [record['id']],
                      ],
                      'domain': [],
                      'kwargs': {}
                    });
                    print(record);
                    setState(() {
                      tasksList.remove(record);
                    });
                    sendNotificaton("Task Removed", "task removed from project : $ProjectId", ProjectId.toString());
                    return res;
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.update),
                  label: "update",
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Center(
                                child: Text(
                              'modify a task',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            content: Form(
                              key: formKey,
                              child: Container(
                                height: 250,
                                child: Column(
                                  children: [
                                    MyTextFormField(
                                      controller: taskName1,
                                      hintText: 'Task Name',
                                      obscureText: false,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    MyTextFormField(
                                      controller: taskDescription1,
                                      hintText: 'Task Description',
                                      obscureText: false,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    MyTextFormField(
                            controller: taskdeadline,
                            hintText: 'Task deadline',
                            obscureText: false,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                showDatePicker(
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme:const ColorScheme.light(
                                            primary: Color.fromARGB(255, 120, 100, 156), // <-- SEE HERE
                                            
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              
                                              primary:const Color.fromARGB(255, 120, 100, 156), // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2035)).then((value){
                                      setState(() {
                                        taskdeadline.text=DateFormat('yyyy-MM-dd').format(value!);
                                      });
                                    });
                              },
                            ),
                          ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 9),
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  255, 120, 100, 156))),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      print("valedated");
                                      await check();

                                      var res = await orpc.callKw({
                                        'model': 'project.task',
                                        'method': 'write',
                                        'args': [
                                          record['id'],
                                          {
                                            'name': taskName1.text,
                                            'description': taskDescription1.text,
                                            'date_deadline':taskdeadline.text
                                          }
                                        ],
                                        'domain': [],
                                        'kwargs': {}
                                      });
                                      setState(() {
                                        record.update(
                                            "name", (value) => taskName1.text);
                                      });

                                      print(record);
                                      Navigator.pop(context);

                                      return res;
                                    } else {
                                      print("error");
                                    }
                                    ;
                                  },
                                ),
                              ),
                            ],
                          );
                        });
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
    getMessage();
  }

  List tasksList = [];
  String searchWord = "";
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 100, 156),
        title: const Text(
          "My Tasks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {}, icon: const Icon(Iconsax.task_square)),
          )
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          color: const Color.fromARGB(255, 120, 100, 156),
          onRefresh: refresh,
          child: Column(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      cursorColor: const Color.fromARGB(255, 120, 100, 156),
                      obscureText: false,
                      decoration: InputDecoration(
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
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
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
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
              Expanded(
                child: FutureBuilder(
                  future: fetchtasks(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      tasksList = snapshot.data;
                      List<dynamic> filteredData = tasksList
                          .where((element) => element['name']
                              .toLowerCase()
                              .contains(searchWord))
                          .toList();
                      return ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final record =
                              filteredData[index] as Map<String, dynamic>;

                          return FadeInUp(child: builditem(record));
                        },
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Center(child: Text('Add a task')),
                  content: Form(
                    key: formKey,
                    child: Container(
                      height: 250,
                      child: Column(
                        children: [
                          MyTextFormField(
                            controller: taskName,
                            hintText: 'Task Name',
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MyTextFormField(
                            controller: taskDescription,
                            hintText: 'Task Description',
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          MyTextFormField(
                            controller: taskdeadline,
                            hintText: 'Task deadline',
                            obscureText: false,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.date_range),
                              onPressed: () {
                                showDatePicker(
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme:const ColorScheme.light(
                                            primary: Color.fromARGB(255, 120, 100, 156), // <-- SEE HERE
                                            // <-- SEE HERE
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              // ignore: deprecated_member_use
                                              primary:const Color.fromARGB(255, 120, 100, 156), // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2035)).then((value){
                                      setState(() {
                                        taskdeadline.text=DateFormat('yyyy-MM-dd').format(value!);
                                      });
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 120, 100, 156))),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        await addTask(taskName.text, taskDescription.text,taskdeadline.text);
                        sendNotificaton("Task added", "task added in project : $ProjectId",ProjectId.toString());
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
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
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Tasks()),
    );
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
