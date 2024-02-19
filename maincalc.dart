import 'package:flutter/material.dart';

void main() => runApp(MyApp()); // to run the app

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //to remove the debug banner from the top right
      home: Calculator(), //to make the calculator widget the homescreen
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() =>
      _CalculatorState(); //create state returns the state of the calculator widget
}

class _CalculatorState extends State<Calculator> {
  dynamic displaytxt = 20; //dynaamic so it can change

  //designing and placing the icons
  @override
  Widget build(BuildContext context) {
    // Calculator
    return Scaffold(
      backgroundColor: Colors.black, //background for calculator
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.black, //background for appbar of calculator
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          //column as it goes vertically down
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Calculator display
            SingleChildScrollView(
              //for scrolling
              scrollDirection: Axis.vertical,
              child: Row(
                //rows as it goes horizontally aswell
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '$text',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              //first row of operands
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('AC', Colors.grey, Colors.black),
                calcbutton('+/-', Colors.grey, Colors.black),
                calcbutton('%', Colors.grey, Colors.black),
                calcbutton('/', Colors.amber[700]!, Colors.white),
              ],
            ),
            SizedBox(
              //for spacing between the rows
              height: 10,
            ),
            Row(
              //2nd row of operands/numbers
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('7', Colors.grey[850]!, Colors.white),
                calcbutton('8', Colors.grey[850]!, Colors.white),
                calcbutton('9', Colors.grey[850]!, Colors.white),
                calcbutton('x', Colors.amber[700]!, Colors.white),
              ],
            ),
            SizedBox(
              //for spacing between the rows
              height: 10,
            ),
            Row(
              //3rd row of operands and numbers
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('4', Colors.grey[850]!, Colors.white),
                calcbutton('5', Colors.grey[850]!, Colors.white),
                calcbutton('6', Colors.grey[850]!, Colors.white),
                calcbutton('-', Colors.amber[700]!, Colors.white),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              //4th row of operands/numbers
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                calcbutton('1', Colors.grey[850]!, Colors.white),
                calcbutton('2', Colors.grey[850]!, Colors.white),
                calcbutton('3', Colors.grey[850]!, Colors.white),
                calcbutton('+', Colors.amber[700]!, Colors.white),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //this is button Zero
                ElevatedButton(
                  onPressed: () {
                    calculation('0');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Colors.grey[850],
                    padding: EdgeInsets.fromLTRB(34, 20, 128, 20),
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ), //final two buttons
                calcbutton('.', Colors.grey[850]!, Colors.white),
                calcbutton('=', Colors.amber[700]!, Colors.white),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  // Button Widget
  Widget calcbutton(String btntxt, Color btncolor, Color txtcolor) {
    //used as a generic function to define button styling
    return Container(
      //used to add padding etc around the widget
      child: ElevatedButton(
        //elevated so that the button elevates when pressed
        onPressed: () {
          //functionality for when a button is pressed
          calculation(
              btntxt); //calls calculation function basec on the input btntxt
        },
        child: Text(
          //styling for the button
          '$btntxt',
          style: TextStyle(
            fontSize: 35,
            color: txtcolor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: btncolor,
          padding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  //base values for variables(to be used in calculation)
  dynamic text =
      '0'; //the number text displayed at the right above all the buttons
  double numOne = 0; //first number used for calculations
  double numTwo = 0; //second number used for calculations
  dynamic opr = ''; //current operand
  dynamic preOpr = ''; //previous operand used for tracking
  dynamic result = ''; //temp result to show progress of calculations
  dynamic finalResult = ''; //result when = is pressed

  //calculation logic
  void calculation(btnText) {
    //for when the AC button is pressed
    if (btnText == 'AC') {
      setState(() {
        //sets everything to default values as this button clears all
        text = '0';
        numOne = 0;
        numTwo = 0;
        opr = '';
        preOpr = '';
        result = '';
        finalResult = '0';
      });
    } else if (btnText == '+' ||
        btnText == '-' ||
        btnText == 'x' ||
        btnText == '/' ||
        btnText == '=') {
      if (numOne == 0) {
        //differentiates between whether number one is being input or number two
        numOne = double.parse(result);
      } else {
        numTwo = double.parse(result);
      }

      if (opr == '+') {
        //calls the appropriate function based on every operand called
        finalResult = add();
      } else if (opr == '-') {
        finalResult = sub();
      } else if (opr == 'x') {
        finalResult = mul();
      } else if (opr == '/') {
        finalResult = div();
      }
      preOpr = opr;
      opr = btnText;
      result = '';
    } else if (btnText == '%') {
      //calculate percentage
      result = numOne / 100;
      finalResult = doesContainDecimal(result);
    } else if (btnText == '.') {
      //adds decimal
      if (!result.toString().contains('.')) {
        result = result.toString() + '.';
      }
      finalResult = result;
    } else if (btnText == '+/-') {
      //adds negative value
      result.toString().startsWith('-') //if else statement
          ? result = result.toString().substring(1) //removes minus sign
          : result = '-' + result.toString(); //adds minus sign
      finalResult = result;
    } else {
      result = result + btnText;
      finalResult = result;
    }

    setState(() {
      //updates the displayed number according to the calculations
      text = finalResult;
    });
  }

  //functionality
  //add function
  String add() {
    result = (numOne + numTwo).toString(); //stores value in result
    numOne = double.parse(
        result); //stores result value in numOne incase its to be used in further calculations
    return doesContainDecimal(
        result); //returns value and checks if it conains a decimal point
  }

  //subtract function
  //uses logic similar to add, difference is in the operator
  String sub() {
    result = (numOne - numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  //multiply function
  //uses logic similar to add, difference is in the operator
  String mul() {
    result = (numOne * numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  //divide function
  //uses logic similar to add, difference is in the operator
  String div() {
    result = (numOne / numTwo).toString();
    numOne = double.parse(result);
    return doesContainDecimal(result);
  }

  //function to check if decimal exists
  String doesContainDecimal(dynamic result) {
    if (result.toString().contains('.')) {
      List<String> splitDecimal =
          result.toString().split('.'); //splits according to decimal point
      if (!(int.parse(splitDecimal[1]) > 0))
        return result = splitDecimal[0].toString();
    }
    return result;
  }
}
