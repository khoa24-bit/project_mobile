import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Lịch sử vé")),
      body: Center(
        child: Text("Lịch sử sử dụng vé sẽ hiển thị ở đây."),
      ),
    );
  }
}
