import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class TakeHomeMoneyPage extends StatefulWidget {
  const TakeHomeMoneyPage({Key? key}) : super(key: key);

  @override
  _TakeHomeMoneyPageState createState() => _TakeHomeMoneyPageState();
}

class _TakeHomeMoneyPageState extends State<TakeHomeMoneyPage> {

   final _grossIncomeController = TextEditingController();

  String _filingStatus = "single";
  String _payFrequency = "Annually";
  String _result = "";
  String _result2="";
  double _localTax=0.00;

  bool isVisible=false;



  final TextEditingController _stateController = TextEditingController();
  String _selectedState = "";
  String? _stateError;  




  void calculateTakeHome() {
    isVisible=true;

    final grossIncome = double.tryParse(_grossIncomeController.text) ?? 0.0;

    //deductions
    double socialSecurity = grossIncome * 0.062;
    double medicare = grossIncome * 0.0145;

    //federal tax
    double federalTax = calculateFederalTax(grossIncome, _filingStatus);

    //state + local tax -- local tax is just average of all local taxes in state
    double stateTaxRate = double.tryParse(states.firstWhere((state) => state['name'] == _selectedState)['stateTax'] ?? '0') ?? 0.0;
     double localTaxRate = double.tryParse(states.firstWhere((state) => state['name'] == _selectedState)['localTax'] ?? '0') ?? 0.0;

    double stateTax = grossIncome * (stateTaxRate / 100);
    double localTax = grossIncome * (localTaxRate / 100);

    double totalDeductions = socialSecurity + medicare + federalTax + stateTax + localTax;
    double annualTakeHomePay = grossIncome - totalDeductions;

    int frequency=0;

    if (_payFrequency=="Annually") {
      frequency=1;
    }
    else if (_payFrequency=="Monthly") {
        frequency=12;
    }
    else if (_payFrequency=="Biweekly") {
        frequency=26;
    }
    else if (_payFrequency=="Weekly") {
        frequency=52;
    }
    
    

    double takeHomePay = annualTakeHomePay / frequency;

    setState(() {
      _result = """ \$${takeHomePay.toStringAsFixed(2)}.""";
    _result2 = """Social Security: -\$${socialSecurity.toStringAsFixed(2)}
Medicare: -\$${medicare.toStringAsFixed(2)}
Federal Tax: -\$${federalTax.toStringAsFixed(2)}
State Tax: -\$${stateTax.toStringAsFixed(2)}
Local Tax: -\$${localTax.toStringAsFixed(2)} """;
    });
  }



 double calculateFederalTax(double income, String filingStatus) {
    
 final taxBrackets = {
      'single': [
        {'max': 11600, 'rate': 0.10},
        {'max': 47150, 'rate': 0.12},
        {'max': 100525, 'rate': 0.22},
        {'max': 191950, 'rate': 0.24},
        {'max': 243725, 'rate': 0.32},
        {'max': 609350, 'rate': 0.35},
        {'max': double.infinity, 'rate': 0.37},
      ],
      'marriedJointly': [
        {'max': 23200, 'rate': 0.10},
        {'max': 94300, 'rate': 0.12},
        {'max': 201050, 'rate': 0.22},
        {'max': 383900, 'rate': 0.24},
        {'max': 487450, 'rate': 0.32},
        {'max': 731200, 'rate': 0.35},
        {'max': double.infinity, 'rate': 0.37},
      ],
      'marriedSeparately': [
        {'max': 11600, 'rate': 0.10},
        {'max': 47150, 'rate': 0.12},
        {'max': 100525, 'rate': 0.22},
        {'max': 191950, 'rate': 0.24},
        {'max': 243725, 'rate': 0.32},
        {'max': 365600, 'rate': 0.35},
        {'max': double.infinity, 'rate': 0.37},
      ],
      'headOfHousehold': [
        {'max': 16550, 'rate': 0.10},
        {'max': 63100, 'rate': 0.12},
        {'max': 100500, 'rate': 0.22},
        {'max': 191950, 'rate': 0.24},
        {'max': 243700, 'rate': 0.32},
        {'max': 609350, 'rate': 0.35},
        {'max': double.infinity, 'rate': 0.37},
      ],
    };

    double tax = 0.0;
    double previousMax = 0.0;

    if (taxBrackets.containsKey(filingStatus)) {
      for (var bracket in taxBrackets[filingStatus]!) {
        if (income > bracket["max"]!) {
          tax += (bracket["max"]! - previousMax) * bracket["rate"]!;
        } else {
          tax += (income - previousMax) * bracket["rate"]!;
          break;
        }
        previousMax = (bracket["max"]! as double);

      }
    }

    return tax;
  }




  //state tax data
  final List<Map<String, dynamic>> states = [
  {"name": "Alabama", "stateTax": "4.00", "localTax": "5.289"},
  {"name": "Alaska", "stateTax": "0.00", "localTax": "1.821"},
  {"name": "Arizona", "stateTax": "5.60", "localTax": "2.779"},
  {"name": "Arkansas", "stateTax": "6.50", "localTax": "2.948"},
  {"name": "California", "stateTax": "7.25", "localTax": "1.601"},
  {"name": "Colorado", "stateTax": "2.90", "localTax": "4.907"},
  {"name": "Connecticut", "stateTax": "6.35", "localTax": "1.00"},
  {"name": "Delaware", "stateTax": "0.00", "localTax": "0.00"},
  {"name": "Florida", "stateTax": "6.00", "localTax": "1.002"},
  {"name": "Georgia", "stateTax": "4.00", "localTax": "3.384"},

  {"name": "Hawaii", "stateTax": "4.00", "localTax": "0.5"},
  {"name": "Idaho", "stateTax": "6.00", "localTax": "0.026"},
  {"name": "Illinois", "stateTax": "6.25", "localTax": "2.605"},
  {"name": "Indiana", "stateTax": "7.00", "localTax": "0.00"},
  {"name": "Iowa", "stateTax": "6.00", "localTax": "0.941"},
  {"name": "Kansas", "stateTax": "6.50", "localTax": "2.154"},
  {"name": "Kentucky", "stateTax": "6.00", "localTax": "0.00"},
  {"name": "Louisiana", "stateTax": "4.45", "localTax": "5.113"},
  {"name": "Maine", "stateTax": "5.50", "localTax": "0.00"},
  {"name": "Maryland", "stateTax": "6.00", "localTax": "0.00"},


  {"name": "Massachusetts", "stateTax": "6.25", "localTax": "0.00"},
  {"name": "Michigan", "stateTax": "6.00", "localTax": "0.00"},
  {"name": "Minnesota", "stateTax": "6.875", "localTax": "1.163"},
  {"name": "Mississippi", "stateTax": "7.00", "localTax": "0.062"},
  {"name": "Missouri", "stateTax": "4.225", "localTax": "4.160"},
  {"name": "Montana", "stateTax": "0.00", "localTax": "0.00"},
  {"name": "Nebraska", "stateTax": "5.50", "localTax": "1.468"},
  {"name": "Nevada", "stateTax": "6.85", "localTax": "1.386"},
  {"name": "New Hampshire", "stateTax": "0.00", "localTax": "0.00"},
  {"name": "New Jersey", "stateTax": "6.625", "localTax": "0.00"},


  {"name": "New Mexico", "stateTax":"4.875", "localTax": "2.694"},
  {"name": "New York", "stateTax": "4.00", "localTax": "4.532"},
  {"name": "North Carolina", "stateTax": "4.75", "localTax": "2.246"},
  {"name": "North Dakota", "stateTax": "5.00", "localTax": "2.041"},
  {"name": "Ohio", "stateTax": "5.75", "localTax": "1.488"},
  {"name": "Oklahoma", "stateTax": "4.50", "localTax": "4.489"},
  {"name": "Oregon", "stateTax": "0.00", "localTax": "0.00"},
  {"name": "Pennsylvania", "stateTax": "6.00", "localTax": "0.341"},
  {"name": "Rhode Island", "stateTax": "7.00", "localTax": "0.00"},
  {"name": "South Carolina", "stateTax": "6.00", "localTax": "1.499"},


  {"name": "South Dakota", "stateTax": "4.20", "localTax": "1.911"},
  {"name": "Tennessee", "stateTax": "7.00", "localTax": "2.548"},
  {"name": "Texas", "stateTax": "6.25", "localTax": "1.950"},
  {"name": "Utah", "stateTax": "6.10", "localTax": "1.149"},
  {"name": "Vermont", "stateTax": "6.00", "localTax": "0.359"},
  {"name": "Virginia", "stateTax": "5.30", "localTax": "0.471"},
  {"name": "Washington", "stateTax": "6.50", "localTax": "2.878"},
  {"name": "West Virginia", "stateTax": "6.00", "localTax": "0.567"},
  {"name": "Wisconsin", "stateTax": "5.00", "localTax": "0.696"},
  {"name": "Wyoming", "stateTax": "4.00", "localTax": "1.441"},

  {"name": "District of Columbia", "stateTax": "6.00", "localTax": "0.00"},

];



void _checkState(String stateName) {
  var state = states.firstWhere(
  (state) => state["name"].toLowerCase() == stateName.toLowerCase(),
  orElse: () => {}, 
);

if (state.isNotEmpty) {
  setState(() {
    _selectedState = stateName;
    _localTax = state["localTax"];
    _stateError = null;
  });
} else {
  setState(() {
    _stateError = "Invalid state name"; 
  });
  _showErrorDialog(); 
}

}

void _showErrorDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Invalid State'),
        content: Text('Please enter a valid state name.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




  Widget _buildStyledTextField1(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.number}) {
    return Container( 
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText:  labelText,
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 64, 64, 64),
              fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.4,
            ),
          ),
          fillColor: const Color.fromARGB(255, 246, 246, 246),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: TextStyle(fontSize: 18),
      ),
    );
  }


  Widget _buildStyledTextField2(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          errorText: _stateError,
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 64, 64, 64),
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.4,
            ),
          ),
          fillColor: const Color.fromARGB(255, 246, 246, 246),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),

         onChanged: (input) {
                        setState(() {
                          _selectedState = input;
                          _stateError = null;
                        });
                      },
                      onEditingComplete: () {
                        _checkState(_stateController.text);
                      },

        style: TextStyle(fontSize: 18),
      ),
    );
  }




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
          children: [     
           const Padding(
              padding: EdgeInsets.only(top: 48.0), 
              child: Text(
                'Calculate Take Home Money After Taxes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(top: 16.0), 
              child: Text(
                '(For US Residents)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24, 
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF434A43),
                ),
              ),
            ),


             const SizedBox(height: 16), 


            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [

                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0), 
                    child: Text(
                      'Gross Annual Income (\$)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 

                      ),
                    ),
                  ),


                    _buildStyledTextField1(_grossIncomeController,"Gross Income "),


                    const Padding(
                    padding: EdgeInsets.only(top: 38.0, bottom: 16.0), 
                    child: Text(
                      'Filing Status ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),

                    
                   FilingStatusDropdown(),

                   const Padding(
                    padding: EdgeInsets.only(top: 38.0, bottom: 16.0), 
                    child: Text(
                      'State ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                      ),
                    ),
                  ),

                    
                     _buildStyledTextField2(_stateController,"State "),

                  const Padding(
                    padding: EdgeInsets.only(top: 38.0, bottom: 16.0),
                    child: Text(
                      'Pay Frequency ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
 
                      ),
                    ),
                  ),

                  PayFrequencyDropdown(),

                  Padding(
                          padding: EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0,), 
                          child: RichText(
                            textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "Note: ",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 36, 37, 35),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18, 
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "This is a rough estimate, and doesn't include certain types of deductions (like types of insurance, 401ks, etc) or certain benefits (like tax credits). ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color:  const Color.fromARGB(255, 36, 37, 35),
                                          fontSize: 18, 
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),

                      Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0,), 
                          child: RichText(
                            textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: "This calculator only considers the following: ",
                                    style: TextStyle(
                                      color: const Color(0xFF6B7969),
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16, 
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Federal tax, State tax, Average local tax, Social Security, Medicare ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic,
                                          color: const Color(0xFF6B7969),
                                          fontSize: 16, 
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),


                    SizedBox(height: 40), 

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        
                        ElevatedButton(
                          onPressed: calculateTakeHome,

                          style: ElevatedButton.styleFrom(            
                               elevation: 2.5,
                                foregroundColor: Color.fromARGB(255, 39, 39, 39),
                                backgroundColor: const Color.fromARGB(255, 180, 194, 176), 
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: const BorderSide(
                                    color: Colors.black, 
                                    width: 1.80, 
                                  ),
                                ),
                                minimumSize: const Size(120, 60), 
                                
                                textStyle: TextStyle(fontSize: 24),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: Text('Calculate'),
                          
                        )

                    
                      ],
                    ),
                  ],
                ),
              ),


            if (isVisible==true)  
                Padding(
                  padding: EdgeInsets.only(top: 20.0), 
                  child: RichText(
                    textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Your take home pay is: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22, 
                            ),
                            children: [
                              TextSpan(
                                text: _result,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22, 
                                ),
                              ),
                            ],
                          ),
                        ),
                ),


            if (isVisible==true)
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 6.0), 
                    child: Text(
                      'Deductions:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        fontStyle: FontStyle.italic,
                        color: const Color.fromARGB(255, 56, 56, 56)
                      ),
                    ),
                  ),

        

            if (isVisible==true)
                 const Divider(
                      color: Color.fromARGB(255, 78, 78, 78), 
                      thickness: .5,     
                      indent: 180,     
                      endIndent: 180,      
                    ),
 
           if (isVisible==true)
                const SizedBox(height: 6),

           if (isVisible==true)
                Text(
                    _result2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16, 
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(255, 56, 56, 56)
                    ),
                ),

            SizedBox(height: 20), 
                          

          ]
        ),
      ),
    );
  }
}





class FilingStatusDropdown extends StatefulWidget {
  @override
  _FilingStatusDropdownState createState() => _FilingStatusDropdownState();
}

class _FilingStatusDropdownState extends State<FilingStatusDropdown> {
  String? _filingStatus = 'single'; 

  final List<Map<String, String>> filingStatusList = [
    {'value': 'single', 'label': 'Single'},
    {'value': 'marriedJointly', 'label': 'Married Filing Jointly'},
    {'value': 'marriedSeparately', 'label': 'Married Filing Separately'},
    {'value': 'headOfHousehold', 'label': 'Head of Household'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField2<String>(
        value: _filingStatus,
        isExpanded: true,

        decoration: InputDecoration(
          labelText: "Filing Status",
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 64, 64, 64),
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.4,
            ),
          ),
          fillColor: Color.fromARGB(255, 246, 246, 246),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
        items: filingStatusList.map((status) {
          return DropdownMenuItem<String>(
            value: status['value'],
            child: Text(
              status['label']!,
              style: TextStyle(fontSize: 18),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _filingStatus = value;
          });
        },
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
        ),
         buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.only(right: 6),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            iconSize: 18,
          ),
      ),
    );
  }
}






class PayFrequencyDropdown extends StatefulWidget {
  @override
  _PayFrequencyDropdownState createState() => _PayFrequencyDropdownState();
}

class _PayFrequencyDropdownState extends State<PayFrequencyDropdown> {

  String? _payFrequency = "Annually"; 


    final List<Map<String, String>> payFrequencyList  = [
    {'value': 'Annually', 'label': 'Annually'},
    {'value': 'Monthly', 'label': 'Monthly'},
    {'value': 'Biweekly', 'label': 'Biweekly'},
    {'value': 'Weekly', 'label': 'Weekly'},
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField2<String>(
        value: _payFrequency,
        isExpanded: true,
     
        decoration: InputDecoration(
          labelText: "Pay Frequency",
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 64, 64, 64),
            fontSize: 20,
          ),
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.4,
            ),
          ),
          fillColor: Color.fromARGB(255, 246, 246, 246),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
        ),
        items: payFrequencyList.map((status) {
          return DropdownMenuItem<String>(
            value: status['value'],
            child: Text(
              status['label']!,
              style: TextStyle(fontSize: 18),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _payFrequency = value;
          });
        },
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200], 
          ),
        ),
         buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.only(right: 6), 
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            iconSize: 18,
          ),
      ),
    );
  }
}








