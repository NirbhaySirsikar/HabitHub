import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habithubtest/constants/date_time.dart';
import 'package:habithubtest/data/data_providers/journal_repo.dart';
import 'package:habithubtest/services/auth.dart';

class HabitDb {
  final DocumentReference habits = FirebaseFirestore.instance
      .collection(AuthService().user!.uid)
      .doc('AppData')
      .collection('habits')
      .doc('habits');
  Future<List<List<dynamic>>> createDataset() async {
    // Get the documents from your collection
    QuerySnapshot snapshot = await habits.collection('percent_summary').get();
    // Map each document to a list of two elements: title and done
    List<List<dynamic>> list = snapshot.docs
        .map((doc) =>
            [createDateTimeObject(doc.get('date')), doc.get('percent')])
        .toList();
    return list;
    //to us this function you can use
    // List<List<dynamic>> temp = await HabitDb().create2DList();
  }

  // Create a StreamController that can add values to a Stream
  StreamController<Map<DateTime, int>> streamController =
      StreamController<Map<DateTime, int>>();

// Create a function that listens to the changes in the database
  void listenToChanges() {
    // Get a reference to your collection
    CollectionReference collection = habits.collection('percent_summary');
    // Listen to the snapshots of the collection
    collection.snapshots().listen((snapshot) async {
      // Call the createDataset function to get the latest list of lists
      List<List<dynamic>> list = await createDataset();
      // Call the createMap function to convert the list of lists into a map
      Map<DateTime, int> map = createMap(list);
      // Add the map to the Stream using the StreamController
      streamController.add(map);
    });
  }

// Create a function that converts the list of lists into a map of type Map<DateTime,int>
  Map<DateTime, int> createMap(List<List<dynamic>> list) {
    // Create an empty map variable of type Map<DateTime,int>
    Map<DateTime, int> map = {};
    // Loop through the list of lists and add each pair of date and percent to the map
    for (List<dynamic> pair in list) {
      DateTime date = pair[0]; // get the date from the pair
      int percent = pair[1]; // get the percent from the pair
      map[date] = percent; // add the pair to the map
    }
    return map; // return the map
  }

// Create a function that returns a Stream<Map<DateTime,int>> object
  Stream<Map<DateTime, int>> createMapStream() {
    // Call the listenToChanges function to start listening to the database changes
    listenToChanges();
    // Return the Stream from the StreamController using the stream property
    return streamController.stream;
  }

  Future<void> newDayOrNot() async {
    String today = (await habits.get()).get('today');

    if (today != todaysDateFormatted()) {
      var querySnapshots = await habits.collection('current_habitlist').get();
      for (var doc in querySnapshots.docs) {
        await doc.reference.update({'done': false});
      }
      habits
          .collection('percent_summary')
          .doc(todaysDateFormatted())
          .set({'date': todaysDateFormatted(), 'percent': 0});
      JournalDb()
          .journals
          .doc(todaysDateFormatted())
          .set({'date': todaysDateFormatted(), 'title': ''});
      habits.update({'today': todaysDateFormatted()});
    }
    return;
  }

  Future<void> loadHeatmap() async {
    int completed = 0;
    var querySnapshots = await habits.collection('current_habitlist').get();
    for (var doc in querySnapshots.docs) {
      if (doc.data()['done'] == true) {
        completed += 1;
      }
      // print(doc.data()['done']);
    }
    // print(completed);
    habits
        .collection('percent_summary')
        .doc(todaysDateFormatted())
        .update({'percent': ((completed / querySnapshots.size) * 10).toInt()});
    createDataset();
  }

  //CREATE
  Future<void> addHabit(String title) async {
    habits.collection('current_habitlist').add({'title': title, 'done': false});
    return await loadHeatmap();
  }

  //READ
  Stream<QuerySnapshot> getHabitsStream() {
    habits.collection('current_habitlist').get().then((checkSnapshot) {
      if (checkSnapshot.size == 0) {
        addHabit('exercise');
        addHabit('read book');
        addHabit('journal');
        // habits.set({'today': todaysDateFormatted()});
      }
    });
    newDayOrNot();
    final habitsStream = habits.collection('current_habitlist').snapshots();
    return habitsStream;
  }

//   // UPDATE
  Future<void> updateHabit(String docId, String newTask) {
    return habits
        .collection('current_habitlist')
        .doc(docId)
        .update({'title': newTask});
  }

  Future<void> habitCompleted(String docId, bool value) async {
    habits.collection('current_habitlist').doc(docId).update({'done': value});
    return await loadHeatmap();
  }

//   //DELETE
  Future<void> deleteHabit(String docId) async {
    habits.collection('current_habitlist').doc(docId).delete();
    return await loadHeatmap();
  }
}
