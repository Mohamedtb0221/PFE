import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:testing/pages/tasksswipe.dart';

import '../components/event.dart';

class GanttChart extends StatefulWidget {
  const GanttChart({Key? key}) : super(key: key);

  @override
  State<GanttChart> createState() => _GanttChartState();
}

class _GanttChartState extends State<GanttChart> {
  var data;
  final List<TimelineItem> items = [];

  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    fetchtasks();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  var startDate=DateTime(2023, 3, 11);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          
          children: [
            Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: GestureDetector(
                        onTap: () {
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
                                                    primary: const Color
                                                            .fromARGB(
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
                                      startDate =DateTime.parse(
                                          DateFormat('yyyy-MM-dd')
                                              .format(value!));
                                    });
                                  });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text('Pick the graph start dart'),
                        ),
                      )
                    )),
            Center(
              child: FutureBuilder(
                future: fetchtasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    data = snapshot.data;
                    for (var i = 0; i < data.length; i++) {
                      if (data[i]['create_date'] != false && data[i]['date_deadline']!= false && DateTime.parse(data[i]['create_date']).isBefore(DateTime.parse(data[i]['date_deadline']))) {
                        print( DateTime.parse(data[i]['create_date']));
                        print( DateTime.parse(data[i]['date_deadline']));
                        items.add(
                      TimelineItem(
                        startDateTime:
                            DateTime.parse(data[i]['create_date']),
                        endDateTime:
                            DateTime.parse(data[i]['date_deadline']),
                        position: i,
                        
                        child: Event(title: data[i]['name']),
                      ));
                      }  
                                    
                    }
                    print(items);
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        margin:const EdgeInsets.all(20),
                        child: Scrollbar(
                          controller: scrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            child: DynamicTimeline(
                                firstDateTime: startDate,
                                lastDateTime: DateTime(2024, 12, 31),
                                labelBuilder: DateFormat('dd/MM').format,
                                axis: Axis.horizontal,
                                intervalDuration: const Duration(days: 1),
                                minItemDuration: const Duration(days: 1),
                                crossAxisCount: items.length+1,
                                intervalExtent: 45,
                                maxCrossAxisItemExtent: 50,                          
                                items: items),
                          ),
                        ),
                      ),
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
          ],
        ),
      ),
    );
  }
}

class Event extends StatelessWidget {
  const Event({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(title,style:const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 1),),
    );
  }
}
