import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {

    
  String _email = '';
  String _phone = '';


  final newController = TextEditingController();
  final oldController = TextEditingController();

  final emailController = TextEditingController();
  final phoneController = TextEditingController();


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
     _fetchUserInfo();

  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }



   bool _isValidPassword(String password) {
    return password.length >= 6;
  }


  void _changePassword() async {
  final user = _auth.currentUser;

  if (user == null) {
    _showErrorDialog("No user is currently signed in.");
    return;
  }

  final currentPassword = oldController.text.trim();
  final newPassword = newController.text.trim();

  if (!_isValidPassword(newPassword)) {
    _showErrorDialog("The new password must be at least 6 characters long.");
    return;
  }

  try {
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Password changed successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  } catch (error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'wrong-password':
          _showErrorDialog("The current password you entered is incorrect.");
          break;
        case 'weak-password':
          _showErrorDialog("The new password is too weak.");
          break;
        default:
          _showErrorDialog("An error occurred: ${error.message}");
      }
    } else {
      _showErrorDialog("An unexpected error occurred.");
    }
  }
}

  Future<void> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _email = data['email'] ?? 'user@example.com';
          _phone = data['phone'] ?? '000-000-0000';
        });
      }
    }
  }



    void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }




  Widget _buildStyledTextField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: .5,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        obscureText: true,
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
          fillColor: const Color.fromARGB(255, 246, 246, 246),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [     
            const Padding(
                padding: EdgeInsets.only(top: 34.0), 
                child: Text(
                  'Verification Methods',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold, 
                  ),
                ),
            ),

             const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: Text(
                'You’ll use this if you ever forget your password.  Be sure to remember at least one of these -- you’ll be sent a temporary passcode to one of them, and be asked to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF545B53),
                ),
              ),
            ),


            const SizedBox(height: 30.0),


             Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Email:  ',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                         color: Color(0xFF424F42),
                      ),
                      children: [
                        TextSpan(
                          text: _email,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 133, 138, 130),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                          
            const SizedBox(height: 8.0),

              
            Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Phone Number: ',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                         color: Color(0xFF424F42),
                      ),
                      children: [
                        TextSpan(
                          text: _phone,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 133, 138, 130),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


            const Padding(
              padding: EdgeInsets.only(top: 42.0), 
              child: Text(
                'Choose New Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,),
              child: Text(
                'This is the password you’ll use when logging in.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF545B53),
                ),
              ),
            ),

            const SizedBox(height: 8.0),

             Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStyledTextField(oldController, 'Current Password'),
                    SizedBox(height: 16), 
                    _buildStyledTextField(newController, 'New Password'),
                    SizedBox(height: 30), 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        
                        ElevatedButton(
                          onPressed: _changePassword, 
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
                          child: Text('Change Password'),
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
