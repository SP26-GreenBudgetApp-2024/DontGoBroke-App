import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fl_chart/fl_chart.dart';



class BudgetPage extends StatefulWidget {
  final Function(int) onNavigate;

  const BudgetPage({super.key, required this.onNavigate});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<BudgetItem> budgetItems = [];
  final _categoryController = TextEditingController();
  final _costController = TextEditingController();
  bool _isAddingNew = false;


  List<GoalItem> goalItems = [];
  final _goalController = TextEditingController();
  final _targetController = TextEditingController();
  bool _isAddingNewGoal = false;


  @override
  void initState() {
    super.initState();

    _loadBudgetItemsFromFirebase().then((loadedItems) {
      setState(() {
        budgetItems = loadedItems;
      });
    });

    _loadGoalItemsFromFirebase().then((loadedGoalItems) {
      setState(() {
        goalItems = loadedGoalItems;
      });
    });
  }



 void _addBudgetItem() {
  final newItem = BudgetItem(
    category: _categoryController.text,
    cost: double.tryParse(_costController.text) ?? 0,
    id: getCurrentUserId(),
  );
  
  setState(() {
    budgetItems.add(newItem);

    _addBudgetItemToFirebase(newItem);
    
    _categoryController.clear();
    _costController.clear();
    _isAddingNew = false;
  });
}



  void _toggleAddNew() {
    setState(() {
      _isAddingNew = !_isAddingNew;
    });
  }




  double _getTotalCost() {
    final totalCost = budgetItems.fold(0.0, (sum, item) => sum + item.cost);
    return totalCost;
  }

  Map<String, double> _getCategoryTotals() {
    final Map<String, double> categoryTotals = {};
    for (final item in budgetItems) {
      categoryTotals[item.category] =
          (categoryTotals[item.category] ?? 0) + item.cost;
    }
    return categoryTotals;
  }

  


 List<PieChartSectionData> _getPieChartSections() {
  final categoryTotals = _getCategoryTotals();
  final totalCost = categoryTotals.values.fold(0.0, (sum, cost) => sum + cost);

  return categoryTotals.entries
      .map((entry) {
        final percentage = (entry.value / totalCost) * 100;
        final sectionColor = Colors.primaries[categoryTotals.keys.toList().indexOf(entry.key) % Colors.primaries.length];
        
        bool showPercentage = percentage > 4;

        return PieChartSectionData(
          value: entry.value,
          color: sectionColor,
          title: '',
          radius: 50,
          showTitle: false,  
          badgeWidget: showPercentage 
              ? Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: sectionColor, 
                    fontSize: 16,  
                    fontWeight: FontWeight.bold,
                  ),
                )
              : SizedBox.shrink(), 
          badgePositionPercentageOffset: 1.8,
        );
      })
      .toList();
}


  Widget _buildPieChart() {
    if (budgetItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "You haven't inputted anything for your budget yet.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: PieChart(
        PieChartData(
          sections: _getPieChartSections(),
          centerSpaceRadius: 30,
          sectionsSpace: 2,
        ),
      ),
    );
  }


Widget _buildLegend() {
  final categoryTotals = _getCategoryTotals();
  final legendItems = categoryTotals.entries
      .map((entry) {
        final sectionColor = Colors.primaries[categoryTotals.keys.toList().indexOf(entry.key) % Colors.primaries.length];
        return Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: sectionColor,  
                border: Border.all(
                  color: const Color.fromARGB(255, 39, 39, 39), 
                  width: 1.5,  
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(entry.key, style: const TextStyle(fontSize: 16)),
          ],
        );
      })
      .toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: legendItems,
  );
}



void _addGoalItem() {
  final newGoal = GoalItem(
    name: _goalController.text,
    target: double.tryParse(_targetController.text) ?? 0,  
    id:  getCurrentUserId(),
  );
  
  setState(() {
    goalItems.add(newGoal);

    _addGoalItemToFirebase(newGoal);
    
    _goalController.clear();
    _targetController.clear();
    _isAddingNewGoal = false;
  });
}



void _toggleAddGoal() {
  setState(() {
    _isAddingNewGoal = !_isAddingNewGoal;
  });
}



void _editBudgetItem(BuildContext context, BudgetItem item) {
  final TextEditingController categoryController = TextEditingController(text: item.category);
  final TextEditingController costController = TextEditingController(text: item.cost.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Budget Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                  hintText: 'Category', 
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(width: 1.5), 
                  ),
                ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: costController,
              decoration: InputDecoration(
                  hintText: 'Cost', 
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(width: 1.5), 
                  ),
                ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                item.category = categoryController.text;
                item.cost = double.tryParse(costController.text) ?? item.cost;
              });

              _updateBudgetItemInFirebase(item);

              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}



void _editGoalItem(BuildContext context, GoalItem item) {
  final TextEditingController goalController = TextEditingController(text: item.name);
  final TextEditingController targetController = TextEditingController(text: item.target.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Goal Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: goalController,
              decoration: InputDecoration(
                  hintText: 'Goal', 
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(width: 1.5), 
                  ),
                ),
            ),
       
            const SizedBox(height: 10),

            TextField(
              controller: targetController,
              decoration: InputDecoration(
                  hintText: 'Cost', 
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(width: 1.5), 
                  ),
                ),
            ),

          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {

                item.name = goalController.text;
                item.target = double.tryParse(targetController.text) ?? item.target;
              });


              _updateGoalItemInFirebase(item);


              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}


String getCurrentUserId() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid; 
  } else {
    throw Exception('User is not signed in');
  }
}


Future<void> _addBudgetItemToFirebase(BudgetItem item) async {
  final userId = getCurrentUserId();
  try {


    final budgetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budget');


    final newDocRef = budgetRef.doc();


    await newDocRef.set({
      'category': item.category,
      'cost': item.cost,
    });


    item.id = newDocRef.id;
  } catch (e) {
    print("Error adding budget item: $e");
    
  }
}



Future<void> _addGoalItemToFirebase(GoalItem item) async {
  final userId = getCurrentUserId();
  try {
    final goalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals');


    final newDocRef = goalRef.doc();


    await newDocRef.set({
      'name': item.name,
      'target': item.target,
    });

    item.id = newDocRef.id;

  
  } catch (e) {
    print("Error adding goal item: $e");
  }
}


Future<List<BudgetItem>> _loadBudgetItemsFromFirebase() async {
   final userId = getCurrentUserId();
  try {
    final budgetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budget');

    final querySnapshot = await budgetRef.get();

    return querySnapshot.docs.map((doc) {
      return BudgetItem.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print("Error fetching budget items: $e");
    return [];
  }
}

Future<List<GoalItem>> _loadGoalItemsFromFirebase() async {
  final userId = getCurrentUserId();
  try {
    final goalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals');

    final querySnapshot = await goalRef.get();

    return querySnapshot.docs.map((doc) {
      return GoalItem(
        id: doc.id, 
        name: doc['name'],
        target: doc['target'],
      );
    }).toList();
  } catch (e) {
    print("Error loading goal items: $e");
    return [];
  }
}




 Future<void> _updateBudgetItemInFirebase(BudgetItem item) async {
  final userId = getCurrentUserId(); 
  try {
    final budgetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budget');
         budgetRef.doc(item.id);

    await budgetRef.doc(item.id).update({
      'category': item.category,
      'cost': item.cost,
    });
  } catch (e) {
    print("Error updating budget item: $e");
    
  }
}



Future<void> _updateGoalItemInFirebase(GoalItem item) async {
  final userId = getCurrentUserId(); 
  try {
    final goalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals');
        goalRef.doc(item.id);
    

    await goalRef.doc(item.id).update({
      'name': item.name,
      'target': item.target,
    });



  } catch (e) {
    print("Error updating goal item: $e");
  }
}




Future<void> _deleteBudgetItemFromFirebase(BudgetItem item) async {
  final userId = getCurrentUserId(); 
  try {
    final budgetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budget');

    await budgetRef.doc(item.id).delete();


  } catch (e) {
    print("Error deleting goal item: $e");
  }
}





Future<void> _deleteGoalItemFromFirebase(GoalItem item) async {
  final userId = getCurrentUserId(); 
  try {
    final goalRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals');

    await goalRef.doc(item.id).delete();

  

  } catch (e) {
    print("Error deleting goal item: $e");
  }
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
                      'Monthly Expenses',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
            ),


          const SizedBox(height: 88),

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2, 
                  child: _buildPieChart(),
                ),
                const SizedBox(width: 10), 
                Flexible(
                  flex: 1, 
                  child: _buildLegend(),
                ),
              ],
            ),
         

          const SizedBox(height: 105),

          
          if (budgetItems.isNotEmpty)
              Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Total Expense Amount: ',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 41, 41, 41),
                        fontWeight: FontWeight.bold,
                        fontSize: 18, 
                      ),
                      children: [
                        TextSpan(
                          text: " \$${_getTotalCost().toStringAsFixed(2)}",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 111, 121, 106),
                            fontSize: 18, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


          const SizedBox(height: 16),       
          
          ListView.builder(
            shrinkWrap: true, 
            itemCount: budgetItems.isEmpty ? 0 : budgetItems.length + 1, 
            itemBuilder: (context, index) {
              if (index == 0 && budgetItems.isNotEmpty) {
                return Container(
                  decoration: BoxDecoration(
                    border: const Border(
                      bottom: BorderSide(color: Color.fromARGB(255, 28, 28, 28), width: 1.2),
                    ),
                  ),
                );
              }
              
              final item = budgetItems[index - 1]; 

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], 
                  border: const Border(
                    bottom: BorderSide(color: Color.fromARGB(255, 28, 28, 28), width: 1.0),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10), 
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.category}', style: TextStyle(fontSize: 18)),
                      Text('\$${item.cost.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editBudgetItem(context, item);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteBudgetItemFromFirebase(item);

                           setState(() {
                              budgetItems.removeAt(index - 1); 
                            });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),


          if (budgetItems.isNotEmpty)
            SizedBox(height: 16), 

          if (!_isAddingNew)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _toggleAddNew,
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
                child: Text("Add New Monthly Expense"),
              ),
            ),


          if (_isAddingNew)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStyledTextField(_categoryController, 'Category'),
                  SizedBox(height: 16), 
                  _buildStyledTextField(_costController, 'Cost', keyboardType: TextInputType.number),
                  SizedBox(height: 16), 
                   
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _addBudgetItem,
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
                        child: Text('Add Item'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _categoryController.clear();
                            _costController.clear();
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
       
            ),


            const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB7B9B7),
                border: const Border(
                  top: BorderSide(color: Color.fromARGB(255, 39, 39, 39), width: 2.0),
                  bottom: BorderSide(color: Color.fromARGB(255, 39, 39, 39), width: 1.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: const Center(
                child: Text(
                  'Goals',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 39, 39, 39),  
                  ),
                ),
              ),
            ),

            if (goalItems.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "You haven't inputted any goals yet.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
    

            ListView.builder(
              shrinkWrap: true, 
              itemCount: goalItems.isEmpty ? 0 : goalItems.length + 1,
              itemBuilder: (context, index) {
                 if (index == 0 && goalItems.isNotEmpty) {
                    return Container(
                      decoration: BoxDecoration(
                        border: const Border(
                          bottom: BorderSide(color: Color.fromARGB(255, 28, 28, 28), width: 1.2),
                        ),
                      ),
                    );
                  }
                  
                final goalItem = goalItems[index - 1]; 


                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], 
                    border: const Border(
                      bottom: BorderSide(color: Color.fromARGB(255, 28, 28, 28), width: 1.0),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10), 
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(goalItem.name, style: TextStyle(fontSize: 18)),
                        Text('\$${goalItem.target.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editGoalItem(context, goalItem);
                          }, 
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteGoalItemFromFirebase(goalItem);
                            setState(() {
                              goalItems.removeAt(index -1); 
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),


           const SizedBox(height: 16),

            
            if (!_isAddingNewGoal)        
              Padding(
                padding: const EdgeInsets.all(16.0),
     
                child: ElevatedButton(
                  onPressed: _toggleAddGoal,
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
                  child: Text("Add New Goal"),
                ),
              ),

             const SizedBox(height: 16),


            if (_isAddingNewGoal) 
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStyledTextField(_goalController, 'Goal Name'),
                    SizedBox(height: 16), 
                    _buildStyledTextField(_targetController, 'Target Amount', keyboardType: TextInputType.number),
                    SizedBox(height: 16), 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _addGoalItem,
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
                          child: Text('Add Goal'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _goalController.clear();
                              _targetController.clear();
                              _isAddingNewGoal = false;
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
              ),


        ],
        
      ),
      
    );
  }
}

class BudgetItem {
  String id; 
  String category;
  double cost;

  BudgetItem({
    required this.id, 
    required this.category,
    required this.cost,
  });


  factory BudgetItem.fromFirestore(String id, Map<String, dynamic> data) {
    return BudgetItem(
      id: id,
      category: data['category'] as String,
      cost: (data['cost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'cost': cost,
    };
  }
}



class GoalItem {
  String id; 
  String name;
  double target;

  GoalItem({
    required this.id, 
    required this.name,
    required this.target,
  });


  factory GoalItem.fromFirestore(String id, Map<String, dynamic> data) {
    return GoalItem(
      id: id,
      name: data['name'] as String,
      target: (data['target'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'target': target,
    };
  }
}
