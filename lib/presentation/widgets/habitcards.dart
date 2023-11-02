import 'package:flutter/material.dart';

import 'graph.dart';

class HabitCard1 extends StatelessWidget {
  const HabitCard1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 10, bottom: 10, left: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1b2339),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                blurRadius: 5, offset: Offset(3, 3), color: Colors.black26),
          ],
        ),
        height: 200,
        width: 180,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Consistency Graph',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              LineChartSample2(),
            ],
          ),
        ),
      ),
    );
  }
}

class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurpleAccent, width: 3),
          boxShadow: const [
            BoxShadow(
                blurRadius: 5, offset: Offset(3, 3), color: Colors.black26),
          ],
        ),
        height: 200,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   icon,
                    //   style: const TextStyle(fontSize: 36),
                    // ),
                    // const SizedBox(height: 15),
                    Text(
                      title,
                      maxLines: 4,
                      style: const TextStyle(
                          fontSize: 24, overflow: TextOverflow.fade
                          // color: Colors.black,
                          ),
                    ),
                    const Text(
                      'Everyday',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                // Text(
                //   '$progress/30',
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //     // color: Colors.black,
                //   ),
                // ),
              ]),
        ),
      ),
    );
  }
}
