import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isChecked = false;

  void _register() {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showDialog("Lỗi", "Vui lòng nhập đầy đủ thông tin!");
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showDialog("Lỗi", "Mật khẩu không khớp!");
      return;
    }
    if (!_isChecked) {
      _showDialog("Lỗi", "Bạn phải xác nhận không phải robot!");
      return;
    }

    _showDialog("Thành công", "Đăng ký thành công!");
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
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text("Đăng ký"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.app_registration, size: 80, color: Colors.blue[600])),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Tạo tài khoản mới",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                ),
              ),
              SizedBox(height: 15),

              // Họ và tên
              _buildTextField("Họ và tên (*)", Icons.person, _nameController, false),
              SizedBox(height: 10),

              // Email
              _buildTextField("Email bạn sử dụng (*)", Icons.email, _emailController, false),
              SizedBox(height: 10),

              // Mật khẩu
              _buildTextField("Mật khẩu (*)", Icons.lock, _passwordController, true, isPassword: true),
              SizedBox(height: 10),

              // Nhập lại mật khẩu
              _buildTextField("Nhập lại mật khẩu (*)", Icons.lock, _confirmPasswordController, true, isPassword: true, isConfirmPassword: true),
              SizedBox(height: 15),

              // Checkbox xác nhận
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  Text("Tôi không phải người máy", style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 20),

              // Nút đăng ký
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Đăng ký", style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Giúp bố cục không quá sát đáy
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, bool obscure, {bool isPassword = false, bool isConfirmPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? (!_isPasswordVisible) : (isConfirmPassword ? !_isConfirmPasswordVisible : false),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[600]),
        suffixIcon: isPassword || isConfirmPassword
            ? IconButton(
                icon: Icon(
                  isPassword
                      ? (_isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                      : (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  color: Colors.blue[600],
                ),
                onPressed: () {
                  setState(() {
                    if (isPassword) {
                      _isPasswordVisible = !_isPasswordVisible;
                    } else {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    }
                  });
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
