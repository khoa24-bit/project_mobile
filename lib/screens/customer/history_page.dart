import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  final String token;

  HistoryPage({Key? key, required this.token}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> rideLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRideHistory();
  }

  Future<void> fetchRideHistory() async {
    final String token = widget.token;

    final response = await http.get(
      Uri.parse('http://localhost:8080/user/ride-history'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      setState(() {
        rideLogs = json.decode(decodedResponse);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Lỗi khi lấy dữ liệu: ${response.statusCode}");
      print("Body: ${response.body}");
    }
  }

  String formatDateTime(String datetimeStr) {
    final dateTime = DateTime.parse(datetimeStr);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
  }

  // Phân nhóm vé theo tháng
  Map<String, List<dynamic>> groupByMonth(List<dynamic> logs) {
    Map<String, List<dynamic>> groupedLogs = {};

    for (var log in logs) {
      final DateTime rideDate = DateTime.parse(log['rideTime']);
      final String monthKey = "${rideDate.year}-${rideDate.month.toString().padLeft(2, '0')}";

      if (groupedLogs.containsKey(monthKey)) {
        groupedLogs[monthKey]!.add(log);
      } else {
        groupedLogs[monthKey] = [log];
      }
    }

    return groupedLogs;
  }

  @override
  Widget build(BuildContext context) {
    // Nhóm theo tháng
    final groupedLogs = groupByMonth(rideLogs);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Màu nền xanh
        title: const Text(
          "Lịch sử chuyến đi",
          style: TextStyle(color: Colors.black), // Chữ màu đen
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupedLogs.isEmpty
              ? const Center(child: Text("Chưa có chuyến đi nào."))
              : ListView.builder(
                  itemCount: groupedLogs.length,
                  itemBuilder: (context, index) {
                    final monthKey = groupedLogs.keys.elementAt(index);
                    final monthLogs = groupedLogs[monthKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề tháng, không căn giữa
                        Container(
                          color: Colors.blue.shade100, // Nền màu xanh nhạt
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Tháng ${monthKey.substring(5, 7)}/${monthKey.substring(0, 4)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Danh sách vé trong tháng
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: monthLogs.length,
                          itemBuilder: (context, index) {
                            final log = monthLogs[index];
                            return Card(
                              elevation: 5, // Bóng đổ
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Bo góc
                              ),
                              child: ListTile(
                                title: Text("Tuyến: ${log['route'] ?? 'N/A'}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Tài xế: ${log['driverName'] ?? 'Không rõ'}"),
                                    Text("Thời gian: ${formatDateTime(log['rideTime'])}"),
                                  ],
                                ),
                                trailing: Text(
                                  log['status'],
                                  style: TextStyle(
                                    color: log['status'] == 'VALID' ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
