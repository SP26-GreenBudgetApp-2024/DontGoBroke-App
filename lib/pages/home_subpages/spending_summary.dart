import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../transactions.dart';
import 'package:intl/intl.dart'; 

class SpendingsSummaryPage extends StatefulWidget {
  const SpendingsSummaryPage({Key? key}) : super(key: key);

  @override
  _SpendingsSummaryPageState createState() => _SpendingsSummaryPageState();
}

class _SpendingsSummaryPageState extends State<SpendingsSummaryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool hasRecentlySpent = false;
  Map<String, double> categorySpendings = {};
  double totalSpending = 0.0;

  @override
  void initState() {
    super.initState();
    _loadRecentSpendings();
  }

  Future<void> _loadRecentSpendings() async {
    final user = _auth.currentUser;
    if (user != null) {

      //query all transactions within past 30 days
      final today = DateTime.now();
      final thirtyDaysAgo = today.subtract(const Duration(days: 30));

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo))
          .get();

      final transactions = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TransactionItem.fromFirestore(doc.id, data);
      }).toList();

      if (transactions.isNotEmpty) {
        setState(() {
          hasRecentlySpent = true;

  
          Map<String, double> tempCategorySpendings = {};
          double tempTotalSpending = 0.0;

          for (var transaction in transactions) {
            final category = transaction.category;
            final cost = transaction.cost;

            tempCategorySpendings[category] = (tempCategorySpendings[category] ?? 0) + cost;
            tempTotalSpending += cost;
          }

          final sortedCategories = tempCategorySpendings.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));


          Map<String, double> finalCategorySpendings = {};
          double otherSpending = 0.0;

          for (int i = 0; i < sortedCategories.length; i++) {
            if (i < 6) {
              finalCategorySpendings[sortedCategories[i].key] = sortedCategories[i].value;
            } else {
              otherSpending += sortedCategories[i].value;
            }
          }

          if (otherSpending > 0) {
            finalCategorySpendings['everything else'] = otherSpending;
          }

          categorySpendings = finalCategorySpendings;
          totalSpending = tempTotalSpending;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 28, 24), 
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),

      body: Center( 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              mainAxisSize: MainAxisSize.min, 
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 42.0),
                  child: Text(
                    'Recent Spendings Summary',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                if (!hasRecentlySpent)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "You haven't made any transactions in the last 30 days.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF282A28),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center, 
                          children: [
                            const Text(
                              'In the past 30 days, you have spent...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF545B53),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ...categorySpendings.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  '\$${entry.value.toStringAsFixed(2)} on ${entry.key}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Color(0xFF566554),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (hasRecentlySpent)
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      'Overall, you have spent \$${totalSpending.toStringAsFixed(2)} these past 30 days.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 53, 55, 53),
                      ),
                    ),
                  ),
              ],
            ),
        ),

    );
  }
}
