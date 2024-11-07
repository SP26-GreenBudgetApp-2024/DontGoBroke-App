import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class CreateUsers extends StatefulWidget {
  const CreateUsers({super.key});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUsers> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore

  String? errorMessage; // Variable to store the error message

  // Function to show an AlertDialog with detailed user data
  void _showUserDataDialog(Map<String, dynamic>? userData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("User Data"),
        content: Text("User information: ${userData.toString()}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Function to read user data from Firestore
  void _getUserData(String userId) async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();

    if (snapshot.exists) {
      _showUserDataDialog(snapshot.data() as Map<String, dynamic>?); // Show data in a dialog
    } else {
      setState(() {
        errorMessage = "No user data found for this ID."; // Update the error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            
            // Display error message if present
            if (errorMessage != null) 
              Text(
                errorMessage!,
                style: const TextStyle(color: Color.fromARGB(255, 107, 47, 43)), 
                textAlign: TextAlign.center, 
              ),

            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                setState(() {
                  errorMessage = null; // Clear any previous error message
                });

                if (password == confirmPassword) {
                  try {
                    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Store user information in Firestore
                    await _firestore.collection('users').doc(userCredential.user?.uid).set({
                      'email': email,
                      'createdAt': Timestamp.now(),
                      // Add other user information here if needed
                    }).then((_) {
                      _getUserData(userCredential.user!.uid); // Retrieve and show user data
                    }).catchError((error) {
                      setState(() {
                        errorMessage = "Failed to save user information: $error"; // Show Firestore error
                      });
                    });

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      if (e.code == 'weak-password') {
                        errorMessage = 'The password provided is too weak. Try again.';
                      } else if (e.code == 'email-already-in-use') {
                        errorMessage = 'The account already exists for that email. Try again.';
                      } else if (e.code == 'invalid-email') {
                        errorMessage = 'The email address is not valid. Try again.';
                      } else {
                        errorMessage = 'Error: ${e.message} Try again.';
                      }
                    });
                  }
                } else {
                  setState(() {
                    errorMessage = "Passwords do not match. Try again.";
                  });
                }
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
