import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? oobCode; // Make oobCode optional

  ResetPasswordPage({Key? key, this.oobCode}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void _resetPassword() async {
  String newPassword = _newPasswordController.text.trim();

  if (newPassword.isNotEmpty) {
    try {
      if (widget.oobCode != null) {
        await _auth.confirmPasswordReset(
          code: widget.oobCode!,
          newPassword: newPassword,
        );
        _showSuccessDialog("Password reset successful!");
      } 

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      _showErrorDialog("Failed to reset password: ${e.toString()}");
    }
  } else {
    _showErrorDialog("Please enter a new password.");
  }
}


  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
             style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
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
            colors: [Colors.white, Color(0xFFCAD7C3)],
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
                const SizedBox(height: 165.0),

                Center(
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
      
                      color: const Color(0xFF3E3F3D),
                    ),
                  ),
                ),


                const SizedBox(height: 12),

                Center(
                  child: Text(
                    "Please input your new password.",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF535E4F),
                    ),
                  ),
                ),


                const SizedBox(height: 25),

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
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 64, 64, 64),
                        fontSize: 21,
                      ),
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
                    style: TextStyle(fontSize: 21),
                  ),
                ),
                const SizedBox(height: 35),
                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      elevation: 2.5,
                      backgroundColor: const Color(0xFF9BB398),
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.black,
                        width: 1.8,
                      ),
                      minimumSize: Size(400, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reset Password',
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

              
              const SizedBox(height: 25),


              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },

                      child: const Text(
                      "Nevermind, take me back",
                      style: TextStyle(
                          color: Color.fromARGB(255, 88, 97, 85),
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromARGB(255, 88, 97, 85),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                      ),
                    ),
                 
                    ),
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
