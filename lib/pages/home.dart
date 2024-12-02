import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'home_subpages/upcoming_bills.dart';
import 'home_subpages/spending_summary.dart';
import 'home_subpages/upcoming_debts.dart';
import 'home_subpages/tips_insights.dart';



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

  String _name = '';

  final TextEditingController balanceController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();

  bool isEditingBalance = false;
  bool isEditingIncome = false;

  @override
  void initState() {
    super.initState();
    _fetchName();
    _loadBalanceAndIncome(); 
     _listenForBalanceUpdates();
  }

  @override
  void dispose() {
    balanceController.dispose();
    incomeController.dispose();
    super.dispose();
  }



  Future<void> _fetchName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _name = doc['name'] ?? 'User Name';

      });
    }
  }



  Future<void> _loadBalanceAndIncome() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            currentBalance = userDoc['currentBalance'] ?? 0.00;
            monthlyIncome = userDoc['monthlyIncome'] ?? 0.00;

            balanceController.text = currentBalance.toStringAsFixed(2);
            incomeController.text = monthlyIncome.toStringAsFixed(2);
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }


  void _listenForBalanceUpdates() {
    final user = _auth.currentUser;
    if (user != null) {
      _firestore.collection('users').doc(user.uid).snapshots().listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            currentBalance = snapshot['currentBalance'] ?? 0.00;
            balanceController.text = currentBalance.toStringAsFixed(2);
          });
        }
      });
    }
  }

  Future<void> _updateUserData(String field, double value) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
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
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
               
          children: [
            const SizedBox(height: 34.0),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Welcome Back,  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28, 
                      ),
                      children: [
                        TextSpan(
                          text: _name + '!',
                          style: TextStyle(
                            color: const Color(0xFF535E4F),
                            fontWeight: FontWeight.bold,
                             fontStyle: FontStyle.italic,
                            fontSize: 28, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


            const SizedBox(height: 28.0),

            Container(
                height: 90, 
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EAE8), 
                  border: const Border(
                    top: BorderSide(color: Color(0xFF2D372D), width: 1.6), 
                    bottom:BorderSide(color: Color(0xFF2D372D), width: 1.6), 
                  ),

                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Current Balance:",
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        isEditingBalance
                            ? SizedBox(
                                width: 120, 
                                child: TextField(
                                  controller: balanceController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 24.0, 
                                    color: Color.fromARGB(255, 113, 116, 114),
                                   
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "\$${currentBalance.toStringAsFixed(2)}",
                                    border: InputBorder.none, 
                                    isDense: true, 
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (value) {
                                    final newBalance = double.tryParse(value) ?? 0.00;
                                    setState(() {
                                      currentBalance = newBalance;
                                      isEditingBalance = false;
                                    });
                                    _updateUserData('currentBalance', newBalance);
                                  },
                                ),
                              )
                            : Text(
                                "\$${currentBalance.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 24.0, 
                               
                                ),
                              ),
                      ],
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
              ),


              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3FBDC),
                  border: const Border(
                    top: BorderSide.none, 
                    bottom:BorderSide(color: Color(0xFF2D372D), width: 1.0),
                  ),

                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Monthly Income:",
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        isEditingIncome
                            ? SizedBox(
                                width: 120, 
                                child: TextField(
                                  controller: incomeController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 19.0, 
                                    color: Color.fromARGB(255, 113, 116, 114),
                          
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "\$${monthlyIncome.toStringAsFixed(2)}",
                                    border: InputBorder.none, 
                                    isDense: true, 
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (value) {
                                    final newIncome = double.tryParse(value) ?? 0.00;
                                    setState(() {
                                      monthlyIncome = newIncome;
                                      isEditingIncome = false;
                                    });
                                    _updateUserData('monthlyIncome', newIncome);
                                  },
                                ),
                              )
                            : Text(
                                "\$${monthlyIncome.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 19.0, 
                            
                                ),
                              ),
                      ],
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
              ),


            const SizedBox(height:52.0),


            Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double buttonWidth = (constraints.maxWidth / 10) - 10; 
                    buttonWidth = buttonWidth < 200 ? 200 : buttonWidth; 

                    return Container(      
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                   

                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 20.0,
                        childAspectRatio: 2,
                        children: [
                          SizedBox(
                            width: buttonWidth,
                            height: 100.0, 
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UpcomingBillsPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF59735C),
                                backgroundColor: const Color(0xFFF2F7F1),
                                side: const BorderSide(color: Color(0xFF3C583C), width: 1.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                                elevation: 2.5,
                              ),
                              child: const Center(
                                child: Text("Upcoming Bills"),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: buttonWidth,
                            height: 100.0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SpendingsSummaryPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF435145),
                                backgroundColor: const Color.fromARGB(255, 215, 222, 220),
                                side: const BorderSide(color: Color(0xFF39403C), width: 1.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                                elevation: 2.5,
                              ),
                              child: const Center(
                                child: Text("Spending Summary"),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: buttonWidth,
                            height: 100.0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UpcomingDebtsPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF435145),
                                backgroundColor: const Color.fromARGB(255, 215, 222, 220),
                                side: const BorderSide(color: Color(0xFF39403C), width: 1.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                                elevation: 2.5,
                              ),
                              child: const Center(
                                child: Text("Upcoming Debts"),
                              ),
                            ),
                          ),


                          SizedBox(
                            width: buttonWidth,
                            height: 100.0,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TipsInsightsPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF59735C),
                                backgroundColor: const Color(0xFFF2F7F1),
                                side: const BorderSide(color: Color(0xFF3C583C), width: 1.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                                elevation: 2.5,
                              ),
                              child: const Center(
                                child: Text("Tips and Insights"),
                              ),
                            ),
                          ),


                        ],
                      ),
                    );

                  },

                ),
              )


          ],
        ),
      ),
    );
  }
}



