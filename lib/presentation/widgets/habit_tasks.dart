// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habithubtest/data/data_providers/habit_repo.dart';

class HabitTasks extends StatefulWidget {
  final bool done;
  final String docId;
  final String title;

  const HabitTasks({
    Key? key,
    required this.done,
    required this.docId,
    required this.title,
  }) : super(key: key);

  @override
  State<HabitTasks> createState() => _HabitTasksState();
}

class _HabitTasksState extends State<HabitTasks> {
  HabitDb dbData = HabitDb();
  final TextEditingController textFieldController = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
  Color color = Colors.deepPurpleAccent;
  @override
  void dispose() {
    textFieldController.dispose();
    textFieldController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> displayDialog({String? docId}) async {
      textFieldController.text = widget.title;
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            surfaceTintColor: Colors.deepPurple,
            iconColor: Colors.deepPurple,
            title: const Text('Update the task'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100.0),
              child: Column(
                children: [
                  TextField(
                    controller: textFieldController,
                    decoration: const InputDecoration(hintText: 'Update task'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple),
                ),
                onPressed: () {
                  if (textFieldController.text == '') {
                    Navigator.of(context).pop();
                  } else {
                    dbData.updateHabit(docId!, textFieldController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: ((context) {
                displayDialog(docId: widget.docId);
              }),
              backgroundColor: Colors.green,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: ((context) {
                dbData.deleteHabit(widget.docId);
              }),
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[900],
              border:
                  Border.all(color: widget.done ? Colors.transparent : color),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 5, offset: Offset(3, 3), color: Colors.black26),
              ]),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Checkbox(
                  value: widget.done,
                  onChanged: (value) {
                    dbData.habitCompleted(widget.docId, value!);
                  },
                  fillColor: MaterialStateColor.resolveWith((states) => color),
                  shape: const CircleBorder()),
              Expanded(
                child: Text(
                  widget.title,
                  softWrap: false,
                  style: TextStyle(
                    color: widget.done ? Colors.grey : Colors.white,
                    fontSize: 18,
                    decoration: widget.done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              // Text(
              //   widget.date,
              //   style: TextStyle(color: Colors.white54),
              // ),
              const SizedBox(
                width: 20,
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
