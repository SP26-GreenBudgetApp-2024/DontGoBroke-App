import 'package:flutter/material.dart';

class CreditAdvicePage extends StatelessWidget {
  const CreditAdvicePage({Key? key}) : super(key: key);

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
                'Credit Cards',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),
 

             const SizedBox(height: 18), 


                
             Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "A ",
                  
                    style: TextStyle(
                      color: const Color(0xFF545B53),
                      fontSize: 18, 
                    ),
                    children: [
                      TextSpan(
                        text: "credit card ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontSize: 18, 
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " is a card that allows cardholders to borrow funds to pay for goods and services. This means that when you use a credit card, you use it on the condition that you will pay back the borrowed money, plus any applicable interest and any other fees later.",
                        style: TextStyle(
                       
                          
                          color: const Color(0xFF545B53),
                          fontSize: 18, 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


              const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'How They Work',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF373737),
                ),
              ),
            ),

  
            
             const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: Text(
                'Credit cards let you borrow money up to a set limit. You must repay the balance by the due date or incur interest charges.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF545B53),
                ),
              ),
            ),

             const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'Pros and Cons of Credit Cards',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF373737),
                ),
              ),
            ),


             Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Pros: ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Builds credit, Convenient for big purchases, Offers rewards & protections ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Cons: ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Risk of overspending, High-interest rates, Late fees and annual fees",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),



           const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'How to Build and Maintain Good Credit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF373737),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "1. Start small: ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Use a secured or student card if you’re new to credit. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "2.  Pay in full:  ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Avoid carrying a balance when possible.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


            Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "3. Monitor usage:  ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Aim to keep balances under 30% of your credit limit.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


           Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "4. Be patient: ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Credit building takes time, so avoid closing old accounts.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),



            
           const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'Common Mistakes to Avoid',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF373737),
                ),
              ),
            ),

             Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Missing payments: ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Set reminders or automate payments. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Maxing out your card:  ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "Use only what you can repay quickly.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


              Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Applying for too many cards:  ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 18, 
                        ),
                        children: [
                          TextSpan(
                            text: "This can lower your score temporarily.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 18, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             const SizedBox(height: 38),


              const Divider(
                color: Color.fromARGB(255, 78, 78, 78),
                thickness: .5,     
                indent: 100,         
                endIndent: 100,     
              ),




              const Padding(
                    padding: EdgeInsets.only(top: 38.0),
                    child: Text(
                      'Credit Cards',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),

            

              const SizedBox(height: 18), 


                
             Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "A ",
                    style: TextStyle(
                      color: const Color(0xFF545B53),
                      fontSize: 18, 
                    ),
                    children: [
                      TextSpan(
                        text: "credit score ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontSize: 18, 
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " is a three-digit number designed to represent the likelihood you will pay your bills on time. This means that it is a snapshot of your financial health, and it is used by lenders to assess your creditworthiness.",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontSize: 18, 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            


                
            const Padding(
              padding: EdgeInsets.only(top: 46.0), 
              child: Text(
                'What Affects Your Score?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF373737),
                ),
              ),
            ),







             Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Payment History: ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "35% - Pay your bills on time. ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


             Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Credit Utilization:  ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "30% - Keep balances low.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


              Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Length of Credit History:  ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: " 15% - The longer, the better.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


              Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Credit Mix: ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "10% - A variety of credit types helps.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
                              fontSize: 16, 
                            ),
                          ),
                        ],
                      ),
                    ),
            ),


              Padding(
              padding: EdgeInsets.only(top: 16.0, left: 30.0, right: 30.0,), 
              child: RichText(
                 textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "New Credit: ",
                        style: TextStyle(
                          color: const Color(0xFF545B53),
                          fontWeight: FontWeight.bold,
                          fontSize: 16, 
                        ),
                        children: [
                          TextSpan(
                            text: "10% - Avoid opening too many accounts quickly.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF545B53),
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
                'Score Ranges',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF373737),
                ),
              ),
            ),

            
            const SizedBox(height: 22), 



           Image.asset(
              'images/score_ranges.png', 
              fit: BoxFit.contain, 
            ),


            
            const SizedBox(height: 10), 


             const Padding(
              padding: EdgeInsets.only(top: 46.0),
              child: Text(
                'Tips to Improve Your Credit Score',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF373737),
                ),
              ),
            ),

  
            
             const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
              child: Text(
                '1. Pay at least the minimum due on time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF545B53),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),


           const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0, ), 
              child: Text(
                '2. Keep credit card balances below 30% of your limit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, 
                  color: const Color(0xFF545B53),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0, bottom: 30.0,), 
              child: Text(
                '3. Regularly check your credit report for errors.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: const Color(0xFF545B53),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),       
          ]
        ),
       ),
      
    );
  }
}
