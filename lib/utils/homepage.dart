import 'package:flutter/material.dart';
import 'package:notodo/utils/homebody.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: new Text("No To-Do"),
      ),
      body: new noToDoScreen(),
      
      backgroundColor: Colors.grey.shade900,
      
      
    );
  }
}