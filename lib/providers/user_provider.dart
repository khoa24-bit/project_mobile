import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  String fullName = '';
  String email = '';
  String phone = '';

  void updateUserInfo(String newFullName, String newEmail, String newPhone) {
    fullName = newFullName;
    email = newEmail;
    phone = newPhone;
    notifyListeners(); // Thông báo cho các widget lắng nghe cập nhật
  }
}
