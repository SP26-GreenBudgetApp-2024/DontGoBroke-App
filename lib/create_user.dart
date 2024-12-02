import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart'; 

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isValidEmail(String email) {
    String pattern = r'^[^@]+@[^@]+\.[^@]+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  //edit to make more robust later -- secure passwords should have combo of upper/lowercase, numbers and letters, etc 
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  void _signUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty) {
      _showErrorDialog("Please enter your name.");
      return;
    }
    if (!_isValidEmail(email)) {
      _showErrorDialog("Invalid email format. Please enter a valid email.");
      return;
    }
    if (!_isValidPassword(password)) {
      _showErrorDialog(
          "Password must be at least 6 characters long.");
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;

        await _firestore.collection('users').doc(userId).set({
          'name': name,
          'email': email,
          'phone': phone,
          'uid': userId,
          'createdAt': Timestamp.now(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    } catch (e) {
      _showErrorDialog("An error occurred: ${e.toString()}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ Colors.white, const Color(0xFFCAD7C3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        height: double.infinity, 
        child: SingleChildScrollView(
           child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
         
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35, 
                      ),
                      children: [
                        TextSpan(
                          text: "Don't Go Broke!",
                          style: TextStyle(
                            color: const Color(0xFF535E4F),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 35, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 45),


                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'This information will be used for your user profile. ',
                      style: TextStyle(
                        color: const Color(0xFF2B2C2B),
                        fontWeight: FontWeight.bold,
                        fontSize: 18, 
                      ),
                      children: [
                        TextSpan(
                          text:
                              'You’ll use your email to log in, and your phone number for password recovery.',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 22),


                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: const Color.fromARGB(255, 64, 64, 64), fontSize: 21,),
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
                          fillColor: const Color.fromARGB(255, 246, 246, 246),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        style: TextStyle(fontSize: 17), 
                      ),
                 ),

                const SizedBox(height: 22),


               Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 64, 64, 64), fontSize: 21,),
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
                        fillColor: const Color.fromARGB(255, 246, 246, 246),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 17), 
                    ),
                 ),

                const SizedBox(height: 22),


                 Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),

                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 64, 64, 64), fontSize: 22,),
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
                        fillColor: const Color.fromARGB(255, 246, 246, 246),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      style: TextStyle(fontSize: 17), 
                      keyboardType: TextInputType.phone,
                    ),
                ),



                const SizedBox(height: 35),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      text: 'This will be your password. ',
                      style: TextStyle(
                        color: const Color(0xFF2B2C2B),
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text:
                              'Please choose a password that 1) is longer than 6 characters, and 2) not common or easily guessable.',
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                

                
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 64, 64, 64), fontSize: 22,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, width: 0.8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black, width: 1.2),
                        ),
                        fillColor: const Color.fromARGB(255, 246, 246, 246),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      obscureText: true,
                      style: TextStyle(fontSize: 17), 
                    ),
                ),



              const SizedBox(height: 45),
               Center(
                    child: ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        elevation: 2.5,
                        backgroundColor: const Color(0xFF9BB398), 
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.black, 
                          width: 1.5, 
                        ),
                        minimumSize: Size(400, 100), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), 
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                        fontSize: 24,
                         shadows: [
                            Shadow(
                              offset: Offset(1.2, 1.2), 
                              blurRadius: 1.0, 
                              color: Colors.black, 
                            ),
                          ],

                        ),
                      ),
                    ),
                  ),


                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 18,  
                        color: const Color(0xFF2B2C2B),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        'Sign In!',
                        style: TextStyle(
                          color: Color.fromARGB(255, 117, 147, 107),
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromARGB(255, 117, 147, 107), 
                          fontWeight: FontWeight.bold,
                          fontSize: 18,  
                        ),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
