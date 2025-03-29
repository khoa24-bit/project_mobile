import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, String>> tickets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTicketHistory();
  }

  /// Hàm giả lập lấy dữ liệu lịch sử vé (dữ liệu tĩnh)
  Future<void> fetchTicketHistory() async {
    await Future.delayed(Duration(seconds: 0.5)); // Giả lập độ trễ API
    setState(() {
      tickets = [
        {
          'type': 'Xe khách đỏ',
          'used_at': '2025-03-28T08:30:00Z',
        },
        {
          'type': 'Tàu hỏa',
          'used_at': '2025-03-25T14:00:00Z',
        },
        {
          'type': 'Máy bay',
          'used_at': '2025-03-20T10:45:00Z',
        },
        {
          'type': 'Xe buýt xanh',
          'used_at': '2025-03-18T07:15:00Z',
        },
        {
          'type': 'Xe khách đỏ',
          'used_at': '2025-03-28T08:30:00Z',
        },
        {
          'type': 'Tàu hỏa',
          'used_at': '2025-03-25T14:00:00Z',
        },
        {
          'type': 'Máy bay',
          'used_at': '2025-03-20T10:45:00Z',
        },
        {
          'type': 'Xe buýt xanh',
          'used_at': '2025-03-18T07:15:00Z',
        },
        {
          'type': 'Xe khách đỏ',
          'used_at': '2025-03-28T08:30:00Z',
        },
        {
          'type': 'Tàu hỏa',
          'used_at': '2025-03-25T14:00:00Z',
        },
        {
          'type': 'Máy bay',
          'used_at': '2025-03-20T10:45:00Z',
        },
        {
          'type': 'Xe buýt xanh',
          'used_at': '2025-03-18T07:15:00Z',
        },
        {
          'type': 'Xe khách đỏ',
          'used_at': '2025-03-28T08:30:00Z',
        },
        {
          'type': 'Tàu hỏa',
          'used_at': '2025-03-25T14:00:00Z',
        },
        {
          'type': 'Máy bay',
          'used_at': '2025-03-20T10:45:00Z',
        },
        {
          'type': 'Xe buýt xanh',
          'used_at': '2025-03-18T07:15:00Z',
        },
        {
          'type': 'Xe khách đỏ',
          'used_at': '2025-03-28T08:30:00Z',
        },
        {
          'type': 'Tàu hỏa',
          'used_at': '2025-03-25T14:00:00Z',
        },
        {
          'type': 'Máy bay',
          'used_at': '2025-03-20T10:45:00Z',
        },
        {
          'type': 'Xe buýt xanh',
          'used_at': '2025-03-18T07:15:00Z',
        },
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử sử dụng vé'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị vòng tròn loading khi lấy dữ liệu
          : ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                var ticket = tickets[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.directions_bus, color: Colors.blue), // Icon đại diện phương tiện
                    title: Text(
                      ticket['type'] ?? 'Không rõ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Ngày sử dụng: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(ticket['used_at']!))}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
