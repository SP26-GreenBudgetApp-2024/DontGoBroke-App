import 'package:dontgobroke/forgot_password_pages/verification_code.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? _verificationId;
  final TextEditingController _inputController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isValidEmail(String email) {
    String pattern = r'^[^@]+@[^@]+\.[^@]+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    String pattern = r'^\+?[1-9]\d{1,14}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(phone);
  }


  void _sendVerificationCode() async {
    String input = _inputController.text.trim();

    if (_isValidEmail(input)) {
      try {
        await _auth.sendPasswordResetEmail(email: input);
        _showSuccessDialog("A password reset link has been sent to your email.");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodePage(
              email: input,
              isEmail: true,
            ),
          ),
        );
      } catch (e) {
        _showErrorDialog("An error occurred: ${e.toString()}");
      }
    } else if (_isValidPhoneNumber(input)) {
      //assumes US phone numbers -- edit to make more applicable to phone numbers across globe
      if (!input.startsWith('+')) {
        input = '+1' + input;
      }

      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: input,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            _showSuccessDialog("Phone number automatically verified and signed in.");
          },
          verificationFailed: (FirebaseAuthException e) {
            _showErrorDialog("Phone verification failed:${e.code} - ${e.message}");
          },
          codeSent: (String verificationId, int? resendToken) {
            _showSuccessDialog("A verification code has been sent to your phone.");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationCodePage(
                  verificationId: verificationId,
                  isEmail: false,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("Auto-retrieval timeout for verification ID: $verificationId");
            _verificationId = verificationId;
          },
        );
      } catch (e) {
        _showErrorDialog("An error occurred: ${e.toString()}");
      }
    } else {
      _showErrorDialog("Please enter a valid email or phone number.");
    }
  }





  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); 
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, 
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
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

                  const SizedBox(height: 100.0),

                  Center(
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3E3F3D),
                      ),
                    ),
                  ),


                  const SizedBox(height: 12),

                  Center(
                    child: Text(
                      "No problem!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF535E4F),
                      ),
                    ),
                  ),


                  const SizedBox(height: 25),
                
                  Center(
                    child: Text(
                      "To reset your password, just input the email or phone number you used to create your account. A verification code will then be sent to you.",
                      style: TextStyle(
                        fontSize: 21,

                        color: const Color(0xFF4A514D),
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
                      controller: _inputController,
                      decoration: InputDecoration(
                        labelText: 'Enter your email or phone number',
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
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 21),
                    ),
                  ),


                  const SizedBox(height: 35),

                  Center(
                    child: ElevatedButton(
                      onPressed: _sendVerificationCode,
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
                        'Submit',
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