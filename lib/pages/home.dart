import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function(int) onNavigate; // Function to handle navigation
  final double currentBalance; // Current balance
  final double monthlyIncome; // Monthly income

  const HomePage({
    super.key,
    required this.onNavigate,
    required this.currentBalance,
    required this.monthlyIncome,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Make the body scrollable
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              color: const Color.fromARGB(255, 191, 211, 168),
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
              color: const Color.fromARGB(255, 191, 211, 168),
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

            // Centered buttons for Upcoming Bills, Spending Summary, Debt Payments, and Tips & Insights
            Center(
              child: Container(
                 width: 600, // Set a width to control the span of buttons
                child: GridView.count(
                  shrinkWrap: true, // Allows the GridView to take only the required height
                  physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  crossAxisCount: 2, // Two buttons per row
                  childAspectRatio: 2, // Make buttons square
                  mainAxisSpacing: 40.0, // Vertical space between buttons
                  crossAxisSpacing: 40.0, // Horizontal space between buttons


                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Upcoming Bills button press
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)), // Slightly rounded corners
                            ),

                            minimumSize: const Size(100, 100), // Size of buttons
                            backgroundColor: const Color.fromARGB(255, 224, 224, 224), // Set the background color
                            foregroundColor: Color.fromARGB(255, 46, 47, 46),
                      ),
                      child: const Text("Upcoming Bills"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Spending Summary button press
                      },
                      style: ElevatedButton.styleFrom(
                               shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)), // Slightly rounded corners
                            ),

                         minimumSize: const Size(100, 100), // Size of buttons
                         backgroundColor: const Color.fromARGB(255, 224, 224, 224), // Set the background color
                         foregroundColor: Color.fromARGB(255, 46, 47, 46),
                      ),
                      child: const Text("Spending Summary"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Debt Payments button press
                      },
                      style: ElevatedButton.styleFrom(
                               shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)), // Slightly rounded corners
                            ),
                          minimumSize: const Size(100, 100), // Size of buttons
                          backgroundColor: const Color.fromARGB(255, 224, 224, 224), // Set the background color
                          foregroundColor: Color.fromARGB(255, 46, 47, 46),
                      
                      ),
                      child: const Text("Debt Payments"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Tips & Insights button press
                      },
                      style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)), // Slightly rounded corners
                            ),
                          minimumSize: const Size(100, 100), // Size of buttons
                          backgroundColor: const Color.fromARGB(255, 224, 224, 224), // Set the background color
                          foregroundColor: Color.fromARGB(255, 46, 47, 46),
                      ),
                      child: const Text("Tips & Insights"),
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
}
