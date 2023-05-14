import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:testing/main.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/login.dart';
import 'package:testing/pages/swipe.dart';
import '../components/clipPath.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Future<dynamic> fetchUserInfo() async {
    await check();
    var res = await orpc.callKw({
      'model': 'res.users',
      'method': 'read',
      'args': [
        [session.userId]
      ],
      'kwargs': {
        'fields': [
          'id',
          'name',
          'email',
          'phone',
          'image_128',
          '__last_update'
        ],
      }
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final imageString = snapshot.data[0]['image_128'] ?? '';

            final imageBytes =imageString.runtimeType!=bool?
                imageString.isNotEmpty ? base64.decode(imageString) : null:null;

            final imageWidget = imageBytes != null
                ? Image.memory(
                    imageBytes,
                    height: 120,
                    width: 120,
                  )
                : Image.network(
                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                    height: 120,
                    width: 120,
                  );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: Get.height * 0.3,
                      child: Stack(children: [
                        ClipPath(
                          clipper: MyClipper(),
                          child: Container(
                            width: Get.width,
                            height: Get.height * 0.4,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 120, 100, 156),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: imageWidget,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Text(
                      session.userName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 1),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(snapshot.data[0]['email']),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "phone number",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38, width: 1),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(snapshot.data[0]['phone'] == false ? 'no number' : snapshot.data[0]['phone']),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(                  
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 120, 100, 156),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Row(
                              
                              children: [
                                 const Text('Edit profil',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                 //Expanded(child: Container()),
                                 //Expanded(child: const Icon(Icons.edit,color: Colors.white,size: 20,))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                   // Expanded(child: Container()),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(context: context, builder: (context) {
                            return  AlertDialog(
                              title: const Text("Log out ?",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                              //content:const Text("Are you sure ?",style: TextStyle(color: Color.fromARGB(255, 120, 100, 156),),),
                              actions: <Widget>[
                                
                                TextButton(onPressed: (){
                                  Get.back();
                                }, child: const Text("No",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                                TextButton(onPressed: ()async{
                                  box1 = await Hive.openBox('loginData');
                                  box1.clear();
                                  x=null;
                                  messaging.unsubscribeFromTopic(session.userId.toString());
                                  Get.offAll(const LoginPage());
                                }, child: const Text("Yes",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),

                              ],
                            );
                            
                          },);
                          
                        },
                        child: Container(
                          
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 120, 100, 156),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Row(
                              
                              children: [
                                 const Text('Log out',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                 //Expanded(child: Container()),
                                 //const Icon(Icons.logout,color: Colors.white,size: 20,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    
                  ],
                ),
              ],
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
    );
  }
  
}
