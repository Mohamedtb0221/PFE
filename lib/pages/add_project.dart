import 'package:flutter/material.dart';
import 'package:testing/pages/home.dart';

class add_project extends StatelessWidget {
  add_project({super.key});
  TextEditingController projectname = TextEditingController();
  

  Future addProject(String name) async {
    await check();
    return await orpc.callKw({
      'model': 'project.project',
      'method': 'create',
      'args': [
        {
          'name': name,
        },
      ],
      'kwargs': {}
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text("contacts odoo"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: projectname,
                  decoration:const InputDecoration(
                    labelText:"project name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    
                    await addProject(projectname.text);
                  },
                  child:const Text("add project"),),
            ],
          ),
        ));
  }
}
