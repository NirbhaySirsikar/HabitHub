import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habithubtest/data/data_providers/habit_repo.dart';
import 'package:habithubtest/presentation/widgets/habit_tasks.dart';
import 'package:habithubtest/presentation/widgets/month_summary.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  HabitDb dbData = HabitDb();
  final TextEditingController textFieldController = TextEditingController();
  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> displayDialog({String? docId}) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            surfaceTintColor: Colors.deepPurple,
            iconColor: Colors.deepPurple,
            title: const Text('Add a new todo item'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100.0),
              child: Column(
                children: [
                  TextField(
                    controller: textFieldController,
                    decoration:
                        const InputDecoration(hintText: 'Type your new Habit'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  textFieldController.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                ),
                onPressed: () {
                  if (textFieldController.text.isEmpty) {
                    Navigator.of(context).pop();
                  } else {
                    dbData.addHabit(textFieldController.text);
                    textFieldController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habit Tracker',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<Map<DateTime, int>>(
                  stream: dbData.createMapStream(),
                  builder: (context, snapshot) {
                    return MonthlySummary(
                      datasets: snapshot.data,
                      size: 30,
                      showText: true,
                    );
                  }),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Habits',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        displayDialog();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.deepPurple),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            'Add Habit',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: dbData.getHabitsStream(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    List habitsList = snapshot.data!.docs;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: habitsList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = habitsList[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return HabitTasks(
                          title: data['title'],
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
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
