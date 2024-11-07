import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DonutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    //data to put in pie chart + legend
    final pieSections = _getSections();
    final legendItems = [
      LegendItem('Rent', Colors.blue),
      LegendItem('Car Payment', Colors.red),
      LegendItem('Groceries', Colors.green),
      LegendItem('Utilities', Colors.orange),
      LegendItem('Internet', const Color.fromARGB(255, 255, 202, 12)),
      LegendItem('Entertainment', Colors.purple),
    ];


    return Center( 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,


        children: [

          //pie chart
          ConstrainedBox(

            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.5,
              maxHeight: screenSize.height * 0.5, //adjust to fit screen size
            ),

            child: PieChart(
              PieChartData(
                sections: pieSections,
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 60,
                sectionsSpace: 2,
              ),
            ),


          ),
          



          SizedBox(width: 40), //space between pie chart + legend



          //legend
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: legendItems.map((item) {
              return Row(
                children: [

                  //box part of legend
                  Container(
                    width: 10,
                    height: 10,
                    color: item.color,
                  ),

                  SizedBox(width: 8), //space in between box + text

                  //text part of legend
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }




  //pie chart values/sections
  List<PieChartSectionData> _getSections() {
    return List.generate(6, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 54,
            title: '54%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: 14,
            title: '14%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: 18,
            title: '18%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.orange,
            value: 7,
            title: '7%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: const Color.fromARGB(255, 255, 202, 12),
            value: 3,
            title: '3%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        case 5:
          return PieChartSectionData(
            color: Colors.purple,
            value: 4,
            title: '4%',
            radius: 60,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}


//legend item class
class LegendItem {
  final String label;
  final Color color;

  LegendItem(this.label, this.color);
}
