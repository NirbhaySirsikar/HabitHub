import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habithubtest/constants/date_time.dart';
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
class JournalDb {
  final CollectionReference journals = FirebaseFirestore.instance
      .collection(AuthService().user!.uid)
      .doc('AppData')
      .collection('journal');

  final DocumentReference habits = FirebaseFirestore.instance
      .collection(AuthService().user!.uid)
      .doc('AppData')
      .collection('habits')
      .doc('habits');

  Future<void> newDayOrNot() async {
    String today = (await habits.get()).get('today');

    if (today != todaysDateFormatted()) {
      JournalDb()
          .journals
          .doc(todaysDateFormatted())
          .set({'date': todaysDateFormatted(), 'title': ''});
      habits.update({'today': todaysDateFormatted()});
    }
    return;
  }

  //CREATE
  Future<void> addJournal(String title, int mood) {
    return journals
        .doc(todaysDateFormatted())
        .set({'title': title, 'date': todaysDateFormatted(), 'mood': mood});
  }

  //READ
  Future<DocumentSnapshot> getJournalStream(String docId) async {
    newDayOrNot;
    journals.get().then((checkSnapshot) {
      if (checkSnapshot.size == 0) {
        addJournal('First day of Journalling!!!', 5);
        // addTask('Tap ⭕ to complete', 4);
        // addTask('Add new task ➕', 3);
        // addTask('Swipe ⏪ to reveal', 2);
      }
    });
    return await journals.doc(docId).get();
  }

  // UPDATE
  Future<void> updateMood(String docId, int mood) {
    return journals.doc(docId).update({'mood': mood});
  }

  void updateJournal(String title, String docId) {
    journals.doc(docId).update({'title': title});
  }

  //DELETE
  Future<void> deleteJournal(String docId) {
    return journals.doc(docId).delete();
  }
}
