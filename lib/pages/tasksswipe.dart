import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/pages/gantt.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/pagethree.dart';
import 'package:testing/pages/tasks.dart';

class TasksSwipe extends StatefulWidget {
  const TasksSwipe({super.key});

  @override
  State<TasksSwipe> createState() => _TasksSwipeState();
}
Future<dynamic> fetchtasks() async {
    //await check();

    var res = await orpc.callKw({
      'model': 'project.task',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [
          ['project_id', '=', ProjectId],
          ['stage_id','!=',3],
                          
        ],
        'fields': [
          'user_ids',
          'kanban_state',
          'id',
          'name',
          'create_date',
          'manager_id',
          'description',
          'date_deadline',
          
        ],
        'limit': 10,
      }
    });
    print(res);
    return res;
  }
class _TasksSwipeState extends State<TasksSwipe> {
  @override
  Widget build(BuildContext context) {
    var tasksPageController = PageController();
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
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
      body: PageView(
        controller: tasksPageController,
        children: [
          Tasks(),
          const GanttChart(),
        ],
      ),
    );
  }
}