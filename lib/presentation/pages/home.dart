import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habithubtest/data/data_providers/habit_repo.dart';
import 'package:habithubtest/data/data_providers/profile_repo.dart';
import 'package:habithubtest/data/data_providers/task_repo.dart';
import 'package:habithubtest/presentation/widgets/month_summary.dart';
import 'package:habithubtest/presentation/widgets/tasks.dart';
import '../widgets/habitcards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskDb dbData = TaskDb();
  HabitDb habitDbData = HabitDb();
  UserDb userDbData = UserDb();
  // List<task> items = [
  //   task(
  //     title: 'Do homework',
  //     priority: 5,
  //     date: 'Today',
  //   ),
  //   task(
  //     title: 'Buy Groceries',
  //     priority: 3,
  //     date: 'Tommorow',
  //   ),
  //   task(
  //     title: 'Watch Movie',
  //     priority: 2,
  //     date: 'Monday',
  //   ),
  //   task(
  //     title: 'Play Football',
  //     priority: 2,
  //     date: 'Monday',
  //   ),
  //   task(
  //     title: 'Read saved article',
  //     priority: 1,
  //     date: '30 March',
  //   ),
  //   task(
  //     title: 'Clean Store room',
  //     priority: 1,
  //     date: '30 March',
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    final TextEditingController textFieldController = TextEditingController();
    final TextEditingController textFieldController2 = TextEditingController();
    @override
    void dispose() {
      textFieldController.dispose();
      textFieldController2.dispose();
      super.dispose();
    }
    //   double _value = 1;

    // // The int variable that stores the priority, initialized to 1
    // int _priority = 1;

    // // The list of colors for the gradient
    // List<Color> _colors = [Colors.grey, Colors.yellow, Colors.blue, Colors.red];

    // // The list of labels for the slider
    // List<String> _labels = [
    //   'Less',
    //   'Important',
    //   'More',
    //   'Very'
    // ];
    // void _addTodoItem(String title, int priority) {
    //   setState(() {
    //     items.add(task(title: title, date: 'today', priority: priority));
    //   });
    //   textFieldController.clear();
    //   textFieldController2.clear();
    // }

    Future<void> displayDialog({String? docId}) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a new todo item'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100.0),
              child: Column(
                children: [
                  TextField(
                    controller: textFieldController,
                    decoration:
                        const InputDecoration(hintText: 'Type your new todo'),
                  ),
                  TextField(
                    controller: textFieldController2,
                    decoration:
                        const InputDecoration(hintText: 'Priority (1 to 4)'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  // SliderTheme(
                  //   data: SliderThemeData(
                  //     trackHeight: 10,
                  //     thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                  //   ),
                  //   child: Slider(
                  //     value: _value,
                  //     min: 1,
                  //     max: 4,
                  //     divisions: 3,
                  //     // The gradient is created by using a LinearGradient with the colors list
                  //     // activeColor: LinearGradient(colors: _colors)
                  //     //     .createShader(Rect.zero),
                  //     onChanged: (value) {
                  //       setState(() {
                  //         // Update the value and priority when the slider is changed
                  //         _value = value;
                  //         _priority = value.round();
                  //       });
                  //     },
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: List.generate(
                  //     _labels.length,
                  //     (index) => Text(_labels[index]),
                  //   ),
                  // ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () async {
                  textFieldController.clear();
                  textFieldController2.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan),
                ),
                onPressed: () {
                  if (textFieldController.text.isEmpty ||
                      textFieldController2.text.isEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    if (docId == null) {
                      dbData.addTask(textFieldController.text,
                          int.parse(textFieldController2.text));
                    } else {
                      dbData.updateTask(docId, textFieldController.text,
                          int.parse(textFieldController2.text));
                    }
                    textFieldController.clear();
                    textFieldController2.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      // floatingActionButton: Align(
      //   alignment: Alignment(1, 0.8),
      //   child: Container(
      //     decoration: BoxDecoration(
      //         shape: BoxShape.circle,
      //         border: Border.all(color: Colors.cyanAccent, width: 1),
      //         boxShadow: [
      //           BoxShadow(color: Colors.cyan, blurRadius: 5),
      //         ]),
      //     child: FloatingActionButton(
      //       onPressed: () {},
      //       child: Icon(Icons.add),
      //       backgroundColor: Colors.black,
      //       foregroundColor: Colors.cyanAccent,
      //     ),
      //   ),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 20,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: FutureBuilder(
                  future: userDbData.getUsername(),
                  builder: (context, snapshot) {
                    var nullableData = snapshot.data?.data();
                    if (nullableData == null) {
                      return const Text('Username');
                    } else {
                      Map<String, dynamic> data =
                          nullableData as Map<String, dynamic>;
                      String username=data['username'];
                      return Text(
                        'Hello, $username',maxLines: 1,
                        style: const TextStyle(
                          fontSize: 40,
                          shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,overflow: TextOverflow.fade
                        ),
                        textAlign: TextAlign.left,
                      );
                    }
                  }),
            ),
            floating: true,
            snap: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 50),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'see more',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12, left: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 5,
                                      offset: Offset(3, 3),
                                      color: Colors.black26),
                                ],
                              ),
                              height: 200,
                              width: 220,
                              child: Center(
                                child: StreamBuilder<Map<DateTime, int>>(
                                    stream: habitDbData.createMapStream(),
                                    builder: (context, snapshot) {
                                      return MonthlySummary(
                                        datasets: snapshot.data,
                                        size: 17,
                                        showText: false,
                                      );
                                    }),
                              ),
                            ),
                          ),
                          const HabitCard(
                            title: 'exercise',
                          ),
                          const HabitCard(
                            title: 'read book',
                          ),
                          const HabitCard(
                            title: 'journal',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, bottom: 16, right: 16, top: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ToDo',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () => displayDialog(),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.cyan),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            Text(
                              'Add Task',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: dbData.getTasksStream(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        List tasksList = snapshot.data!.docs;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: tasksList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = tasksList[index];
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return TodoTask(
                              title: data['title'],
                              priority: data['priority'],
                              done: data['done'],
                              docId: document.id,
                            );
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
