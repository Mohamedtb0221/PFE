import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home.dart';



class pagetwo extends StatefulWidget {
  pagetwo({super.key});

  @override
  State<pagetwo> createState() => _pagetwoState();
}

class _pagetwoState extends State<pagetwo> {
  Future<dynamic> fetchcontacts() async {
    await check();
    return orpc.callKw({
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [],
        'fields': [
          'id',
          'name',
          'email',
          '__last_update',
          'phone',
          'image_128'
        ],
        'limit': 80,
      }
    });
  }

  Widget buildListItem(Map<String, dynamic> record) {
    return ExpansionTile(
      textColor: const Color.fromARGB(
        255,
        120,
        100,
        156,
      ),
      iconColor: const Color.fromARGB(
        255,
        120,
        100,
        156,
      ),
      title: Text(record['name'].toString()),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //const Divider(endIndent: 40,indent: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(record['email'] != false
                        ? "Email : ${record['email']}"
                        : 'Email : none'),
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(record['phone'] != false
                          ? "Phone : ${record['phone']}"
                          : 'Phone : none'),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                //const Divider(endIndent: 40,indent: 40,height: 30,),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mail_rounded, size: 25),
                      onPressed: () async {
                      String email = Uri.encodeComponent("mm0356005@gmail.com");
                      String subject = Uri.encodeComponent("Hello Flutter");
                      String body = Uri.encodeComponent("Hi! I'm Flutter Developer");
                      print(subject); //output: Hello%20Flutter
                      Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
                      if (await launchUrl(mail)) {
                          //email app opened
                          print("opening");
                      }else{
                          //email app is not opened
                          print("won't open");
                      }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.phone_rounded,
                        size: 25,
                      ),
                      onPressed: () {
                        
                        // ignore: deprecated_member_use
                        launch("tel://${record['phone']}");
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  List contactsList = [];
  String searchWord = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("contacts odoo"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
          255,
          120,
          100,
          156,
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: fetchcontacts,
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
                  future: fetchcontacts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      contactsList = snapshot.data;
                      List<dynamic> filteredData = contactsList
                          .where((element) => element['name'].toString()
                              .toLowerCase()
                              .contains(searchWord))
                          .toList();
                      return ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final record = filteredData[index] as Map<String, dynamic>;
                          return FadeInUp(child: buildListItem(record));
                        },
                      );
                    } else {
                      if (snapshot.hasError) {
                        return const Text("something went wrong");
                      }
                      return const Center(
                        child:  CircularProgressIndicator(
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
    );
  }
}
