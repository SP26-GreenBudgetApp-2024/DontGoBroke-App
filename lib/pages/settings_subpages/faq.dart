import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 28, 24), 
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 42.0), 
              child: Text(
                'Frequently Asked Questions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),

      
             const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: Text(
                'Welcome to Don’t Go Broke’s FAQ page! Here, you’ll find answers to some of the most common questions about using our app. ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'General Questions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: Text(
                "1. What is Don't Go Broke? ",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "Don't Go Broke is a budgeting and financial management app designed to help you track your spending, set budgets, save for goals, and gain financial insights. Our goal is to help people make smarter financial decisions.",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const SizedBox(height: 12), 


             const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "2. Is the app free?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "Yes, Don’t Go Broke is free to download and use. ",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const SizedBox(height: 12), 


             const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,),
              child: Text(
                "3. Can I use the app on multiple devices?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,),
              child: Text(
                "Yes, you can use Don’t Go Broke on multiple devices. Just sign in with the same account to sync your data across all your devices. ",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),



             const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'Account and Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: Text(
                "4. How do I change my profile picture? ",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "To change your profile picture, go to the Settings page and tap on your current photo. You’ll be able to upload a new image from your device.",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const SizedBox(height: 12), 



             const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,),
              child: Text(
                "5. How do I reset my password?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,),
              child: Text(
                "If you’ve forgotten your password, either go to the login screen and tap on ‘Forgot Password’, or navigate to  the ‘Password and Recovery Options’ page (the link of which is on the ‘Settings’ page).",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),


            const SizedBox(height: 12), 


             const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "6. Can I delete my account?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "Yes, if you wish to delete your account, go to the Settings page and tap on Delete Account. Please note that deleting your account will permanently delete all your data. ",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),



          
             const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'Features and Functionality',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: Text(
                "7. How do I add transactions?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "To add transactions, go to the Transactions tab and tap the + button. Select the category, enter the amount, and save the transaction.",
                style: TextStyle(
                  fontSize: 18,
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const SizedBox(height: 12), 



             const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "8. How do I set a budget for the month?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "In the Budget section, tap on ‘Add New Monthly Expense', and choose the categories you want to track (e.g., groceries, entertainment, etc). Set your desired budget for each category, and the app will track your spending against the budget you set.",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

          
             const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'Troubleshooting',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: Text(
                "9. The app isn’t syncing across my devices. What should I do?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "If your data isn’t syncing, try logging out and logging back in on both devices. If that doesn’t work, ensure you have an active internet connection and try syncing again.",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const SizedBox(height: 12), 



             const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "10. The app crashed, what should I do?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "If the app crashes, please try restarting it. If the issue persists, check for app updates. Then, if you’re still having trouble, contact support, and we’ll help you troubleshoot.",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const SizedBox(height: 12), 


             const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "11. Why am I seeing an error when adding a transaction?",
                style: TextStyle(
                  fontSize: 18, 
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: Text(
                "If you encounter an error while adding a transaction, double-check that you’ve entered the correct amount and category. Ensure that you’re connected to the internet and try again.",
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),


            
            const Padding(
              padding: EdgeInsets.only(top: 42.0), 
              child: Text(
                'Contact',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

  
            
           Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0, bottom: 40.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: "If you need any other assistance, you can contact our support team at support ",
                    style: TextStyle(
                      color: const Color(0xFF282A28),
                      fontSize: 18, 
                    ),
                    children: [
                      TextSpan(
                        text: "@dontgobrokeapp.com. ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 90, 136, 90),
                          fontSize: 18, 
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(
                        text: "Don’t be afraid to contact us -- we’re here to help!",
                        style: TextStyle(
                          color: const Color(0xFF282A28),
                          fontSize: 18, 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ]
        ),
      ),
    );
  }
}
