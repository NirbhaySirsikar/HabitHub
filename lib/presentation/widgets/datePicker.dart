import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  // The selected date, initialized with today's date
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

  @override
  Widget build(BuildContext context) {
    // Format the selected date as a string
    final String formattedDate = DateFormat.yMMMd().format(_selectedDate);

    // Return a gesture detector that wraps a text widget
    return GestureDetector(
      // When the user taps on the text, call the _selectDate function
      onTap: () => _selectDate(context),
      // The text widget that shows the formatted date
      child: Text(
        formattedDate,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
