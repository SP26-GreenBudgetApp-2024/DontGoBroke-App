import 'package:flutter/material.dart';



class TipsInsightsPage extends StatelessWidget {
  const TipsInsightsPage({Key? key}) : super(key: key);

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

      body:  SingleChildScrollView( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 42.0), 
                child: Text(
                  'General Tips and Insights for Budgeting',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                  ),
                ),
              ),

              const SizedBox(height: 15),


              const Divider(
                color: Color.fromARGB(255, 78, 78, 78), 
                thickness: .5,        
                indent: 100,          
                endIndent: 100,      
              ),

              const SizedBox(height: 32), 

              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "1 ) Create your budget before the month begins: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "By planning ahead your month's activities and expenses, you make it easier for yourself to pay bills on time, build an emergency fund, and save for other expenses. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "2 ) Overestimate your expenses, and underestimate your income:  ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "This means that you should assume that the amount you'll have to pay each month will be higher than you may expect, and the amount of money you will earn each month will be less than you may expect. This is a good strategy, because its better to end up with a surplus each month, than to overspend money and end up not having enough. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "3 ) Pay off debt:  ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Paying off any debt you may have needs to be a top priority, as debt can accumulate rather fast.  ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
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
                child: Text(
                    "There are two recommended ways of paying off debt: ", 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF3B3C3B),
                    ),
                  ),
              ),
              


              const SizedBox(height: 16), 

              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "Snowball Method: ",
                          style: TextStyle(
                            color: const Color(0xFF566456),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Paying off each debt from smallest to largest, regardless of their interest rates. You do this by paying the minimum payments on all debts except the smallest debt, throwing as much money as you can at that one, and then repeat that with each next smallest debt after that. ",
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
                          text: "Avalanche Method: ",
                          style: TextStyle(
                            color: const Color(0xFF566456),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: " Paying off the debts with the highest interest rates first, to avoid building more debt. This is done by paying off each debt from highest interest rate to smallest interest rate, and throwing as much money as you can at the debt with the highest interest rate, while paying the minimum payments for te rest of the debts. Then, once the debt is paid, you repeat the cycle with the debts you have after that. ",
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


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "4 ) Have a savings account: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Having an account just for savings can help you with many things, such as having a place to store an emergency fund, having your savings be protected by insurance in case of disaster, and having the ability to earn interest on your savings. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "5 ) Prepare for the unexpected, and have an emergency fund:  ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Setting aside money for unplanned expenses or emergencies could help you to avoid running out of money, accumulating too much debt, and stop you from being too dependent on credit cards. The amount you save, of course, depends on your individual circumstances, but overall,  it's generally recommended to cover about three to six months of expenses in an emergency fund. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
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
                child: Text(
                    "Also, its recommended to have your emergency fund in cash, or at least accessible enough that you can access it quickly. However, don't make too accessible, so you aren't tempted to use it for everyday expenses.", 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF3B3C3B),
                    ),
                  ),
              ),
              


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "6 ) Have someone to budget with you:  ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "If possible, it's best to have someone to refer to, or at least help with your budget, as the other person will help keep you accountable.  Whether this is your marriage partner, roommate, a consultant, or just a friend depends on you and your situation, but overall, it's helpful to have support. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),



              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "7 ) Prioritize spending money on necessities first: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "This means food, utilities, shelter, and a mode of transportation.  You can budget for the rest after, but it is imperative you take care of your immediate needs before anything else. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "8 ) Do anything you can to save money: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "This involves doing things like taking advantage of any discounts, making coffee at home, packing your own lunch, cancel subscriptions you don't use, buying things secondhand, buy groceries in bulk (so you aren't tempted to eat out a lot), walk instead of driving if possible (to save money on gas), etcetra etcetra.",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),



              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "9 ) Avoid using credit cards when possible: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Credit cards make it very easy to overspend, and is a quick way to gain debt (especially when you have to pay interest, which makes things even more expensive). Credit cards also add an extra monthly expense, which can make budgeting a lot more difficult. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "10 ) Differentiate between needs and wants: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Making a list of things you need versus things you want can help you visualize what is important to prioritize, and what you can save up for for later. So, for example, you could mark something like food is a 'need', whereas something like a vacation would be marked as a 'want'. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
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
                child: Text(
                    "Overall, though, when it comes to deciding what to spend your income on, it's generally recommended to follow the 50/30/20 rule (so, 50% of income for necessities, 30% for non-essentials, and 20% for savings).", 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF3B3C3B),
                    ),
                  ),
              ),
              



              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "11 ) Pay attention to and check your bank account regularly: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "By checking your balance regularly, you can see when it starts to get too low and stay on top of your spending. Also, by looking at the account regularly, you can verify all deposits and withdrawals being made, and also detect any fraudulent activity that may occur early on.  ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "12 ) Set specific goals: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Setting goals helps you keep in mind what it is you are saving for, and what steps you need to get there. This helps you stay focused, and gives you something to strive for, which is an excellent motivator. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),



            const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "13 ) Track your progress: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Tracking your progress also helps motivate you, as it lets you know how far you've come, and what is left for you to knock out. It can also let you know whether your current budget and habits are working, and whether you need to make more adjustments or not. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "14 ) Adjust your budget when needed: ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Every month will be different, and have different things you'll need to spend money on (for example, you'll have to spend money on back-to-school supplies during the start of the school year, or spend money on presents during the holidays). So, don't be afraid to make a budget that is specific for certain months.  ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "15 ) Start saving for retirement as soon as possible:   ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "The sooner you start saving for retirement, the better, as this will help ensure that you will have enough money to get through your retirement years, and maybe even depart from the workforce earlier. Also, it's easier to save the earlier you do it, as you will most likely have more responsibilites to pay for around the time you reach 40 years of age (like paying for a mortgage loan, or paying for your child's education).  When you start early, however, you can afford to put away less month per month, since compound interest will be on your side. ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
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
                child: Text(
                    "For most people, it's generally recommended to save about 15% of your income per year for retirement. If you're a high earner, however, you should aim for higher than that. ", 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF3B3C3B),
                    ),
                  ),
              ),
              


              const SizedBox(height: 38), 


              Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0,), 
                child: RichText(
                        text: TextSpan(
                          text: "16 ) Factor in fun when you can, but be smart about it:   ",
                          style: TextStyle(
                            color: const Color(0xFF3B3C3B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16, 
                          ),
                          children: [
                            TextSpan(
                              text: "Putting aside some money for nonessential activities allows you to have some money for things you enjoy, so that you can stay on top of your finances without sacrificing all fun altogether.  ",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF3B3C3B),
                                fontSize: 16, 
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 38), 

              ],
            ),
      ),
    );
  }
}
