import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/pages/swipe.dart';

import 'home.dart';

class NotificationHistory extends StatefulWidget {
  const NotificationHistory({super.key});

  @override
  State<NotificationHistory> createState() => _NotificationHistoryState();
}

class _NotificationHistoryState extends State<NotificationHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        padding: EdgeInsets.only(top: Get.height*0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding:const EdgeInsets.only(left:15),
              child: IconButton(onPressed: (){Get.back();}, icon:const Icon(Icons.arrow_back_ios))
            ),
            const Padding(
              padding: EdgeInsets.only(left:38.0,top: 20,bottom: 30),
              child: Text(
                "My recent notifications",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(137, 3, 3, 3)),
              ),
            ),
            FadeInUp(
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Material(
                  //color: const Color.fromARGB(255, 120, 100, 156),
                  elevation: 10,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                        border: Border.all(color: const Color.fromARGB(255, 120, 100, 156), width: 4),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    margin: const EdgeInsets.all(3),
                    width: Get.width,
                    height: Get.height * 0.7,
                    child: ListView.builder(
                      itemCount: recievedNotifications.length,
                      itemBuilder: (context, index) {
                        var message;
                        recievedNotifications[index]['id']==session.userId ? message = recievedNotifications[index]:index++;
                        ;
                        return FadeInRight(
                          
                          delay: const Duration(milliseconds: 600),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54, width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15))),
                            child: ListTile(
                              title: Text(
                                message['title'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(message['body'] ?? ''),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                    Text(message['day'].toString()),
                                    Text(' at '),
                                    Text(message['time'].toString())
                                  ],)
                                ],
                              ),
                              
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
