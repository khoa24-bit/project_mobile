import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  final String token;

  AdminHomePage({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Quản Trị'),
        backgroundColor: Colors.red[600], // Màu nền AppBar cho phù hợp với admin
      ),
      body: Center(
        child: Text(
          'Token: $token',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Style cho token
        ),
      ),
    );
  }
}
