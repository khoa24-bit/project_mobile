import 'package:flutter/material.dart';
import './screens/auth/login_page.dart';
import './screens/customer/customer_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // home: CustomerHomePage(),
    );
  }
}