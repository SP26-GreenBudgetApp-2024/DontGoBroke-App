import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Function(int) onNavigate;
  final int selectedIndex;

  SettingsPage({required this.onNavigate, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 23, 28, 24), // Same color as MainPage header
        iconTheme: const IconThemeData(
          color: Colors.white, // Set back button color to white
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Currency label at top right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Edit Profile button at top left
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                    onPressed: () {
                      // Edit Profile functionality (leave blank for now)
                    },
                    child: const Text('Edit Profile'),
                  ),
                  // Currency label at top right
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Currency: ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold, // Bold label
                            color: Color.fromARGB(255, 18, 17, 17),
                          ),
                        ),
                        const TextSpan(
                          text: 'US Dollar',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal, // Normal weight for value
                            color: Color.fromARGB(255, 18, 17, 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Profile Picture, Name, Email, and Phone Number
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage('images/pfp.png'), // Replace with actual profile picture
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
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Email: ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold, // Bold label
                            color: Color.fromARGB(255, 109, 109, 109),
                          ),
                        ),
                        Text(
                          "user@example.com", // Replace with actual email
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Phone Number: ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold, // Bold label
                            color: Color.fromARGB(255, 109, 109, 109),
                          ),
                        ),
                        Text(
                          "000-000-0000", // Replace with actual phone number
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50.0),

              // Settings heading (Centered)
              Center(
                child: const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Settings Toolbar with light gray background
              Container(
                color: Colors.grey[200], // Light gray background for settings
                child: Column(
                  children: [
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
                      leading: const Icon(Icons.email), // Change to email icon
                      title: const Text("Contact Support"),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Handle contact support
                      },
                    ),
                  ],
                ),
              ),

              // Spacer to push Delete button to the bottom
              const SizedBox(height: 40.0),

              // Delete Account Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Optional padding at the bottom
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 138, 31, 23), // Red background
                    foregroundColor: Colors.white, // White text color
                    padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding inside the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    // Currently does nothing
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
