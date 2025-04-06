import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TicketListPage extends StatefulWidget {
  final String token;

  const TicketListPage({Key? key, required this.token}) : super(key: key);

  @override
  State<TicketListPage> createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  String? _selectedTicketType;
  bool _isLoading = false;

  final List<String> ticketTypes = ['STANDARD', 'VIP', 'STUDENT'];

  Future<void> buyTicket() async {
    if (_selectedTicketType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn loại vé!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final token = widget.token;
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng đăng nhập để mua vé!")),
      );
      setState(() => _isLoading = false);
      return;
    }

    final url = Uri.parse("http://localhost:8080/user/buy-ticket");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ticketType': _selectedTicketType}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Mua vé thành công"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Mã vé: ${responseData['ticketId']}"),
                const SizedBox(height: 10),
                Image.memory(
                  base64Decode(responseData['qrCode']),
                  width: 150,
                  height: 150,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Đóng"),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Lỗi mua vé")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kết nối: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  Widget _buildTicketOption(String type) {
    IconData icon;
    switch (type) {
      case 'VIP':
        icon = Icons.workspace_premium;
        break;
      case 'STUDENT':
        icon = Icons.school;
        break;
      default:
        icon = Icons.confirmation_num;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: RadioListTile<String>(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        value: type,
        groupValue: _selectedTicketType,
        onChanged: (value) => setState(() => _selectedTicketType = value),
        title: Text(
          type,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        secondary: Icon(icon, color: Colors.blue), // Đổi màu icon thành màu xanh
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          title: const Text(
            'Mua vé',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          centerTitle: false,
          elevation: 0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn loại vé:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...ticketTypes.map(_buildTicketOption),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : buyTicket,
                icon: const Icon(Icons.shopping_cart_checkout, color: Colors.blue), // Đổi màu icon thành xanh
                label: const Text(
                  "Xác nhận mua vé",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black, // Đổi màu chữ thành đen
                    fontWeight: FontWeight.bold, // Chữ in đậm
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                 shape: RoundedRectangleBorder(  
            borderRadius: BorderRadius.circular(15),  
            side: BorderSide(color: Colors.black, width: 1),  
          ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
