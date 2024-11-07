import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OverviewPage extends StatelessWidget {
  final Function(int) onNavigate; // Function to handle navigation

  const OverviewPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        title: const Text(
          'Monthly Expenditure',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 39, 39, 39),
          ),
          textAlign: TextAlign.center, // Center the title
        ),
        centerTitle: true, // Centers the title
      ),
      body: SingleChildScrollView( // Allows scrolling in case of overflow
        child: Column(
          children: [
            const SizedBox(height: 20), // Space between heading and chart
            
            // Bar chart section
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.8,
                  maxHeight: screenSize.height * 0.4, // Fixed height for the bar chart
                ),
                child: SimpleBarChart(
                  xAxisList: ['Aug', 'Sep', 'Oct'],
                  yAxisList: [
                    [1600, 900, 470, 400, 300], // August values
                    [1600, 950, 470, 500, 250], // September values
                    [1600, 900, 470, 300, 250], // October values
                  ],
                  xAxisName: 'Months',
                  yAxisName: 'Amount (USD)',
                  interval: 400,
                ),
              ),
            ),

            const SizedBox(height: 20), // Space for legend
            // Legend section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue[200]!, 'Rent'),
                _buildLegendItem(Colors.red[200]!, 'Car'),
                _buildLegendItem(Colors.green[200]!, 'Utilities'),
                _buildLegendItem(Colors.yellow[200]!, 'Food'),
                _buildLegendItem(Colors.purple[200]!, 'Other'),
              ],
            ),

            const SizedBox(height: 30), // Extra space below the chart
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}

// SimpleBarChart class remains unchanged

class SimpleBarChart extends StatefulWidget {
  final List<String> xAxisList;
  final String xAxisName;
  final List<List<double>> yAxisList; // Multiple values for each x-axis label
  final String yAxisName;
  final double interval;

  const SimpleBarChart({
    super.key,
    required this.xAxisList,
    required this.yAxisList,
    required this.xAxisName,
    required this.yAxisName,
    required this.interval,
  });

  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {
  late List<String> xAxisList;
  late List<List<double>> yAxisList; // Multiple values per x-axis
  late String xAxisName;
  late String yAxisName;
  late double interval;

  @override
  void initState() {
    super.initState();
    xAxisList = widget.xAxisList;
    yAxisList = widget.yAxisList;
    xAxisName = widget.xAxisName;
    yAxisName = widget.yAxisName;
    interval = widget.interval;
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(
              xAxisName,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => bottomTitles(value, meta, xAxisList),
              reservedSize: 42,
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: Padding(
              padding: const EdgeInsets.only(left: 55.0),
              child: Text(
                yAxisName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: interval,
              getTitlesWidget: barChartLeftTitles,
            ),
          ),
        ),
        borderData: FlBorderData(
          border: const Border(
            top: BorderSide.none,
            right: BorderSide.none,
            left: BorderSide(width: 1),
            bottom: BorderSide(width: 1),
          ),
        ),
        gridData: FlGridData(show: false),
        barGroups: List.generate(
          xAxisList.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: List.generate(
              yAxisList[index].length,
              (attrIndex) => BarChartRodData(
                toY: yAxisList[index][attrIndex],
                width: 13,
                color: _getBarColor(attrIndex),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
        maxY: 1700, // Adjust to cover the highest y value
      ),
    );
  }

  Color _getBarColor(int index) {
    switch (index) {
      case 0: return Colors.blue[200]!;  // Rent
      case 1: return Colors.red[200]!;   // Car
      case 2: return Colors.green[200]!; // Utilities
      case 3: return Colors.yellow[200]!; // Food
      case 4: return Colors.purple[200]!; // Other
      default: return Colors.black; // Default case
    }
  }

  Widget bottomTitles(double value, TitleMeta meta, List<String> xAxisList) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Aug', style: style);
        break;
      case 1:
        text = const Text('Sep', style: style);
        break;
      case 2:
        text = const Text('Oct', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }

  Widget barChartLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 400:
        text = '400';
        break;
      case 800:
        text = '800';
        break;
      case 1200:
        text = '1200';
        break;
      case 1600:
        text = '1600';
        break;
      default:
        return const SizedBox.shrink();
    }
    return SideTitleWidget(child: Text(text, style: style), axisSide: meta.axisSide);
  }
}
