import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';


class TransactionsPage extends StatefulWidget {
  final Function(int) onNavigate;

  const TransactionsPage({super.key, required this.onNavigate});

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
   List<TransactionItem> transactionItems = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double accountBalance = 0.00;


  final TextEditingController balanceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  
  bool _isAddingNew = false;
  bool isEditingBalance=false;
  bool dateError=false;



  DateTime? selectedDate;
  

Future<void> _pickDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  if (picked != null && picked != selectedDate) {
    setState(() {
      selectedDate = picked;
      dateController.text = '${picked.toLocal()}'.split(' ')[0];
    });
  }
}




  @override
  void initState() {
    super.initState();
    _loadBalance();
      _loadTransactions();
    _listenForBalanceUpdates();
  }


  @override
  void dispose() {
    balanceController.dispose();
    super.dispose();
  }



   Future<void> _loadBalance() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            accountBalance = userDoc['currentBalance'] ?? 0.00;
       
            balanceController.text = accountBalance.toStringAsFixed(2);
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
            accountBalance = snapshot['currentBalance'] ?? 0.00;
            balanceController.text = accountBalance.toStringAsFixed(2);
          });
        }
      });
    }
  }

  Future<void> _updateBalance() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {

      final newBalance = double.tryParse(balanceController.text) ?? accountBalance;
      await _firestore.collection('users').doc(user.uid).update({
        'currentBalance': newBalance,
      });

      setState(() {
        accountBalance = newBalance; 
      });
    }
  } catch (e) {
    print('Error updating balance: $e');
  }
}


Future<void> _loadTransactions() async {
  final user = _auth.currentUser;
  if (user != null) {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .get();
    setState(() {
      transactionItems = snapshot.docs.map((doc) {
        return TransactionItem.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
      }).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); 
    });
  }
}


Future<void> _addTransaction() async {
  final user = _auth.currentUser;
  if (user != null) {
    final newTransaction = TransactionItem(
      id: '',
      description: descriptionController.text,
      category: categoryController.text,
      cost: double.tryParse(costController.text) ?? 0.0,
      date: selectedDate ?? DateTime.now(), 
    );
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .add(newTransaction.toMap());
    

    _loadTransactions(); 
    setState(() {
      _isAddingNew = false;
      descriptionController.clear();
      categoryController.clear();
      costController.clear();
      dateController.clear();
      selectedDate = null;
    });
  }
}


Future<void> _updateTransaction(TransactionItem item) async {
  final user = _auth.currentUser;
  if (user != null) {
    try {
      final transactionsRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions');


      await transactionsRef.doc(item.id).update({
        'description': item.description,
        'category': item.category,
        'cost': item.cost,
        'date': Timestamp.fromDate(item.date), 
      });

      _loadTransactions(); 
    } catch (e) {
      print("Error updating transaction item: $e");
    }
  }
}




  Future<void> _deleteTransaction(String id) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(id)
          .delete();
      _loadTransactions();  
    }
  }



String getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid; 
  } else {
    throw Exception('User is not signed in');
  }
}



bool isValidDate(DateTime date) {
  DateTime currentDate = DateTime.now();
  if (date.year < 1900 || date.year > currentDate.year + 1) {
    return false; 
  }

  if (date.month < 1 || date.month > 12) {
    return false; 
  }

  //handle leap years +  check if the day is valid for the given month
  try {
    DateTime tempDate = DateTime(date.year, date.month, date.day);
    if (tempDate.month != date.month) {
      return false; 
    }
  } catch (e) {
    return false; 
  }

  return true;
}



  Widget _buildStyledTextField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
    
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 64, 64, 64),
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 0.8,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 0.8,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.2,
            ),
          ),
          fillColor: const Color.fromARGB(255, 245, 246, 254),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: TextStyle(fontSize: 18),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
   return SingleChildScrollView(
      child: Column(
        children: [
           Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFB7B9B7),
                    border: const Border(
                        bottom:BorderSide(color: Color.fromARGB(255, 39, 39, 39), width: 2.0), 
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Center(
                    child: Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
            ),

             
             
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 240, 240), 
                border: const Border(
                  bottom: BorderSide(
                    width: 1.0, 
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20.0), 
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Account Balance",
                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 39, 39, 39)),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isEditingBalance
                            ? SizedBox(
                                width: 120, 
                                child: TextFormField(
                                  controller: balanceController,
                                  style: const TextStyle(
                                    fontSize: 26.0,             
                                    color: Color.fromARGB(255, 89, 89, 89),
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 89, 89, 89),
                                      ), 
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      isEditingBalance = false;
                                      _updateBalance();
                                    });
                                  },
                                ),
                              )
                            : Text(
                                "\$${accountBalance.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Color.fromARGB(255, 89, 89, 89),
                                ),
                              ),
                        const SizedBox(width: 8.0), 
                        IconButton(
                          icon: Icon(
                            isEditingBalance ? Icons.check : Icons.edit,
                            color: Color.fromARGB(255, 89, 89, 89),
                          ),
                          onPressed: () {
                            if (isEditingBalance) {
                              _updateBalance();
                            }
                            setState(() {
                              isEditingBalance = !isEditingBalance;
                            });
                          },
                        ),
                      ],
                    ),
                     const SizedBox(height: 2.0),
                  ],
                ),
              ),
            ),


          const SizedBox(height: 30.0),

                
          const Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
          
          
           const SizedBox(height: 30.0),


  Column(
    children: [

      if (transactionItems.isEmpty) 
        const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "You haven't inputted any transactions yet.",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),


      if (transactionItems.isNotEmpty)
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Color.fromARGB(255, 28, 28, 28), width: 1.0),
            ),
          ),
        ),
      



     ListView.builder(
          shrinkWrap: true,
          itemCount: transactionItems.length + (_isAddingNew ? 1 : 0), 
          itemBuilder: (context, index) {

            if (index == transactionItems.length && _isAddingNew) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0),
                    
                    _buildStyledTextField(descriptionController, 'Description of Transaction'),
                    SizedBox(height: 16), 
                    _buildStyledTextField(dateController, 'Date (in mm/dd/yy format)'),
                    SizedBox(height: 16),
                    _buildStyledTextField(categoryController, 'Category (food, rent, gas, transportation, etc)'),
                    SizedBox(height: 16), 
                    _buildStyledTextField(costController, 'Cost', keyboardType: TextInputType.number),


                    SizedBox(height: 16),


                    Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                try {
                                  DateFormat format = DateFormat('MM/dd/yy');
                                  DateTime parsedDate = format.parse(dateController.text);

                                  if (!isValidDate(parsedDate)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please enter a valid date in MM/dd/yy format.')),
                                    );
                                  } else {
                                    selectedDate = parsedDate;
                                    _addTransaction();
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please enter a valid date in MM/dd/yy format.')),
                                  );
                                }
                              },

                                style: ElevatedButton.styleFrom(
                                          foregroundColor: Color.fromARGB(255, 39, 39, 39),
                                          backgroundColor: const Color.fromARGB(255, 212, 223, 209),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: const BorderSide(
                                              color: Colors.black, 
                                              width: 1.20, 
                                            ),
                                          ),
                                          minimumSize: const Size(70, 50), 
                                          
                                          textStyle: TextStyle(fontSize: 18),
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        ),


                              child: Text('Add Transaction'),
                            ),

                            SizedBox(width: 20),

                            ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            dateController.clear();
                                            descriptionController.clear();
                                            categoryController.clear();
                                            costController.clear();
                                            _isAddingNew = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 226, 228, 224),
                                          foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                            side: const BorderSide(
                                              color: Colors.black, 
                                              width: 1.20, 
                                            ),
                                          ),
                                          minimumSize: const Size(70, 50), 
                                          
                                          textStyle: TextStyle(fontSize: 18),
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        ),
                                        child: Text('Cancel'),
                                      ),
                                  ],
                            ),


                  ],
                ),
              );
            }


            int adjustedIndex = _isAddingNew && index == transactionItems.length ? -1 : index;

            if (adjustedIndex >= transactionItems.length || adjustedIndex < 0) {
              return SizedBox.shrink(); //return empty widget if index is out of bounds
            }

            final item = transactionItems[adjustedIndex];

            DateTime originalDate = item.date;

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border(
                  bottom: BorderSide(color: Color.fromARGB(255, 28, 28, 28), width: 1.0),
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: item.date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (newDate != null) {
                          setState(() {
                            item.date = newDate;
                          });
                        }
                      },
                      child: Text(
                        '${item.date.toLocal()}'.split(' ')[0],
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 111, 135, 112),
                        ),
                      ),
                    ),

                    
                    Text('${item.description}', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,)),
                    const SizedBox(height: 8),

                    RichText(
                      text: TextSpan(
                        text: "Category: ",
                        style: TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 94, 94, 94),
                        ),
                        children: [
                          TextSpan(
                            text: "${item.category}",
                            style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal, color: const Color.fromARGB(255, 94, 94, 94),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Cost: ",
                        style: TextStyle(
                          fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 94, 94, 94),
                        ),
                        children: [
                          TextSpan(
                            text: "\$${item.cost.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.normal, color: const Color.fromARGB(255, 94, 94, 94),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Edit Transaction'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  
                                  TextField(
                                    controller: TextEditingController(text: item.description),
                                    decoration: InputDecoration(
                                      hintText: 'Description', 
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(width: 1.5), 
                                        ),
                                      ),
                                    onChanged: (value) {
                                      item.description = value;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: TextEditingController(text: DateFormat('MM/dd/yy').format(item.date)),
                                    decoration: InputDecoration(
                                      hintText: 'Date (MM/dd/yy)', 
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(width: 1.5), 
                                        ),
                                      ),
                                    onChanged: (value) {
                                      try {
                                        DateFormat format = DateFormat('MM/dd/yy');
                                        DateTime newDate = format.parse(value);

                                        if (!isValidDate(newDate)) {
                                          dateError = true;
                                        } else {
                                          item.date = newDate;
                                          dateError = false;
                                        }
                                      } catch (e) {
                                        dateError = true;
                                      }
                                    },
                                  ),
                                   const SizedBox(height: 10),
                                  TextField(
                                    controller: TextEditingController(text: item.category),
                                    decoration: InputDecoration(
                                      hintText: 'Category',
                                       floatingLabelBehavior: FloatingLabelBehavior.never,
                                       focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(width: 1.5), 
                                        ),
                                      ),
                                    onChanged: (value) {
                                      item.category = value;
                                    },
                                  ),
                                   const SizedBox(height: 10),
                                  TextField(
                                    controller: TextEditingController(text: item.cost.toString()),
                                    decoration: InputDecoration(
                                      hintText: 'Cost', 
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(width: 1.5), 
                                        ),
                                      ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      item.cost = double.tryParse(value) ?? item.cost;
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (dateError) {
                                        item.date = originalDate;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Invalid date format. Use MM/dd/yy.')),
                                        );
                                      } else {
                                        _updateTransaction(item);
                                      }
                                    });
                                    Navigator.of(context).pop();
                                    dateError = false;
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black, 
                                  ),
                                  child: Text('Save'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black, 
                                  ),
                                  child: Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTransaction(item.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        )

      ],
    ),


     const SizedBox(height: 16),


     if (! _isAddingNew)
            Padding(
              padding: const EdgeInsets.all(16.0),

              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAddingNew = true;
                  });
                },

                style: ElevatedButton.styleFrom(
                      elevation: 2.5,
                      foregroundColor: Color.fromARGB(255, 39, 39, 39),
                      backgroundColor: const Color.fromARGB(255, 180, 194, 176), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: Colors.black, 
                          width: 1.80, 
                        ),
                      ),
                      minimumSize: const Size(120, 50), 
                      
                      textStyle: TextStyle(fontSize: 18),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),

                  ),


                child: Text('Add New Transaction'),
              ),

            ), 
         
            const SizedBox(height: 16),

        ],   
      ),
    );
  }
}



class TransactionItem {
  String id;
  String description;
  String category;
  double cost;
  DateTime date;

  TransactionItem({
    required this.id,
    required this.description,
    required this.category,
    required this.cost,
    required this.date,
  });

  factory TransactionItem.fromFirestore(String id, Map<String, dynamic> data) {
    return TransactionItem(
      id: id,
      description: data['description'] as String,
      category: data['category'] as String,
      cost: (data['cost'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'category': category,
      'cost': cost,
      'date': Timestamp.fromDate(date),
    };
  }
}


















