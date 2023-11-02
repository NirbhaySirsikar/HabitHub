import 'package:cloud_firestore/cloud_firestore.dart';
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
class UserDb {
  final DocumentReference user = FirebaseFirestore.instance
      .collection(AuthService().user!.uid)
      .doc('AppData');

  Future<DocumentSnapshot<Object?>> getUsername() async {
    return await user.get();
  }

  Future<void> updateUsername(String username) {
    return user.update({'username': username});
  }

  Future<void> addUsername(String username) {
    return user.set({'username': username});
  }

  Future<void> deleteAccount() {
    user.delete;
    AuthService().user!.delete();
    return AuthService().signOut();
  }
  //CREATE
  // Future<void> addTask(String title, int priority) {
  //   return tasks.add({'title': title, 'priority': priority, 'done': false});
  // }

  // //READ
  // Stream<QuerySnapshot> getTasksStream() {
  //   tasks.get().then((checkSnapshot) {
  //     if (checkSnapshot.size == 0) {
  //       addTask('Tap ⭕ to complete', 4);
  //       addTask('Add new task ➕', 3);
  //       addTask('Swipe ⏪ to reveal', 2);
  //     }
  //   });
  //   final tasksStream = tasks.orderBy('priority', descending: true).snapshots();
  //   return tasksStream;
  // }

  // // UPDATE
  // Future<void> updateTask(String docId, String newTask, int priority) {
  //   return tasks.doc(docId).update({'title': newTask, 'priority': priority});
  // }

  // Future<void> taskCompleted(String docId, bool value) {
  //   return tasks.doc(docId).update({'done': value});
  // }

  // //DELETE
  // Future<void> deleteTask(String docId) {
  //   return tasks.doc(docId).delete();
  // }
}
