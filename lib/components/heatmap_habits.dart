import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatmapHabits extends StatelessWidget {
  const HeatmapHabits({
    super.key,
    required this.dataset,
    required this.startDate,
    required this.onDateSelected,
    required this.selectedCalendarDate,
  });

  final Map<DateTime, int>? dataset;
  final String startDate;
  final void Function(DateTime date) onDateSelected;
  final DateTime selectedCalendarDate;
  static const int _selectedDayOffset = 10;

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime normalizedToday = DateTime(today.year, today.month, today.day);

    DateTime normalizedSelectedDate = DateTime(
      selectedCalendarDate.year,
      selectedCalendarDate.month,
      selectedCalendarDate.day,
    );

    Map<DateTime, int> displayDataset = {};
    if (dataset != null) {
      displayDataset.addAll(dataset!);
    }

    int? selectedDayOriginalValue = displayDataset[normalizedSelectedDate];
    if (selectedDayOriginalValue == null || selectedDayOriginalValue == 0) {
      displayDataset[normalizedSelectedDate] = 1 + _selectedDayOffset;
    } else {
      displayDataset[normalizedSelectedDate] = selectedDayOriginalValue + _selectedDayOffset;
    }

    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.white),
        primaryColor: Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: HeatMapCalendar(
          textColor: Colors.white,
          showColorTip: false,
          datasets: displayDataset,
          initDate: normalizedToday,
          colorMode: ColorMode.color,
          defaultColor: Colors.grey[800],
          colorsets: const {
            1: Color.fromARGB(20, 2, 179, 8),
            2: Color.fromARGB(40, 2, 179, 8),
            3: Color.fromARGB(60, 2, 179, 8),
            4: Color.fromARGB(80, 2, 179, 8),
            5: Color.fromARGB(100, 2, 179, 8),
            6: Color.fromARGB(120, 2, 179, 8),
            7: Color.fromARGB(150, 2, 179, 8),
            8: Color.fromARGB(180, 2, 179, 8),
            9: Color.fromARGB(220, 2, 179, 8),
            10: Color.fromARGB(255, 2, 179, 8),
          },
          onClick: (date) {
            onDateSelected(date);
          },
          size: 40,
          fontSize: 16,
          monthFontSize: 20,
          weekFontSize: 16,
          weekTextColor: Colors.white,
        ),
      ),
    );
  }
}
