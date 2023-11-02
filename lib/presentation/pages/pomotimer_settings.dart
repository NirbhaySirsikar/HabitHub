// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PomodoroSettings extends StatelessWidget {
  const PomodoroSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsContainer(
              title: 'Focus time',
              nums: [Container(
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                      ),
                      child: Text(
                        15.toString(),
                      ),),
                      //  20, 25, 30, 45, 50, 60,
                       ],
            ),
            // SettingsContainer(
            //   title: 'Short break',
            //   nums: const [2, 5, 8, 10, 15],
            // ),
            // SettingsContainer(
            //   title: 'Long break',
            //   nums: const [15, 20, 25, 30],
            // ),
            // SettingsContainer(
            //   title: 'Pomodoros',
            //   nums: const [2, 3, 4, 5, 6],
            // ),
          ],
        ),
      ),
    );
  }
}

class SettingsContainer extends StatelessWidget {
  final String title;
  final List<Widget> nums;
  const SettingsContainer({
    super.key,
    required this.title,
    required this.nums,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(24),
        ),
        height: 72,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              DropdownButton(
                items: nums.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: item,
                  );
                }).toList(),
                onChanged: (index) {},
                underline: Container(), // Remove default underline
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.white), // Custom dropdown arrow icon
                iconSize: 24, // Custom icon size
                dropdownColor: const Color(
                    0xFF313131), // Dropdown background color (#313131)
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
