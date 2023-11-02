import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habithubtest/data/data_providers/task_repo.dart';

class TodoTask extends StatefulWidget {
  const TodoTask({
    super.key,
    required this.title,
    required this.priority,
    required this.docId,
    required this.done,
  });
  final String title;
  final int priority;
  final String docId;
  final bool done;

  @override
  State<TodoTask> createState() => _TodoTaskState();
}

class _TodoTaskState extends State<TodoTask> {
  TaskDb dbData = TaskDb();
  final TextEditingController textFieldController = TextEditingController();
  final TextEditingController textFieldController2 = TextEditingController();
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
      textFieldController2.text = widget.priority.toString();
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update the task'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100.0),
              child: Column(
                children: [
                  TextField(
                    controller: textFieldController,
                    decoration: const InputDecoration(hintText: 'Update task'),
                  ),
                  TextField(
                    controller: textFieldController2,
                    decoration: const InputDecoration(
                        hintText: 'Update priority(1 to 4)'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
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
                  'Update',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    }

    Color color = Colors.red;
    if (widget.priority == 1) {
      color = Colors.grey;
    } else if (widget.priority == 2) {
      color = Colors.yellow;
    } else if (widget.priority == 3) {
      color = Colors.blue;
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
                dbData.deleteTask(widget.docId);
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
                    dbData.taskCompleted(widget.docId, value!);
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
