import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/screens/auth/login_page.dart'; // Import đúng trang login
import 'package:mobile/providers/user_provider.dart'; // Import UserProvider

class AccountPage extends StatefulWidget {
  final String token;

  AccountPage({required this.token});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isEditing = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/user/info'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userInfo = json.decode(utf8.decode(response.bodyBytes));
        // Cập nhật thông tin người dùng vào UserProvider
        context.read<UserProvider>().updateUserInfo(
          _nameController.text,
          _emailController.text,
          _phoneController.text,
        );
        setState(() {
          _nameController.text = userInfo['fullName'] ?? '';
          _emailController.text = userInfo['email'] ?? '';
          _phoneController.text = userInfo['phone'] ?? '';
        });
      } else {
        print('Lỗi lấy thông tin người dùng: ${response.body}');
      }
    } catch (e) {
      print('Lỗi kết nối API: $e');
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/user/update'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fullName': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật thành công!')));
        // Cập nhật lại thông tin người dùng trong UserProvider
        context.read<UserProvider>().updateUserInfo(
          _nameController.text,
          _emailController.text,
          _phoneController.text,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật thất bại!')));
      }
    } catch (e) {
      print('Lỗi khi cập nhật: $e');
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin tài khoản',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                if (isEditing) {
                  _updateUserInfo();
                }
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (isEditing) {
                  // Pick an image if editing
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/avatar.png'), // Ảnh cố định từ bộ nhớ
              ),
            ),
            SizedBox(height: 10),
            Text(
              _nameController.text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildInputField('Họ và tên', Icons.person, _nameController),
            _buildInputField('Email', Icons.email, _emailController),
            _buildInputField('Số điện thoại', Icons.phone, _phoneController),
            SizedBox(height: 20),
            if (isEditing) 
              _buildButton('Cập nhật', Colors.green),
            SizedBox(height: 20),
            _buildLogoutButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label (*)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              prefixIcon: Icon(icon),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isEditing) {
            _updateUserInfo();
          }
          isEditing = !isEditing;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'Đăng xuất',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
