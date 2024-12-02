import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reset_password.dart'; 
import '../login_page.dart';

class VerificationCodePage extends StatefulWidget {
  final String? email;
  final String? verificationId;
  final bool isEmail; //determine if email or phone verification-- code gives user option for either/or

  VerificationCodePage({
    this.email,
    this.verificationId,
    required this.isEmail,
  });

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final TextEditingController _codeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

 
  void _verifyCode() async {
    if (widget.isEmail) {
      String oobCode = _codeController.text.trim();

      if (oobCode.isNotEmpty) {
        try {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(oobCode: oobCode),
            ),
          );
        } catch (e) {
          _showErrorDialog("Invalid code. Please try again. Error: ${e.toString()}");
        }
      } else {
        _showErrorDialog("Please enter the verification code.");
      }
    } else {
      try {
        String smsCode = _codeController.text.trim(); 

        if (smsCode.isNotEmpty) {
          final PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: widget.verificationId!, 
            smsCode: smsCode, 
          );

          await _auth.signInWithCredential(credential);
          _showSuccessDialog("Phone number verified successfully.");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(),
            ),
          );
        } else {
          _showErrorDialog("Please enter the verification code.");
        }
      } catch (e) {
        _showErrorDialog("Invalid code. Please try again. Error: ${e.toString()}");
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
                    "Verification code sent!",
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
                    "Please input it below.",
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
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: 'Verification Code',
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
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 21),
                  ),
                ),

                const SizedBox(height: 35),
        
                Center(
                  child: ElevatedButton(
                    onPressed: _verifyCode,
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
                      'Verify Code',
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
