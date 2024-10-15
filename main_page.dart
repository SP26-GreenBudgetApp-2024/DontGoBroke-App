import 'package:flutter/material.dart';
import 'package:myapp/pages/user_profile.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double currentBalance = 1000.00; // Example balance
  double monthlyIncome = 3000.00; // Example monthly income

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Main Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle profile button press
              print("profile button pressed");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Back Text
            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),

            // Current Balance
            Card(
              color: Colors.lightGreen[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Balance",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "\$${currentBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Monthly Income
            Card(
              color: Colors.lightGreen[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Monthly Income",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "\$${monthlyIncome.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Buttons for Upcoming Bills, Spending Summary, Debt Payments, and Tips & Insights
            ElevatedButton(
              onPressed: () {
                print("Upcoming Bills button pressed");
              },
              child: const Text("Upcoming Bills"),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                print("Spending Summary button pressed");
              },
              child: const Text("Spending Summary"),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                print("Debt Payments button pressed");
              },
              child: const Text("Debt Payments"),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                print("Tips & Insights button pressed");
              },
              child: const Text("Tips & Insights"),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
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
          // Handle bottom navigation taps
          switch (index) {
            case 0:
              print("Home tapped");
              break;
            case 1:
              print("Transactions tapped");
              break;
            case 2:
              print("Budget tapped");
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