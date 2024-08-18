// import 'dart:ffi';
import 'package:calculator/buttons_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = ""; // 0 until 9
  String operand = ""; // + - * % /
  String num2 = ""; // 0 until 9
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            /*outputs*/
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "$num1$operand$num2".isEmpty ? "0" : "$num1$operand$num2",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            /*buttons*/
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                        width: value == Btn.n0
                            ? screenSize.width / 2
                            : (screenSize.width / 4),
                        height: screenSize.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
          color: getBtnColor(value),
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white24),
              borderRadius: BorderRadius.circular(100)),
          child: InkWell(
              onTap: () => onBtnTap(value),
              child: Center(
                  child: Text(
                value,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )))),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.per) {
      convertToPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }


  void calculate() {
    if (num1.isEmpty) return;
    if (operand.isEmpty) return;
    if (num2.isEmpty) return;

    final double N1 = double.parse(num1);
    final double N2 = double.parse(num2);
    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = N1 + N2;
        break;
      case Btn.substract:
        result = N1 - N2;
        break;
      case Btn.multiply:
        result = N1 * N2;
        break;
      case Btn.divide:
        result = N1 / N2;
        break;
      default:
    }
    setState(() {
      num1 = "$result";
      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }
      operand = "";
      num2 = "";
    });
  }

  //convert outputs to %
  void convertToPercentage() {
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      //calculate befor conversion
      calculate();
    }
    if (operand.isNotEmpty) {
      // connot br converted
      return;
    }
    final num = double.parse(num1);
    setState(() {
      num1 = "${(num / 100)}";
      operand = "";
      num2 = "";
    });
  }

  //clear all outputs
  void clearAll() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

  //delete outputs one by one
  void delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
    setState(() {});
  }


  
  void appendValue(String value) {
    //if is operand and not dot "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      //operand pressed
      if (operand.isNotEmpty && num2.isNotEmpty) {
        //TODO calculate the equation before assigning new operand
        calculate();
      }
      operand = value;
    }
    //assign value to number1 variable
    else if (num1.isEmpty || operand.isEmpty) {
      //check if value is "."|exemple:"1.2"
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && num1.isEmpty || num1 == Btn.dot) {
        value = "0.";
      }
      num1 += value;
    }
    //assign value to number2 variable
    else if (num2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && num2.isEmpty || num2 == Btn.dot) {
        value = "0.";
      }
      num2 += value;
    }

    setState(() {});
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.add,
            Btn.substract,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black;
  }
}
