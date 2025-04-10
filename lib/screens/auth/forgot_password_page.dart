import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp_verification_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _sendOTP() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showDialog("Lỗi", "Vui lòng nhập email.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8080/auth/send-otp"), // Đã sửa
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(email: email),
          ),
        );
      } else {
        final body = json.decode(utf8.decode(response.bodyBytes));
        _showDialog("Lỗi", body["message"] ?? "Không thể gửi OTP. Vui lòng thử lại.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showDialog("Lỗi", "Đã xảy ra lỗi khi gửi yêu cầu. Vui lòng kiểm tra kết nối.");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quên mật khẩu")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Nhập email để nhận mã OTP", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                ),
                keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            Center(
                child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Nút màu xanh
                    foregroundColor: Colors.white, // Chữ trắng
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                            ),
                        )
                        : Text("Gửi OTP"),
                ),
                ),

            ],
        ),
      ),
    );
  }
}
