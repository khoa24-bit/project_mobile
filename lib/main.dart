import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // <- Thêm dòng này

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TicketModel(),
      child: MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(), // <- Đổi thành SplashScreen
    );
  }
}
