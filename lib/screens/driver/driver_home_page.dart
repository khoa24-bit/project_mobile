import 'package:flutter/material.dart';

class DriverHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Trang tài xế"),
        backgroundColor: Colors.green[600],
      ),
      body: Center(
        child: Text(
          "Chào mừng bạn đến với trang tài xế!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
