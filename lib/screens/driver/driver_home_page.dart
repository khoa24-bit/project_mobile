import 'package:flutter/material.dart';

class DriverHomePage extends StatelessWidget {
  final String token;

  DriverHomePage({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trang tài xế')),
      body: Center(child: Text('Token: $token')),
    );
  }
}
