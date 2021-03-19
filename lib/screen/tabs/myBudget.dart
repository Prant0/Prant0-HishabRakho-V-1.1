import 'package:flutter/material.dart';


class MyBudget extends StatefulWidget {
  @override
  _MyBudgetState createState() => _MyBudgetState();
}

class _MyBudgetState extends State<MyBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget"),
      ),
    );
  }
}
