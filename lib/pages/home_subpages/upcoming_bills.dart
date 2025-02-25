import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpcomingBillsPage extends StatefulWidget {
  const UpcomingBillsPage({Key? key}) : super(key: key);

  @override
  _UpcomingBillsPageState createState() => _UpcomingBillsPageState();
}

class _UpcomingBillsPageState extends State<UpcomingBillsPage> {

  List<BillItem> billItems = [];
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  bool _isAddingNew = false;


   @override
  void initState() {
    super.initState();

    _loadBillItemsFromFirebase().then((loadedItems) {
      setState(() {
        billItems = loadedItems;
      });
    });

  }


  void _addBillItem() {
    final newItem = BillItem(
      category: _categoryController.text,
      date: _dateController.text,
      id: getCurrentUserId(),
    );
    
    setState(() {
      billItems.add(newItem);

      _addBillItemToFirebase(newItem);
      
      _categoryController.clear();
      _dateController.clear();
      _isAddingNew = false;
    });
}


  void _toggleAddNew() {
    setState(() {
      _isAddingNew = !_isAddingNew;
    });
  }



  void _editBillItem(BuildContext context, BillItem item) {
    final TextEditingController categoryController = TextEditingController(text: item.category);
    final TextEditingController dateController = TextEditingController(text: item.date.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Bill Item'),
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
                controller: dateController,
                decoration: InputDecoration(
                    hintText: 'Date', 
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
                  item.date = dateController.text;
                });

                _updateBillItemInFirebase(item);

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


Future<void> _addBillItemToFirebase(BillItem item) async {
  final userId = getCurrentUserId();
  try {
    final billRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bills');

    final newDocRef = billRef.doc();

    await newDocRef.set({
      'category': item.category,
      'date': item.date,
    });


    item.id = newDocRef.id;
  } catch (e) {
    print("Error adding bill item: $e");
    
  }
}


Future<List<BillItem>> _loadBillItemsFromFirebase() async {
   final userId = getCurrentUserId();
  try {
    final billRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bills');

    final querySnapshot = await billRef.get();

    return querySnapshot.docs.map((doc) {
      return BillItem.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print("Error fetching bill items: $e");
    return [];
  }
}



 Future<void> _updateBillItemInFirebase(BillItem item) async {
  final userId = getCurrentUserId(); 
  try {
    final billRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bills');
         billRef.doc(item.id);

    await billRef.doc(item.id).update({
      'category': item.category,
      'date': item.date,
    });
  } catch (e) {
    print("Error updating bill item: $e");
    
  }
}



Future<void> _deleteBillItemFromFirebase(BillItem item) async {
  final userId = getCurrentUserId(); 
  try {
    final billRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bills');

    await billRef.doc(item.id).delete();

    print("Bill item deleted from Firebase: ${item.id}");

  } catch (e) {
    print("Error deleting bill item: $e");
  }
}


  Widget _buildStyledTextField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
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
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.4,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Bills"),
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
      body: SingleChildScrollView(
        child: Column(       
          children: [     

          Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 129, 129, 129),
                    border: const Border(
                        bottom:BorderSide(color: Color(0xFF2D372D), width: 2.0), 
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: const Center(
                    child: Text(
                      'Upcoming Bills',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color.fromARGB(255, 39, 39, 39),
                      ),
                    ),
                  ),
            ),


  
          if (billItems.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 180.0, left: 16.0, right: 16.0, bottom: 18.0,), 
              child: Text(
                "This is meant to serve as a reminder to you as to when you have certain bills due. To start, just input a bill you may have due soon.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              
            ),
          

        if (billItems.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC1C1C1),
              border: const Border(
                bottom: BorderSide(color: Color(0xFF2D372D), width: 2.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0), 
                  child: Text(
                    'Type of Bill',
                    style: TextStyle(fontSize: 22, color: Color.fromARGB(255, 39, 39, 39)),
                  ),
                ),


                const Padding(
                  padding: EdgeInsets.only(right: 110.0), 
                  child: Text(
                    'Date Due',
                    style: TextStyle(fontSize: 22,  color: Color.fromARGB(255, 39, 39, 39)),
                  ),
                ),
              ],
            ),
          ),


           
          ListView.builder(
            shrinkWrap: true, 
            itemCount: billItems.isEmpty ? 0 : billItems.length,
            itemBuilder: (context, index) {

              final item = billItems[index]; 

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], 
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFF2D372D), width: 1.0),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10), 
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [          
                     
                      Padding(
                        padding: EdgeInsets.only(left: 12.0), 
                        child: Text(
                          '${item.category}',
                          style: TextStyle(fontSize: 20,  color: Color.fromARGB(255, 39, 39, 39)),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          '${item.date}', 
                          style: TextStyle(fontSize: 20,  color: Color.fromARGB(255, 39, 39, 39)),
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
                          _editBillItem(context, item);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteBillItemFromFirebase(item);

                           setState(() {
                              billItems.removeAt(index); 
                            });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),


          if (billItems.isNotEmpty)
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
                  minimumSize: const Size(180, 60),
                  textStyle: const TextStyle(
                  fontSize: 20, 

                  ),
                ),

                child: Text("Add New Bill"),
              ),
            ),


          if (_isAddingNew)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStyledTextField(_categoryController, 'Category'),
                  SizedBox(height: 16), 
                  _buildStyledTextField(_dateController, 'Date'),
                  SizedBox(height: 36), 

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _addBillItem,
                        style: ElevatedButton.styleFrom(
                          elevation: 2.5,
                          foregroundColor: Color.fromARGB(255, 39, 39, 39),
                          backgroundColor: const Color.fromARGB(255, 180, 194, 176), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(
                              color: Colors.black, 
                              width: 1.20, 
                            ),
                          ),
                          minimumSize: const Size(160, 70), 
                          textStyle: const TextStyle(
                            fontSize: 20, 
                           ),
                        ),
                        child: Text('Add Item'),
                      ),


                      SizedBox(width: 30),


                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _categoryController.clear();
                            _dateController.clear();
                            _isAddingNew = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 2.5,
                          foregroundColor: Color.fromARGB(255, 39, 39, 39),
                          backgroundColor: const Color.fromARGB(255, 210, 211, 210), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(
                              color: Colors.black, 
                              width: 1.20, 
                            ),
                          ),
                          minimumSize: const Size(160, 70), 
                          textStyle: const TextStyle(
                            fontSize: 20,
                           ),

                        ),
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],         
              ),
       
            ),

          ]
          
        ),
        
      ),    
    );
  }
}



class BillItem {
  String id; 
  String category;
  String date;

  BillItem({
    required this.id, 
    required this.category,
    required this.date,
  });

  factory BillItem.fromFirestore(String id, Map<String, dynamic> data) {
    return BillItem(
      id: id,
      category: data['category'] as String,
      date: data['date'] as String,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'date': date,
    };
  }
}