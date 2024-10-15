import 'package:flutter/material.dart';
import 'create_user.dart';
import 'main_page.dart';

// A StatefulWidget that represents the sign-in page.
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,// Sets the background color to white.
      appBar: AppBar(
        title: const Text("Sign In"),// Sets the title of the app bar
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
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
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
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Handle sign-in logic here
                String username = usernameController.text;
                String password = passwordController.text;
                print("Sign in with username: $username and password: $password");

                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),),
                );
              },
              child: const Text("Sign In"),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Navigate to Create User Account page
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateUsers(),
                ),);

              },
              child: const Text("Create User Account"),
            ),
          ],
        ),
      ),
    );
  }
}