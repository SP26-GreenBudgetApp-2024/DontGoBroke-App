import 'package:flutter/material.dart';



class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Budget Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Picture and Name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage('assets/profile_picture.png'), // Replace with actual profile picture
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        // Handle profile picture change
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "User Name",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // User Information
            const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("User Name"),
                subtitle: Text("user@example.com"),
              ),
            ),
            const SizedBox(height: 16.0),

            // Settings Toolbar
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Password & Recovery"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle password and recovery settings
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Data Privacy"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle data privacy settings
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text("FAQ"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle FAQ section
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text("Contact Support"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Handle contact support
              },
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Overview',
          ),
        ],
        onTap: (int index) {
          // Handle bottom navigation bar taps
          switch (index) {
            case 0:
              print("Home tapped");
              break;
            case 1:
              print("Transactions tapped");
              break;
            case 2:
              print("Budget tapped");
              break;
            case 3:
              print("Overview tapped");
              break;
          }
        },
      ),
    );
  }
}