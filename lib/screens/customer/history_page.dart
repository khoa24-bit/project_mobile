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
    await Future.delayed(Duration(seconds: 0)); // Giả lập độ trễ API
    setState(() {
      tickets = [
        {'type': 'Xe khách đỏ', 'used_at': '2025-03-28T08:30:00Z'},
  {'type': 'Tàu hỏa', 'used_at': '2025-03-25T14:00:00Z'},
  {'type': 'Máy bay', 'used_at': '2025-02-20T10:45:00Z'},
  {'type': 'Xe buýt xanh', 'used_at': '2025-03-18T07:15:00Z'},
  {'type': 'Xe khách đỏ', 'used_at': '2025-02-28T08:30:00Z'},
  {'type': 'Tàu hỏa', 'used_at': '2025-02-25T14:00:00Z'},
  {'type': 'Máy bay', 'used_at': '2025-01-20T10:45:00Z'},
  {'type': 'Xe buýt xanh', 'used_at': '2025-01-18T07:15:00Z'},
  {'type': 'Xe khách xanh', 'used_at': '2025-03-10T09:20:00Z'},
  {'type': 'Xe khách vàng', 'used_at': '2025-03-08T16:40:00Z'},
  {'type': 'Xe buýt đỏ', 'used_at': '2025-03-15T11:50:00Z'},
  {'type': 'Taxi', 'used_at': '2025-02-10T19:30:00Z'},
  {'type': 'Xe khách đỏ', 'used_at': '2025-01-05T06:20:00Z'},
  {'type': 'Tàu hỏa', 'used_at': '2025-01-15T13:45:00Z'},
  {'type': 'Máy bay', 'used_at': '2025-02-05T22:10:00Z'},
  {'type': 'Xe buýt xanh', 'used_at': '2025-02-18T08:55:00Z'},
  {'type': 'Xe khách đỏ', 'used_at': '2025-01-28T07:30:00Z'},
  {'type': 'Tàu hỏa', 'used_at': '2025-02-02T15:25:00Z'},
  {'type': 'Máy bay', 'used_at': '2025-01-23T12:35:00Z'},
  {'type': 'Xe buýt xanh', 'used_at': '2025-01-29T10:10:00Z'},
  {'type': 'Xe khách đỏ', 'used_at': '2025-03-01T09:00:00Z'},
  {'type': 'Xe khách xanh', 'used_at': '2025-02-15T17:00:00Z'},
  {'type': 'Xe khách vàng', 'used_at': '2025-01-10T05:45:00Z'},
  // {'type': 'Xe buýt đỏ', 'used_at': '2025-02-20T18:30:00Z'},
  {'type': 'Taxi', 'used_at': '2025-03-12T14:50:00Z'},
  {'type': 'Tàu hỏa', 'used_at': '2025-01-07T21:15:00Z'},
  {'type': 'Máy bay', 'used_at': '2025-02-25T09:40:00Z'},
  {'type': 'Xe buýt xanh', 'used_at': '2025-03-27T06:30:00Z'},
  {'type': 'Xe khách đỏ', 'used_at': '2025-02-22T13:10:00Z'},
  {'type': 'Tàu hỏa', 'used_at': '2025-03-09T12:20:00Z'},
  {'type': 'Máy bay', 'used_at': '2025-01-30T15:55:00Z'},
  {'type': 'Xe buýt xanh', 'used_at': '2025-03-05T10:00:00Z'}
];
      isLoading = false;
    });
  }

  IconData getTransportIcon(String type) {
    switch (type) {
      case 'Xe khách đỏ':
      case 'Xe khách xanh':
      case 'Xe khách vàng':
        return Icons.directions_bus;
      case 'Xe buýt xanh':
      case 'Xe buýt đỏ':
        return Icons.directions_transit;
      case 'Tàu hỏa':
        return Icons.train;
      case 'Máy bay':
        return Icons.flight;
      case 'Taxi':
        return Icons.local_taxi;
      default:
        return Icons.directions_bus;
    }
  }

  Color getTransportColor(String type) {
    switch (type) {
      case 'Xe khách đỏ':
        return Colors.red;
      case 'Xe khách xanh':
        return Colors.green;
      case 'Xe khách vàng':
        return Colors.orange;
      case 'Xe buýt xanh':
        return Colors.blue;
      case 'Xe buýt đỏ':
        return Colors.deepOrange;
      case 'Tàu hỏa':
        return Colors.brown;
      case 'Máy bay':
        return Colors.purple;
      case 'Taxi':
        return Colors.yellow[700]!;
      default:
        return Colors.grey;
    }
  }

  /// Hàm xây dựng danh sách vé được nhóm theo tháng
  List<Widget> _buildTicketListByMonth() {
  Map<String, List<Map<String, String>>> groupedTickets = {};
  for (var ticket in tickets) {
    String monthYear = DateFormat('MM/yyyy').format(DateTime.parse(ticket['used_at']!));
    if (!groupedTickets.containsKey(monthYear)) {
      groupedTickets[monthYear] = [];
    }
    groupedTickets[monthYear]!.add(ticket);
  }

  List<Widget> widgets = [];
  groupedTickets.forEach((monthYear, ticketList) {
    // Thêm tiêu đề tháng với nền màu xanh
    widgets.add(
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        color: Color(0xFF81D4FA), // Màu nền xanh
        child: Text(
          'Tháng $monthYear',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );

    for (int i = 0; i < ticketList.length; i++) {
      var ticket = ticketList[i];
      widgets.add(
        Container(
          color: (i % 2 == 0) ? Colors.white : Colors.pink[50],
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: ListTile(
            leading: Icon(
              getTransportIcon(ticket['type'] ?? ''),
              color: getTransportColor(ticket['type'] ?? ''),
              size: 30,
            ),
            title: Text(
              ticket['type'] ?? 'Không rõ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Ngày sử dụng: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(ticket['used_at']!))}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }
  });

  return widgets;
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Padding(
    padding: EdgeInsets.only(top: 10, bottom: 5), // Đẩy chữ xuống 10px
    child: Text(
      'Lịch sử sử dụng vé',
      style: TextStyle(fontSize: 30, color: Colors.black),
    ),
  ),
  backgroundColor: Colors.blue,
),

      body: isLoading
    ? Center(child: CircularProgressIndicator())
    : ListView(
        children: _buildTicketListByMonth(),
      ),

    );
  }
}