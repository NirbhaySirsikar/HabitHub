import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final double size;
  final bool showText;
  const MonthlySummary({super.key, required this.datasets, required this.size, required this.showText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HeatMap(
        // endDate: DateTime(2023,11),
        endDate: DateTime.now(),
        startDate: DateTime.now().subtract(const Duration(days: 49)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.white12,
        textColor: Colors.white,
        showColorTip: false,
        showText: showText,
        scrollable: true,
        size: size,
        fontSize: 12,
        colorsets: const {
          1: Color.fromARGB(20, 127, 0, 250),
          2: Color.fromARGB(40, 127, 0, 250),
          3: Color.fromARGB(60, 127, 0, 250),
          4: Color.fromARGB(80, 127, 0, 250),
          5: Color.fromARGB(100, 127, 0, 250),
          6: Color.fromARGB(120, 127, 0, 250),
          7: Color.fromARGB(150, 127, 0, 250),
          8: Color.fromARGB(180, 127, 0, 250),
          9: Color.fromARGB(220, 127, 0, 250),
          10: Color.fromARGB(255, 127, 0, 250),
        },
        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ),
    );
  }
}
