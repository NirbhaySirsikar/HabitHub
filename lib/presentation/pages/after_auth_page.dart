import 'package:flutter/material.dart';
import 'package:habithubtest/presentation/pages/profile.dart';

import 'habit_page.dart';
import 'home.dart';
import 'journal_page.dart';
import 'pomotimer.dart';

class AfterAuthPage extends StatefulWidget {
  const AfterAuthPage({super.key});

  @override
  State<AfterAuthPage> createState() => _AfterAuthPageState();
}

class _AfterAuthPageState extends State<AfterAuthPage> {
  int _pageidx = 0;
  final List<Color> _colorList = [
    Colors.cyan,
    Colors.deepPurpleAccent,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.cyan
  ];
  final List<Widget> _tabList = [
    const HomePage(),
    const HabitPage(),
    const PomodoroPage(),
    const JournalPage(),
    const ProfilePage()
  ];

  // Declare a PageController
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController
    _pageController = PageController();
  }

  @override
  void dispose() {
    // Dispose the PageController
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      // Use a PageView as the body
      body: PageView(
        // Assign the controller to the PageView
        controller: _pageController,
        // Set the onPageChanged callback to update the _pageidx state
        onPageChanged: (index) {
          setState(() {
            _pageidx = index;
          });
        },
        // Use the _tabList as the children of the PageView
        children: _tabList,
      ),
      bottomNavigationBar: Align(
        alignment: const Alignment(0, 1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: _colorList[_pageidx], blurRadius: 5),
              ],
              border: Border.all(
                color: _colorList[_pageidx],
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                iconSize: 30,
                selectedItemColor: _colorList[_pageidx],
                selectedIconTheme: const IconThemeData(fill: 1),
                unselectedItemColor: Colors.white60,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                backgroundColor: Colors.black,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: _pageidx,
                onTap: (int index) => {
                  setState(() {
                    // Use the animateToPage method to change the page with animation
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubicEmphasized);
                  })
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_outlined),
                    label: 'Habit',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.timer_outlined),
                    label: 'Focus',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book_outlined),
                    label: 'Journal',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
