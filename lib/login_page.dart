import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'create_user.dart';
import 'main.dart';

// A StatefulWidget that represents the sign-in page.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth

  String? errorMessage; // Variable to store error messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sets the background color to white.
      appBar: AppBar(
        title: const Text("Sign In"), // Sets the title of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Email", // Changed to Email
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
            
            // Display error message if present
            if (errorMessage != null) 
              Text(
                errorMessage!,
                style: const TextStyle(color: Color.fromARGB(255, 107, 47, 43)), // Make the text red
                textAlign: TextAlign.center, // Center the text
              ),

            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Handle sign-in logic here
                String email = usernameController.text.trim(); // Use email instead of username
                String password = passwordController.text;

                setState(() {
                  errorMessage = null; // Clear any previous error message
                });

                try {
                  await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // User signed in successfully
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                } on FirebaseAuthException catch (e) {
                  // Handle sign-in errors
                  setState(() {
                      errorMessage = 'The credential(s) you inputted are either incorrect, or have expired. Try again.';
                    
                  });
                }
              },
              child: const Text("Sign In"),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Navigate to Create User Account page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateUsers()));
              },
              child: const Text("Create User Account"),
            ),
          ],
        ),
      ),
    );
  }
}
