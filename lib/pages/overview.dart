import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transactions.dart';
import 'package:intl/intl.dart'; 
import 'dart:math';


import 'overview_subpages/credit_advice.dart';
import 'overview_subpages/spendings_comparison.dart';
import 'overview_subpages/takehome_calculator.dart';


class OverviewPage extends StatefulWidget {
  final Function(int) onNavigate;

  const OverviewPage({super.key, required this.onNavigate});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

bool isLoading = true;
Map<String, List<double>> monthlyCategorySpendings = {};
List<String> topCategories = [];
double maxSpending = 0.0;


@override
void initState() {
  super.initState();
  _listenToTransactionUpdates();
  _fetchMonthlyExpenditureData();
  
}


void _listenToTransactionUpdates() {
  final user = _auth.currentUser;
  if (user == null) return; 

  //query transactions from past 3 months
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month - 2, 1); 
  final endOfMonth = DateTime(now.year, now.month + 1, 0); 

  _firestore
      .collection('users')
      .doc(user.uid)
      .collection('transactions')
      .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
      .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
      .snapshots()
      .listen((transactionsSnapshot) {

    _fetchMonthlyExpenditureData();
  });
}





List<String> _generateMonthLabels() {
  final now = DateTime.now();
  return List.generate(3, (index) {
    final monthDate = DateTime(now.year, now.month - index);
    return DateFormat('MMM').format(monthDate); 
  }).reversed.toList(); //reverse the order to show the least recent month first
}


Future<void> _fetchMonthlyExpenditureData() async {
  try {
    final user = _auth.currentUser;
    if (user == null) return; 

    //query transactions from past 3 months
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month - 2, 1); 
    final endOfMonth = DateTime(now.year, now.month + 1, 0); 

    QuerySnapshot transactionsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    final transactions = transactionsSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return TransactionItem.fromFirestore(doc.id, data);
    }).toList();

    if (transactions.isNotEmpty) {
      setState(() {
        Map<String, List<double>> tempMonthlyCategorySpendings = {};

        for (var transaction in transactions) {
          final category = transaction.category;
          final cost = transaction.cost;
          final date = transaction.date;
          final monthKey = DateFormat('MMM').format(date);

          if (!tempMonthlyCategorySpendings.containsKey(category)) {
            tempMonthlyCategorySpendings[category] = [0.0, 0.0, 0.0];
          }

          int monthIndex = (now.month - date.month + 12) % 3;
          tempMonthlyCategorySpendings[category]![monthIndex] += cost;
        }

        monthlyCategorySpendings = {
          for (var category in tempMonthlyCategorySpendings.keys)
            category: tempMonthlyCategorySpendings[category]!.reversed.toList(), 
        };

        topCategories = monthlyCategorySpendings.keys.toList();

        maxSpending = monthlyCategorySpendings.values
            .expand((list) => list)
            .reduce((a, b) => a > b ? a : b);

        isLoading = false; 
      });
    }
  } catch (e) {
    print('Error fetching data: $e');
    setState(() {
      isLoading = false;
    });
  }
}


//randomize color of bars
Color _getBarColor(int index) {
  final random = Random(index);
  return Color.fromARGB(
    255, 
    random.nextInt(256), 
    random.nextInt(256), 
    random.nextInt(256), 
  );
}
  


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView( 
        child: Column(
          children: [
            Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7B9B7),
                    border: const Border(
                        bottom:BorderSide(color: Color(0xFF2D372D), width: 2.0), 
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Center(
                    child: Text(
                      'Monthly Expenditure',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
                ),


            const SizedBox(height: 30), 
            

            if (topCategories.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'This represents your spendings in multiple categories across the past few months.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
            

            const SizedBox(height: 30), 

            
            if (topCategories.isNotEmpty &&
                    monthlyCategorySpendings.isNotEmpty &&
                    monthlyCategorySpendings.values.any((list) => list.any((value) => value > 0)))
                  Column(
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: screenSize.width * 0.8,
                            maxHeight: screenSize.height * 0.4,
                          ),
                        child: SimpleBarChart(
                            key: ValueKey(DateTime.now()), 
                            xAxisList: _generateMonthLabels(),
                            yAxisList: topCategories.map((category) {
                              return monthlyCategorySpendings[category] ?? [0.0, 0.0, 0.0];
                            }).toList(),
                            xAxisName: 'Months',
                            yAxisName: 'Amount (USD)',
                            maxSpending: maxSpending,
                            interval: (maxSpending > 0 ? maxSpending / 4 : 1),
                          ),


                        ),
                      ),
                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: topCategories.map((category) {
                          final color =
                              _getBarColor(topCategories.indexOf(category));
                          return _buildLegendItem(color, category);
                        }).toList(),
                      ),
                    ],
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'No spending data found for the last few months. Start adding transactions to see insights!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),


            const SizedBox(height: 30), 

            Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7B9B7),
                    border: const Border(
                        top: BorderSide(color: Color(0xFF2D372D), width: 2.0), 
                        bottom:BorderSide(color: Color(0xFF2D372D), width: 2.0), 
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Center(
                    child: Text(
                      'Net Income Calculator',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
                ),


              const SizedBox(height: 30), 

              NetIncomeCalculator(),

              const SizedBox(height: 30), 


              Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7B9B7),
                    border: const Border(
                        top: BorderSide(color: Color(0xFF2D372D), width: 2.0), 
                        bottom:BorderSide(color: Color(0xFF2D372D), width: 2.0), 
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Center(
                    child: Text(
                      'Other Tools',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
                ),


              Padding(
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), 
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E4E4),      
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text("Your Spendings Compared to Your Budget"),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SpendingsComparisonPage()),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.privacy_tip),
                            title: const Text("Credit Information + How to Improve Your Credit"),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreditAdvicePage()),
                              );
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.question_answer),
                            title: const Text("Calculate Take Home Money After Taxes (For US Residents)"),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TakeHomeMoneyPage()),
                              );
                            },
                          ),
                        
                        ],
                      ),
                    ),
                  ),

            
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




class SimpleBarChart extends StatefulWidget {
  final List<String> xAxisList;
  final String xAxisName;
  final List<List<double>> yAxisList;
  final String yAxisName;
  final double interval;

  final double maxSpending;
  

  const SimpleBarChart({
    super.key,
    required this.xAxisList,
    required this.yAxisList,
    required this.xAxisName,
    required this.yAxisName,
    required this.interval,
    required this.maxSpending,
  });

  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {
  late List<String> xAxisList;
  late List<List<double>> yAxisList;
  late String xAxisName;
  late String yAxisName;
  late double interval;

  late double maxSpending;

  @override
  void initState() {
    super.initState();
    xAxisList = widget.xAxisList;
    yAxisList = widget.yAxisList;
    xAxisName = widget.xAxisName;
    yAxisName = widget.yAxisName;
    maxSpending=widget.maxSpending;
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
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                return Text(xAxisList[index]); 
              },
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
        barGroups: _generateChartData(),
        maxY: maxSpending,


        barTouchData: BarTouchData(
  
        touchTooltipData: BarTouchTooltipData(
           getTooltipColor: (BarChartGroupData group) => const Color.fromARGB(255, 221, 221, 221),

          tooltipRoundedRadius: 8, 
          getTooltipItem: (group, groupIndex, rod, rodIndex) {

            return BarTooltipItem(
              '${rod.toY.toStringAsFixed(2)}', 
               TextStyle(
                color: _getBarColor(rodIndex),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
            
      ),
    );
  }

  List<BarChartGroupData> _generateChartData() {
    List<BarChartGroupData> data = [];

    for (int i = 0; i < xAxisList.length; i++) {
      List<BarChartRodData> rods = [];
      for (int j = 0; j < yAxisList.length; j++) {
        rods.add(
          BarChartRodData(
            toY: yAxisList[j][i],
            color: _getBarColor(j),
            width: 13, 
            borderRadius: BorderRadius.zero, 
          ),
        );
      }
      data.add(
        BarChartGroupData(
          x: i,
          barRods: rods,
        ),
      );
    }
    return data;
  }

Color _getBarColor(int index) {
  final random = Random(index);
  return Color.fromARGB(
    255, 
    random.nextInt(256), 
    random.nextInt(256), 
    random.nextInt(256), 
  );
}

}




class NetIncomeCalculator extends StatefulWidget {
  @override
  _NetIncomeCalculatorState createState() => _NetIncomeCalculatorState();
}

class _NetIncomeCalculatorState extends State<NetIncomeCalculator> {
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expensesController = TextEditingController();
  String _resultMessage = "";

  void _calculateNetIncome() {
    final double? totalIncome = double.tryParse(_incomeController.text);
    final double? totalExpenses = double.tryParse(_expensesController.text);

    if (totalIncome != null && totalExpenses != null) {
      final netIncome = totalIncome - totalExpenses;
      setState(() {
        _resultMessage =
            "After paying all your expenses, you will have \$${netIncome.toStringAsFixed(2)} left over.";
      });
    } else {
      setState(() {
        _resultMessage = "Please enter valid numbers for both fields.";
      });
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           
      Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Row(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
          const Text(
            'Total Income:', 
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black, 
            ),
          ),
          const SizedBox(width: 8), 

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), 
                    blurRadius: 1.0,                     
                    offset: Offset(0, 2),               
                  ),
                ],
              ),
              child: TextField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Colors.black, 
                      width: 0.8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Colors.black, 
                      width: 0.8,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: Colors.black, 
                      width: 1.2,
                    ),
                  ),
                  fillColor: const Color.fromARGB(255, 246, 246, 246), 
                  filled: true, 
                ),
              ),
            ),
          ),

        ],
      ),
          const SizedBox(height: 16), 
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Total Expenses:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
              ),
              const SizedBox(width: 8), 

              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), 
                          blurRadius: 1.0,                     
                          offset: Offset(0, 2),                 
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _expensesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            color: Colors.black, 
                            width: 0.8,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            color: Colors.black, 
                            width: 0.8,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.2,
                          ),
                        ),
                        fillColor: const Color.fromARGB(255, 246, 246, 246), 
                        filled: true, 
                      ),
                    ),
                  ),
                ),


            ],
          ),
        ],
      ),


          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: _calculateNetIncome,
            style: ElevatedButton.styleFrom(
                      elevation: 2.5,
                      foregroundColor: Color.fromARGB(255, 39, 39, 39),
                      backgroundColor: const Color.fromARGB(255, 180, 194, 176), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.black, 
                          width: 1.5, 
                        ),
                      ),
                      minimumSize: const Size(120, 50), 
                      
                      textStyle: TextStyle(fontSize: 18),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
            child: const Text('Submit'),
          ),


          const SizedBox(height: 24),
          if (_resultMessage.isNotEmpty)
            Text(
              _resultMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
