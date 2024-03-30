import 'package:flutter/material.dart';

Widget myButton(
    BuildContext context, String text, Function function, double widthRatio) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    width: MediaQuery.of(context).size.width * widthRatio,
    child: ElevatedButton(
      onPressed: () {
        function();
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget myRactanButton(BuildContext context, String text, Function function,
    double widthRatio, Color colors) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    width: MediaQuery.of(context).size.width * widthRatio,
    child: ElevatedButton(
      onPressed: () {
        function();
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
