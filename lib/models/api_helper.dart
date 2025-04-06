import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String baseUrl = 'http://localhost:8080'; // URL của API

  // Lấy danh sách vé từ API
  static Future<List<Map<String, dynamic>>> fetchTickets() async {
    final url = Uri.parse('$baseUrl/tickets'); // URL API lấy danh sách vé
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((ticket) => ticket as Map<String, dynamic>).toList();
    } else {
      throw Exception('Không thể lấy danh sách vé');
    }
  }

  // Mua vé
  static Future<bool> buyTicket(String transportType, int ticketCount) async {
    final url = Uri.parse('$baseUrl/buy_ticket');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'transportType': transportType,
        'ticketCount': ticketCount,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Mua vé thành công
    } else {
      throw Exception('Không thể mua vé');
    }
  }
}
