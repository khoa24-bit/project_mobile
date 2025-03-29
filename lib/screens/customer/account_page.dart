import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Tài khoản")),
      body: Center(
        child: Text("Thông tin tài khoản của bạn sẽ hiển thị ở đây."),
      ),
    );
  }
}
