
import 'package:dbg_loginpage/components/my_button.dart';
import 'package:dbg_loginpage/components/my_textfeild.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
      LoginPage({super.key});

  //text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in user method


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const SizedBox(height: 50),


        //logo
    const Icon(Icons.currency_exchange, size: 100,),//icon

    const SizedBox(height: 50),


        //welcome back text
    Text('Welcome Back!',
        style: TextStyle(color: Colors.green[900],
    fontSize: 16,
    ),
    ),

        const SizedBox(height: 25),


        //username text field
            MyTextFeild(
              controller: usernameController,
              hintText:  'Username',
              obscureText: false,
            ),
            const SizedBox(height: 10),


          //password text field
            MyTextFeild(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

          // forgot password?
            const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Forgot Password?',
                style: TextStyle(color: Colors.grey.shade600)
                ),
              ],
            ),
          ),


          //sign in button
            MyButton()

            const SizedBox(height: 50),

          //Don't have an account? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text('Dont have an acount?', style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(width: 4),
              const Text('Register now',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold
              )
              ),
            ])
          ],
        ),
       ),
      ),
    );
  }
}

