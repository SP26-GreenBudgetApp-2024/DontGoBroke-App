import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final Function(int) onNavigate;

  const HomePage({Key? key, required this.onNavigate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double currentBalance = 0.00;
  double monthlyIncome = 0.00;

  final TextEditingController balanceController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();

  bool isEditingBalance = false;
  bool isEditingIncome = false;

  @override
  void initState() {
    super.initState();
    _loadUserData(); //load user data when the app starts
  }

  @override
  void dispose() {
    balanceController.dispose();
    incomeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        //get user document from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            currentBalance = userDoc['currentBalance'] ?? 0.00;
            monthlyIncome = userDoc['monthlyIncome'] ?? 0.00;

            //update text fields with loaded data
            balanceController.text = currentBalance.toStringAsFixed(2);
            incomeController.text = monthlyIncome.toStringAsFixed(2);
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _updateUserData(String field, double value) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        //update field in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          field: value,
        }, SetOptions(merge: true)); 
      }
    } catch (e) {
      print('Error updating $field: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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


            //current balance card
            Card(
              color: const Color.fromARGB(255, 191, 211, 168),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
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

                          //inline editing for Balance
                          isEditingBalance
                              ? TextField(
                                  controller: balanceController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Enter balance",
                                    border: UnderlineInputBorder(),
                                    isDense: true,
                                  ),
                                  onSubmitted: (value) {
                                    final newBalance =
                                        double.tryParse(value) ?? 0.00;
                                    setState(() {
                                      currentBalance = newBalance;
                                      isEditingBalance = false;
                                    });
                                    _updateUserData(
                                        'currentBalance', newBalance);
                                  },
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$${currentBalance.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          isEditingBalance = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 16.0),



            //monthly income card
            Card(
              color: const Color.fromARGB(255, 191, 211, 168),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
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

                          //inline editing for income
                          isEditingIncome
                              ? TextField(
                                  controller: incomeController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Enter income",
                                    border: UnderlineInputBorder(),
                                    isDense: true,
                                  ),
                                  onSubmitted: (value) {
                                    final newIncome =
                                        double.tryParse(value) ?? 0.00;
                                    setState(() {
                                      monthlyIncome = newIncome;
                                      isEditingIncome = false;
                                    });
                                    _updateUserData('monthlyIncome', newIncome);
                                  },
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$${monthlyIncome.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          isEditingIncome = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),




                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            

            const SizedBox(height: 32.0),


            //buttons section
            Center(
              child: Container(
                width: 600,
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  mainAxisSpacing: 40.0,
                  crossAxisSpacing: 40.0,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        //navigate to upcoming bills page
                      },
                      child: const Text("Upcoming Bills"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //navigate to spending summary page
                      },
                      child: const Text("Spending Summary"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //navigate to debt payments page
                      },
                      child: const Text("Debt Payments"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //navigate to tips and insights page
                      },
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



