import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/notifications_history.dart';
import 'package:testing/pages/tasks.dart';
import 'package:testing/pages/tasksswipe.dart';
import 'add_project.dart';

int ProjectId = 0;
Future<dynamic> fetchProjects() async {
    await check();
    return await orpc.callKw({
      'model': 'project.project',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': ['id', 'name', 'task_count', 'date_start', 'date'],
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
    await check();
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
  var record;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 120, 100, 156),
        title: const Text(
          "Projects",
          style: TextStyle(
              fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: IconButton(
                onPressed: () {
                  
                      Get.to(() =>NotificationHistory());
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
                    return FadeInUp(
                      child: GestureDetector(
                        child: builditem(record),
                        onTap: () {
                          print(record['id']);
                          ProjectId = record['id'];
                          Get.to(() => TasksSwipe());
                        },
                      ),
                    );
                  },
                );
              } else {
                if (snapshot.hasError) {
                  return const Text("something went wrong");
                }
                return const CircularProgressIndicator(
                  color: Color.fromARGB(255, 120, 100, 156),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      ),
    );
  }

  Future<void> refresh() async {
    record= await fetchProjects();
    setState(()  {
      record=record;
    });
    print("refresh");
  }
}
