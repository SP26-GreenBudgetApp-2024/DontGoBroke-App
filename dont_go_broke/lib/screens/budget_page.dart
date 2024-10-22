import 'package:flutter/material.dart';
import '../utils/donut_chart.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  double currentBalance = 1000.00; // Example balance
  double monthlyIncome = 3000.00; // Example monthly income

  // List of budget items
  final List<Map<String, dynamic>> budgetItems = [
    {'name': 'Rent', 'amount': 1200.0},
    {'name': 'Car Payment', 'amount': 300.0},
    {'name': 'Groceries', 'amount': 400.0},
    {'name': 'Utilities', 'amount': 150.0},
    {'name': 'Internet', 'amount': 60.0},
    {'name': 'Entertainment', 'amount': 100.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Budget Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to the UserProfilePage using named route
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),

      // Body section with Column layout
      body: Column(
        children: <Widget>[
          // monthly expenses container at top of page
          Container(
            color: Colors.grey[900],
            child: const Center(
              child: Text(
                'Monthly Expenses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // donut chart which comes after the monthly expenses container
          const SizedBox(
            height: 300,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: DonutChart(),
            ),
          ),

          // Budget Items header
          Container(
            color: Colors.grey[900],
            child: const Center(
              child: Text(
                'Budget Items',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Dynamic list of budget items
          Expanded(
            child: ListView.builder(
              itemCount: budgetItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(budgetItems[index]['name']),
                  trailing: Text(
                    '\$${budgetItems[index]['amount'].toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Overview',
          ),
        ],
        onTap: (int index) {
          // Handle bottom navigation taps
          switch (index) {
            case 0:
              print("Home tapped");
              break;
            case 1:
              Navigator.pushNamed(context, '/transactions');
              break;
            case 2:
              Navigator.pushNamed(context, '/budget');
              break;
            case 3:
              print("Overview tapped");
              break;
          }
        },
      ),
    );
  }
}
