import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPVerificationPage extends StatefulWidget {
  final String email;
  OTPVerificationPage({required this.email});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _resetPassword() async {
    final newPassword = _newPasswordController.text.trim();
    final otp = _otpController.text.trim();

    if (otp.isEmpty || newPassword.isEmpty) {
      _showDialog("Lỗi", "Vui lòng nhập đủ thông tin.");
      return;
    }

    if (!isValidPassword(newPassword)) {
      _showDialog("Lỗi", "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
      return;
    }

    setState(() => _isLoading = true);

    final response = await http.post(
      Uri.parse("http://localhost:8080/auth/reset-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": widget.email,
        "otp": otp,
        "newPassword": newPassword,
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      _showDialog("Thành công", "Đổi mật khẩu thành công. Hãy đăng nhập lại.", closeAfter: true);
    } else {
      final body = json.decode(utf8.decode(response.bodyBytes));
      _showDialog("Lỗi", body["message"] ?? "OTP không hợp lệ hoặc đã hết hạn.");
    }
  }

  bool isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{6,}$');
    return passwordRegex.hasMatch(password);
  }

  void _showDialog(String title, String message, {bool closeAfter = false}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (closeAfter) Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Xác thực OTP")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Nhập mã OTP đã gửi về email", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: "Mã OTP",
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            TextField(
              controller: _newPasswordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Mật khẩu mới",
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1)),
              ),
            ),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text("Đặt lại mật khẩu"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
