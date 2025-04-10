import 'package:flutter/material.dart';
import 'register_page.dart';
import 'package:mobile/screens/customer/customer_home_page.dart';
import 'package:mobile/screens/driver/driver_home_page.dart';
import 'package:mobile/screens/admin/admin_home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Trạng thái loading khi đăng nhập

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _login() async {
  String account = _accountController.text.trim();
  String password = _passwordController.text.trim();

  if (account.isEmpty || password.isEmpty) {
    _showDialog("Lỗi", "Vui lòng nhập đầy đủ thông tin!");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  final url = 'http://localhost:8080/auth/login';

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      "email": account,
      "password": password,
    }),
  );

  setState(() {
    _isLoading = false;
  });

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    String token = data['token'];
    String role = data['role'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);

    // Điều hướng đến trang tương ứng
    if (role == 'CUSTOMER') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomerHomePage(token: token)),
      );
    } else if (role == 'DRIVER') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverHomePage(token: token)),
      );
    } else if (role == 'ADMIN') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    }
  } else {
    _showDialog("Lỗi", "Sai tài khoản hoặc mật khẩu!");
  }
}

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue[50], // Màu nền nhẹ nhàng
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon logo ứng dụng
              Icon(Icons.lock_person, size: 80, color: Colors.blue[600]),
              SizedBox(height: 10),
              Text(
                "Đăng nhập",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 25),

              // Ô nhập tài khoản
              _buildTextField("Tài khoản", Icons.person, _accountController, false),
              SizedBox(height: 15),

              // Ô nhập mật khẩu
              _buildTextField("Mật khẩu", Icons.lock, _passwordController, true, isPassword: true),
              SizedBox(height: 20),

              // Nút đăng nhập
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Đăng nhập", style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                },
                child: Text(
                  "Quên mật khẩu?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),


              // Chuyển hướng đến trang đăng ký
              Text("Bạn chưa có tài khoản?", style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text("Đăng ký tài khoản mới tại đây!", style: TextStyle(color: Colors.blue, fontSize: 16)),
              ),
              SizedBox(height: screenHeight * 0.05), // Giúp bố cục không quá sát đáy
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, bool obscure, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[600]),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blue[600],
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
