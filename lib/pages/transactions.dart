import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  final Function(int) onNavigate; 
  final double accountBalance = 1200.50; //example balance



  //transaction list
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

  TransactionsPage({super.key, required this.onNavigate});




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), 



        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 197, 197, 197),
          automaticallyImplyLeading: false, 
          centerTitle: true, 
          title: const Text(
            'Transaction History', style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 39, 39, 39),
                ),
          ),
          elevation: 0, // Remove shadow below the AppBar if desired
        ),
      ),



      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centering the Account Balance Section
            Center(
              child: Column(
                children: [
                  const Text(
                    "Account Balance",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "\$$accountBalance",
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Recent Transactions Section
            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),

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
                        color: recentTransactions[index]['amount']!.startsWith('-')
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
    );
  }
}
