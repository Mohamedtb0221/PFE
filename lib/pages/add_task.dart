import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:testing/pages/pagethree.dart';
import 'package:testing/pages/swipe.dart';

import '../components/my_formtextfield.dart';
import 'controller/controller.dart';
import 'home.dart';

Future<dynamic> fetchUsers() async {
    await check();
    var res = await orpc.callKw({
      'model': 'res.users',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['share', '=', false]
        ],
        'fields': [
          'id',
          'name',
        ],
        'limit': 10,
      }
    });
    
    return res;
  }

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    activeColor: const Color.fromARGB(255, 120, 100, 156),
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text(
            'Cancel',
            style: TextStyle(
                color: Color.fromARGB(255, 120, 100, 156),
                fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text(
            'Submit',
            style: TextStyle(
                color: Color.fromARGB(255, 120, 100, 156),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class AddTask extends StatefulWidget {
  AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskdeadline = TextEditingController();
  List<String> _selectedItems = [];
  List<dynamic> ids = [];

  void _showMultiSelect() async {

    var res = await fetchUsers();
    
    final List<String> items = [
      
    ];
    for (var x in res) {
      items.add(x['name']);
    }
    

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
    print(_selectedItems);
    for (var i in _selectedItems) {
       print(i);
      
     }
     
     
     for (var i in _selectedItems) {
       var result = res.firstWhere((value) => value["name"] == i, orElse: () => null);      
      ids.add(result["id"]);
      
     }
print(ids);
  }
  Future addTask(String name, String description, String deadline,List<dynamic> ids) async {
    await check();    
    var res = await orpc.callKw({
      'model': 'project.task',
      'method': 'create',
      'args': [
        {
          'name': name,
          'description': description,
          'date_deadline': deadline,
          'project_id': ProjectId,
          'user_ids':ids
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
                  "Add a task",
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
                                              colorScheme:
                                                  const ColorScheme.light(
                                                primary: Color.fromARGB(255, 120,
                                                    100, 156), // <-- SEE HERE
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
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // use this button to open the multi-select dialog
                                GestureDetector(
                                  onTap: _showMultiSelect,
                                  child: Container(
                                      width: 300,
                                      padding: EdgeInsets.all(18),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color.fromARGB(255, 120, 100, 156)
                                            .withOpacity(0.8),
                                      ),
                                      child: const Text(
                                        "Select assigned users",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
      
                                // display selected items
                                Wrap(
                                  children: _selectedItems
                                      .map((e) => Chip(                                        
                                            label: Text(e),
                                          ))
                                      .toList(),
                                ),
                                SizedBox(height: Get.height*0.12,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Container(
                                        padding:const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color:const Color.fromARGB(255, 120, 100, 156)
                                        ),
                                        child:const Text("Cancel",style: TextStyle(
                                          color: Colors.white,fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()async {
                                        await addTask(taskName.text, taskDescription.text,
                            taskdeadline.text,ids);
                        Fluttertoast.showToast(
                          msg: "Task added !",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        sendNotificaton(
                            "Task added",
                            "task '${taskName.text}' added in project : $ProjectName",
                            ProjectId.toString());
                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding:const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color:const Color.fromARGB(255, 120, 100, 156)
                                        ),
                                        child:const Text("Add",style: TextStyle(
                                          color: Colors.white,fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
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
