import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoricalDataScreen extends StatefulWidget {
  const HistoricalDataScreen({super.key});

  @override
  HistoricalDataScreenState createState() => HistoricalDataScreenState();
}

class HistoricalDataScreenState extends State<HistoricalDataScreen> {
  String selectedRange = 'Day';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Settings or export options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Time Range Selector
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Hour', 'Day', 'Week'].map((range) {
                return ChoiceChip(
                  label: Text(range),
                  selected: selectedRange == range,
                  onSelected: (isSelected) {
                    setState(() {
                      selectedRange = range;
                    });
                    // Fetch data based on selected range
                  },
                );
              }).toList(),
            ),
          ),

          // Chart Area
          SizedBox(
            width: width * .95,
            height: height * .35,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineChart(
                  LineChartData(
                    // Customize chart data and style here
                    titlesData: const FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                    ),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _getChartData(selectedRange),
                        isCurved: true,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getChartData(String range) {
    // Sample data based on range
    if (range == 'Hour') {
      return [
        const FlSpot(0, 1),
        const FlSpot(1, 1.5),
        const FlSpot(2, 1.2),
        const FlSpot(3, 2.8),
      ];
    } else if (range == 'Day') {
      return [
        const FlSpot(0, 1.5),
        const FlSpot(1, 2),
        const FlSpot(2, 1.8),
        const FlSpot(3, 2.2),
      ];
    } else {
      return [
        const FlSpot(0, 2),
        const FlSpot(1, 2.5),
        const FlSpot(2, 3),
        const FlSpot(3, 4),
      ];
    }
  }
}


