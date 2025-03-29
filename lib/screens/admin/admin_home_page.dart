import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Trang quản trị"),
        backgroundColor: Colors.red[600],
      ),
      body: Center(
        child: Text(
          "Chào mừng bạn đến với trang quản trị!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
