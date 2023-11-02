import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habithubtest/constants/date_time.dart';
import 'package:habithubtest/data/data_providers/journal_repo.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  DateTime _selectedDate = DateTime.now();

  // The function to show the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    // The initial date to show in the dialog
    final DateTime initialDate = _selectedDate;

    // The first and last dates that can be selected
    final DateTime firstDate = DateTime(2020);
    final DateTime lastDate = DateTime(2025);

    // Show the dialog and wait for the user to confirm or cancel
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // If the user confirmed the dialog, update the state with the picked date
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // The function to decrement the date by one day
  void _prevDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  // The function to increment the date by one day
  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

// The function to update the date with the tapped date
  void _updateDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  final TextEditingController textFieldController = TextEditingController();
  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> dates = List.generate(
        7,
        (index) => _selectedDate
            .subtract(const Duration(days: 3))
            .add(Duration(days: index)));
    final String formattedDate = DateFormat.yMMMd().format(_selectedDate);

    JournalDb journalDbData = JournalDb();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Journal'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _prevDay,
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _nextDay,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: dates.map((date) {
                    // Format each date as a string
                    final String formattedDate = DateFormat.d().format(date);
                    final String formattedWeekDay = DateFormat.E().format(date);
                    // Return a gesture detector that wraps a text widget
                    return GestureDetector(
                      // When the user taps on the text, call the _updateDate function with the date
                      onTap: () => _updateDate(date),
                      // The text widget that shows the formatted date
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: date.day == _selectedDate.day
                                  ? Colors.deepPurpleAccent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50)),
                          child: Column(
                            children: [
                              Text(
                                formattedWeekDay,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: date.day == _selectedDate.day
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: date.day == _selectedDate.day
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: date.day == _selectedDate.day
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: date.day == _selectedDate.day
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder<DocumentSnapshot>(
                future: journalDbData.getJournalStream(convertDateTimeToString(
                    _selectedDate)), // call the function with the document ID
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // get the data from the snapshot and cast it to Map<String, dynamic>
                    var nullableData = snapshot.data?.data();
                    if (nullableData == null || nullableData == '') {
                      return const Center(
                        child: Text(
                          'No entries this day',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      );
                    }
                    Map<String, dynamic> data =
                        nullableData as Map<String, dynamic>;
                    textFieldController.text = data['title'];
                    // display the title and date in a Row widget
                    return Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Your story for today',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          onEditingComplete: () {
                            journalDbData.updateJournal(
                                textFieldController.text,
                                convertDateTimeToString(_selectedDate));
                          },
                          onSubmitted: (value) {
                            journalDbData.updateJournal(
                                textFieldController.text,
                                convertDateTimeToString(_selectedDate));
                          },
                          onTapOutside: (event) {
                            journalDbData.updateJournal(
                                textFieldController.text,
                                convertDateTimeToString(_selectedDate));
                          },
                          controller: textFieldController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurpleAccent)),
                            hintText: 'Start your journal here.',
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Row(
                          children: [
                            Text(
                              'How did you feel today',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => journalDbData.updateMood(
                                    convertDateTimeToString(_selectedDate), 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                    color: data['mood'] == 5
                                        ? Colors.deepPurpleAccent
                                        : Colors.white10,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Center(
                                      child: Text(
                                        'Best',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () => journalDbData.updateMood(
                                    convertDateTimeToString(_selectedDate), 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                    color: data['mood'] == 4
                                        ? Colors.deepPurpleAccent
                                        : Colors.white10,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Center(
                                      child: Text(
                                        'Awesome',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () => journalDbData.updateMood(
                                    convertDateTimeToString(_selectedDate), 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                    color: data['mood'] == 3
                                        ? Colors.deepPurpleAccent
                                        : Colors.white10,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Center(
                                      child: Text(
                                        'Good',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () => journalDbData.updateMood(
                                    convertDateTimeToString(_selectedDate), 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                    color: data['mood'] == 2
                                        ? Colors.deepPurpleAccent
                                        : Colors.white10,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Center(
                                      child: Text(
                                        'Bad',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () => journalDbData.updateMood(
                                    convertDateTimeToString(_selectedDate), 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                    color: data['mood'] == 1
                                        ? Colors.deepPurpleAccent
                                        : Colors.white10,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Center(
                                      child: Text(
                                        'Worst',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    // display the error message
                    return Text(snapshot.error.toString());
                  } else {
                    // display a loading indicator
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(
                height: 32,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Container(
              //       height: 150,
              //       width: 150,
              //       decoration: const BoxDecoration(
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //           color: Colors.black12),
              //       child: const Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(Icons.image_search),
              //             Text('Add an Image'),
              //           ],
              //         ),
              //       ),
              //     ),
              //     Container(
              //       height: 150,
              //       width: 150,
              //       decoration: const BoxDecoration(
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //           color: Colors.black12),
              //       child: const Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(Icons.location_on),
              //             Text('Add Location'),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class Datecontainer extends StatelessWidget {
  final bool;
  final int day;
  const Datecontainer({super.key, required this.day, this.bool = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: bool ? Colors.cyan : Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Center(
            child: Text(
          day.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}
