import 'package:flutter/material.dart';

class DataPrivacyPage extends StatelessWidget {
  const DataPrivacyPage({Key? key}) : super(key: key);

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
                'Data Privacy Information',
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
                'We are committed to protecting your personal data and ensuring your privacy while using our app. Therefore, this data privacy policy explains how we collect, use, and protect your data whenever you use our app. ',
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
                'What Data We Collect',
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
                'We collect the following types of information to provide you with the best possible experience: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),


            
            const SizedBox(height: 36), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Account Details: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "Name, email address, phone number ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 16), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Transaction History: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Details of your income, expenses, and financial transactions entered in the app. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 16), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Budgeting Information: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "Data related to your budgeting preferences, goals, and savings plans that are entered in the app. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

             const SizedBox(height: 16), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Device Details: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "Information such as your device type, operating system, and unique device identifiers. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

             const SizedBox(height: 16), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Firebase: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "We use Firebase to store and manage user data securely. This includes profile images and user authentication. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


        
             const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'How We Use Your Data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),



            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "Core Features: ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 92, 104, 92),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "To track your expenses, set budgets, and generate insights for you. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             const SizedBox(height: 16), 


            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "Security:  ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 92, 104, 92),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "To ensure the safety and security of your account and transactions. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


           const SizedBox(height: 16), 


           Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "Analytics and App Improvements: ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 92, 104, 92),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "To continuously improve the app’s functionality and performance. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


            const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'How We Protect Your Data',
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
                'Your data security is important to us. We take several measures to protect your personal information: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
   
                  color: const Color(0xFF282A28),
                ),
              ),
            ),


             const SizedBox(height: 36), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Encryption: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "All sensitive information, including financial data, is encrypted during transmission and when stored. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

             const SizedBox(height: 16), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Secure Storage: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "Your data is stored securely on cloud servers that comply with industry security standards. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

             const SizedBox(height: 16), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Access Control: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "Access to your data is restricted to authorized personnel only, and we implement strict access controls to protect it. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'Sharing Your Data',
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
                'We respect your privacy and will never sell your data to third parties. However, we may share your data in the following circumstances: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
   
                  color: const Color(0xFF282A28),
                ),
              ),
            ),


             const SizedBox(height: 36), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Third-Party Services: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "We may share your data with trusted third-party providers to deliver services such as cloud storage. These providers are obligated to protect your information. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

             const SizedBox(height: 16), 

            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "• Legal Compliance: ",
                        style: TextStyle(
                          color: const Color(0xFF566456),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "We may disclose your data if required by law, such as in response to a subpoena or a legal request. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),



             const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'User Rights',
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
                'You have several rights regarding your data: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),



             Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "Access and Updates: ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 92, 104, 92),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "You can access and update your personal information at any time by visiting the settings page in the app. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             const SizedBox(height: 16), 


            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "Data Deletion: ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 92, 104, 92),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "You may request that your data be deleted by contacting our support team., or deleting your account. Please note that deleting your data will remove your account and all associated information. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             const SizedBox(height: 16), 


           Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
              child: RichText(
                      text: TextSpan(
                        text: "Data Portability: ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 92, 104, 92),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "You may request a copy of your data, which will be sent to you via the email associated with your account. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 92, 104, 92),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),



            const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'Legal Disclaimer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0, bottom: 30.0,), 
              child: Text(
                'By using our app, you consent to the collection, use, and sharing of your data as described in this policy. ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF282A28),
                ),
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}
