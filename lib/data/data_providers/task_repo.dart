import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habithubtest/constants/date_time.dart';
import 'package:habithubtest/data/data_providers/habit_repo.dart';
import 'package:habithubtest/services/auth.dart';
// class TaskDb {
//   List<Task> tempList = [];

//   //Read tasks
//   List<Task> getTasks() {
//     tempList = [
//       Task(),
//       Task(),
//     ];
//     return tempList;
//   }
//   //Create Tasks

//   //Update Tasks

//   //Delete Tasks
// }
class TaskDb {
  final CollectionReference tasks = FirebaseFirestore.instance
      .collection(AuthService().user!.uid)
      .doc('AppData')
      .collection('tasks');

  //CREATE
  Future<void> addTask(String title, int priority) {
    return tasks.add({'title': title, 'priority': priority, 'done': false});
  }

  //READ
  Stream<QuerySnapshot> getTasksStream() {
    tasks.get().then((checkSnapshot) {
      if (checkSnapshot.size == 0) {
        addTask('Tap ⭕ to complete', 4);
        addTask('Add new task ➕', 3);
        addTask('Swipe ⏪ to reveal', 2);
        HabitDb().habits.set({'today': todaysDateFormatted()});
      }
    });
    final tasksStream = tasks.orderBy('priority', descending: true).snapshots();
    return tasksStream;
  }

  // UPDATE
  Future<void> updateTask(String docId, String newTask, int priority) {
    return tasks.doc(docId).update({'title': newTask, 'priority': priority});
  }

  Future<void> taskCompleted(String docId, bool value) {
    return tasks.doc(docId).update({'done': value});
  }

  //DELETE
  Future<void> deleteTask(String docId) {
    return tasks.doc(docId).delete();
  }
}
