import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart'; // <- Thêm dòng này
import './screens/admin/admin_home_page.dart';

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
