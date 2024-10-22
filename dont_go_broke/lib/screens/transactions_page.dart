import 'package:flutter/material.dart';
import 'main_page.dart';

class TransactionsPage extends StatelessWidget {
  final double accountBalance = 1200.50; // Example balance
  final List<Map<String, String>> recentTransactions = [
    {
      'date': 'Oct 10, 2024',
      'description': 'Grocery Shopping',
      'amount': '-\$50.00'
    },
    {'date': 'Oct 9, 2024', 'description': 'Salary', 'amount': '+\$1500.00'},
    {
      'date': 'Oct 8, 2024',
      'description': 'Electricity Bill',
      'amount': '-\$100.00'
    },
    {'date': 'Oct 7, 2024', 'description': 'Dinner', 'amount': '-\$30.00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Transactions'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Balance Section
            Text(
              "Account Balance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              "\$$accountBalance",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),

            // Recent Transactions Section
            Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),

            // Display each transaction in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(recentTransactions[index]['description']!),
                    subtitle: Text(recentTransactions[index]['date']!),
                    trailing: Text(
                      recentTransactions[index]['amount']!,
                      style: TextStyle(
                        color:
                        recentTransactions[index]['amount']!.startsWith('-')
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom toolbar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Budget',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Overview',
          ),
        ],
        onTap: (int index) {
          // Handle bottom navigation taps and navigation
          switch (index) {
            case 0:
              print("Home tapped");
              // Navigate to Home page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
              break;
            case 1:
              print("Transactions tapped");
              // Navigate to Transactions page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionsPage()),
              );
              break;
            case 2:
              print("Budget tapped");
              // Navigate to Budget page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetPage()));
              break;
            case 3:
              print("Overview tapped");
              // Navigate to Overview page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => OverviewPage()));
              break;
          }
        },
      ),
    );
  }
}