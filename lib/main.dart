import 'package:flutter/material.dart';

import 'pages/budget.dart'; 
import 'pages/transactions.dart'; 
import 'pages/overview.dart'; 
import 'pages/settings.dart';
import 'pages/home.dart';  


import 'login_page.dart';
import 'create_user.dart';


import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    //Use 127.0.0.1 instead of localhost -- could use this for testing phone verification stuff, 
    //since trying to do it from localhost gives a 'invalid application verifier' error. i think its
    // because Google rolled out an update where they don't accept localhost as a valid domain, making it harder to debug.
    //I ended up just using a test number + code that I put in Firebase to do phone verification, but I'll just leave this here for future reference

    /* 
    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099); 
    }  */

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Don't Go Broke",
      
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/createuser': (context) => CreateUserPage(),
      },

      theme: ThemeData(
          focusColor: Colors.black, // Set the default focus color to black
        ),

      

      debugShowCheckedModeBanner: false, //remove debug banner
    
      
    );
  }
}






class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}




class _MainPageState extends State<MainPage> {


  int _selectedIndex = 0; //track currently selected index

  //update selected index + trigger a rebuild
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Don't Go Broke"),
        backgroundColor: const Color.fromARGB(255, 23, 28, 24), //header 
        leading: Padding(
          padding: const EdgeInsets.all(8.0), //padding around the image
          child: Image.asset('images/logo.png'), 
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              
              //navigate to settings page 
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    onNavigate: _onItemTapped,
                    selectedIndex: _selectedIndex, //pass current selected index
                  ),
                ),
              ); 

            },
          ),
        ],
      ),


      
      body: IndexedStack(
        index: _selectedIndex, //current page index
        children: [
          HomePage(onNavigate: _onItemTapped,),
          TransactionsPage(onNavigate: _onItemTapped),
          BudgetPage(onNavigate: _onItemTapped),
          OverviewPage(onNavigate: _onItemTapped),
        ],
      ), 



      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 54, 71, 46), //nav bar background color

        //selected + unselected icon + text color
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white54, 


        type: BottomNavigationBarType.fixed, 


        //nav bar icons
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Budget",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Overview",
          ),
         
        ],
      ),
    );
  }
}



