import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../transactions.dart';
import '../budget.dart';
import 'package:intl/intl.dart'; 

class SpendingsComparisonPage extends StatefulWidget {
  const SpendingsComparisonPage({Key? key}) : super(key: key);

  @override
  _SpendingsComparisonPageState createState() => _SpendingsComparisonPageState();
}

class _SpendingsComparisonPageState extends State<SpendingsComparisonPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, double> spendings = {};
  Map<String, double> budgets = {};
  double totalDifference = 0.0;

    @override
    void initState() {
      super.initState();
      _loadSpendingsAndBudgets();
    }

    Future<void> _loadSpendingsAndBudgets() async {
      final user = _auth.currentUser;
      if (user == null) return;

      final today = DateTime.now();
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1); 
      final endOfMonth = DateTime(now.year, now.month + 1, 0); 


      try {
        QuerySnapshot transactionsSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
            .get();

        Map<String, double> tempSpendings = {};
        for (var doc in transactionsSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final category = data['category'] as String;
          final cost = (data['cost'] as num).toDouble();
          tempSpendings[category] = (tempSpendings[category] ?? 0) + cost;
        }

        QuerySnapshot budgetSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('budget')
            .get();

        Map<String, double> tempBudgets = {};
        for (var doc in budgetSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final category = data['category'] as String;
          final cost = (data['cost'] as num).toDouble();
          tempBudgets[category] = cost;
        }

        setState(() {
          spendings = tempSpendings;
          budgets = tempBudgets;
          totalDifference = tempBudgets.entries.fold(0, (sum, entry) {
            final actualSpent = tempSpendings[entry.key] ?? 0.0;
            return sum + (actualSpent - entry.value);
          });
        });
      } catch (e) {
        print("Error loading data: $e");
      }
    }


    @override
    Widget build(BuildContext context) {
      final sharedCategories = spendings.keys.where((category) => budgets.containsKey(category)).toList();

      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 23, 28, 24),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: const Text(
                  'Recent Spendings Vs Budget',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              if (sharedCategories.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'You either haven\'t inputted any transactions within the past month, don\'t have a set budget, or none of the categories in your transactions match any of the categories you set in your budget.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7B9B7),
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 1.9),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Category",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Actual Spendings',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Set Budget',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 1.3),
                      bottom: BorderSide(color: Colors.black, width: 1.9),
                    ),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: sharedCategories.map((category) {
                      final actualSpent = spendings[category]!;
                      final budgetValue = budgets[category]!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                category,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '\$${actualSpent.toStringAsFixed(2)}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 127, 127, 127)),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '\$${budgetValue.toStringAsFixed(2)}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 127, 127, 127)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: const Text(
                    'Difference',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                ...sharedCategories.map((category) {
                  final actualSpent = spendings[category]!;
                  final budgetValue = budgets[category]!;
                  final difference = actualSpent - budgetValue;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '$category = ',
                                style: const TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: difference > 0
                                    ? 'Over Budget by \$${difference.toStringAsFixed(2)}'
                                    : difference < 0
                                        ? 'Under Budget by \$${(-difference).toStringAsFixed(2)}'
                                        : 'Exactly on Budget',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: difference > 0
                                      ? const Color.fromARGB(255, 155, 97, 93)
                                      : difference < 0
                                          ? const Color.fromARGB(255, 134, 174, 135)
                                          : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                         const SizedBox(height: 40),
                      ],
                    ),
                    
                  );
                }).toList(),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    }

}
