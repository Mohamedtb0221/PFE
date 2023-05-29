import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:testing/main.dart';
import 'package:testing/pages/home.dart';
import 'package:testing/pages/login.dart';
import 'package:testing/pages/swipe.dart';
import '../components/clipPath.dart';
import '../components/my_formtextfield.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Future<dynamic> fetchUserInfo() async {
    //await check();
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
          'login',
          'phone',
          'image_128',
          '__last_update'
        ],
      }
    });

    return res;
  }

  Future<dynamic> UpdateProfil(
      String name, String email, String phone, dynamic record) async {
    //await check();
    var res = await orpc.callKw({
      'model': 'res.users',
      'method': 'write',
      'args': [
        [session.userId],
        {
          'name': name.isEmpty ? session.userId : name,
          'email': email.isEmpty ? record['email'] : email,
          'phone': phone.isEmpty ? record['phone'] : phone
        }
      ],
      'kwargs': {}
    });

    return res;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController contactName = TextEditingController();
    TextEditingController contactEmail = TextEditingController();
    TextEditingController contactPhone = TextEditingController();
    return Scaffold(
      body: FutureBuilder(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final imageString = snapshot.data[0]['image_128'] ?? '';

            final imageBytes = imageString.runtimeType != bool
                ? imageString.isNotEmpty
                    ? base64.decode(imageString)
                    : null
                : null;

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

            return SingleChildScrollView(
              child: Column(
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
                          "Username",
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
                          child: Text(snapshot.data[0]['login']),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                          child: Text(snapshot.data[0]['phone'] == false
                              ? 'no number'
                              : snapshot.data[0]['phone']),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    " Edit your profil",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: Container(
                                    height: Get.height * 0.3,
                                    child: Column(
                                      children: [
                                        MyTextFormField(
                                          controller: contactName,
                                          hintText: ' Name',
                                          obscureText: false,
                                        ),
                                        Expanded(child: Container()),
                                        MyTextFormField(
                                          controller: contactEmail,
                                          hintText: ' Email',
                                          obscureText: false,
                                        ),
                                        Expanded(child: Container()),
                                        MyTextFormField(
                                          controller: contactPhone,
                                          hintText: ' Phone',
                                          obscureText: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          //await check();
                                          if (contactEmail.text.isEmail) {
                                            print("email");
                                            await UpdateProfil(
                                              contactName.text,
                                              contactEmail.text,
                                              contactPhone.text,
                                              snapshot.data);
                                          Fluttertoast.showToast(
                                            msg: "profil updated",
                                            toastLength: Toast.LENGTH_SHORT,
                                          );
                                          // refresh();
                                          Get.back();
                                          }else{
                                            print("not email");
                                            Flushbar(
                                              title: "Error !",
                                              message: "invalid email address",
                                              duration:
                                                  const Duration(seconds: 3),
                                              padding: const EdgeInsets.all(20),
                                              icon: const Icon(
                                                Icons.warning,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                              flushbarPosition:
                                                  FlushbarPosition.TOP,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 120, 100, 156),
                                            ).show(context);
                                          }
                                          
                                        },
                                        child: const Text(
                                          "Save",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                );
                              },
                            );
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
                                  const Text(
                                    'Edit profil',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                            showDialog(
                              context: context,
                              builder: (context) {
                                return FadeInUp(
                                  child: AlertDialog(
                                    title: const Text(
                                      "Log out ?",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //content:const Text("Are you sure ?",style: TextStyle(color: Color.fromARGB(255, 120, 100, 156),),),
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
                                            box1 =
                                                await Hive.openBox('loginData');
                                            box1.clear();
                                            x = null;
                                            messaging.unsubscribeFromTopic(
                                                session.userId.toString());
            
                                            Get.offAll(const LoginPage());
                                          },
                                          child: const Text("Yes",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                );
                              },
                            );
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
                                  const Text(
                                    'Log out',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
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
              ),
            );
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
    );
  }
}
