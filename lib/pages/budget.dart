import 'package:flutter/material.dart';
import '../utils/donut_chart.dart'; 

class BudgetPage extends StatelessWidget {
  final Function(int) onNavigate; 

  const BudgetPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {

    //list of budget items
    final List<Map<String, dynamic>> budgetItems = [
      {'name': 'Rent', 'amount': 1200.0},
      {'name': 'Car Payment', 'amount': 300.0},
      {'name': 'Groceries', 'amount': 400.0},
      {'name': 'Utilities', 'amount': 150.0},
      {'name': 'Internet', 'amount': 60.0},
      {'name': 'Entertainment', 'amount': 100.0},
    ];

    return SingleChildScrollView( //enable scrolling
      child: Column(
        children: <Widget>[

          //'monthly expenses' header 
          Container(
            color: const Color.fromARGB(255, 197, 197, 197),
            padding: const EdgeInsets.symmetric(vertical: 16.0), 

            child: const Center(
              child: Text(
                'Monthly Expenses',
                style: TextStyle(
                  fontSize: 24, 
                  color: Color.fromARGB(255, 39, 39, 39),
                ),
              ),
            ),


          ),


          //space between header + pie chart 
          const SizedBox(height: 20), 


          //pie chart -- kody made separate file called donut chart, so its called donut chart here
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DonutChart(), 
            ),
          ),
          

          //space between pie chart + budget items
          const SizedBox(height: 50), 


          //budget items heading
          Container(
            color: const Color.fromARGB(255, 197, 197, 197),
            padding: const EdgeInsets.symmetric(vertical: 16.0),

            child: const Center(
              child: Text(
                'Budget Items',
                style: TextStyle(
                  fontSize: 24,
                   color: Color.fromARGB(255, 39, 39, 39),
                ),
              ),
            ),

          ),


          const SizedBox(height: 10), //spacing between heading + items



          //list of budget items 
          ListView.builder(
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(), //no inner scrolling
            itemCount: budgetItems.length,

            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[200], //background for each item
                margin: const EdgeInsets.symmetric(vertical: 4.0), //spacing between items
                child: ListTile(
                  title: Text(budgetItems[index]['name']),
                  trailing: Text(
                    '\$${budgetItems[index]['amount'].toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },


          ),
        ],
      ),
    );
  }
}
