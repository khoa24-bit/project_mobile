import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../auth/login_page.dart'; // Import trang đăng nhập

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isEditing = false;
  TextEditingController _nameController = TextEditingController(text: 'Nguyễn Văn A');
  TextEditingController _emailController = TextEditingController(text: 'nguyenvana@example.com');
  TextEditingController _phoneController = TextEditingController(text: '0908765432');
  TextEditingController _dateController = TextEditingController(text: '01/01/2000');
  String? _selectedGender = 'Nam';
  File? _avatarImage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Chọn ảnh đại diện từ thư viện
  Future<void> _pickImage() async {
    if (!isEditing) return;
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  // Mở DatePicker để chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    if (!isEditing) return;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
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
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _avatarImage != null
                    ? FileImage(_avatarImage!)
                    : AssetImage('assets/images/avatar.png') as ImageProvider,
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
            _buildDatePickerField(),
            _buildGenderField(),
            SizedBox(height: 20),
            if (isEditing) _buildButton('Cập nhật', Colors.green),
            _buildLogoutButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Ô nhập ngày sinh với DatePicker
  Widget _buildDatePickerField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ngày sinh (*)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            enabled: isEditing,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              prefixIcon: Icon(Icons.cake),
            ),
          ),
        ],
      ),
    );
  }

  // Ô nhập thông tin với chế độ đọc / chỉnh sửa
  Widget _buildInputField(String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + ' (*)',
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

  // Ô chọn giới tính
  Widget _buildGenderField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giới tính (*)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            items: ['Nam', 'Nữ', 'Khác']
                .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                .toList(),
            onChanged: isEditing
                ? (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  }
                : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
        ],
      ),
    );
  }

  // Nút cập nhật thông tin
  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isEditing = false;
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

  // Nút đăng xuất
  Widget _buildLogoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: _confirmLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          'Đăng xuất',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // Hiển thị hộp thoại xác nhận đăng xuất
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Xác nhận"),
          content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Hủy")),
            TextButton(onPressed: _logout, child: Text("Đăng xuất", style: TextStyle(color: Colors.red))),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
