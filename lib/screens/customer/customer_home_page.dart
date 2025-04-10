import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ticket_list_page.dart';
import 'history_page.dart';
import 'account_page.dart';

class CustomerHomePage extends StatefulWidget {
  final int initialIndex;
  final String token;

  CustomerHomePage({this.initialIndex = 0, required this.token});

  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late int _currentIndex;
  Map<String, dynamic>? _userInfo;
  List<dynamic> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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
        setState(() {
          _userInfo = json.decode(utf8.decode(response.bodyBytes));
        });
        _fetchTickets();
      } else {
        String errorMessage = utf8.decode(response.bodyBytes);
        _showErrorDialog("Lỗi", errorMessage);
      }
    } catch (e) {
      _showErrorDialog("Lỗi", "Không thể kết nối đến máy chủ.");
    }
  }

  Future<void> _fetchTickets() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/user/tickets'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> tickets = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _tickets = tickets;
          _isLoading = false;
        });
      } else {
        String errorMessage = utf8.decode(response.bodyBytes);
        _showErrorDialog("Lỗi", errorMessage);
      }
    } catch (e) {
      _showErrorDialog("Lỗi", "Không thể kết nối đến máy chủ.");
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _currentIndex,
              children: [
                CustomerHomeContent(
                  userInfo: _userInfo,
                  tickets: _tickets,
                ),
                TicketListPage(
                  token: widget.token,
                  onTicketBought: _fetchTickets, // Gọi lại _fetchTickets khi mua vé thành công
                ),
                HistoryPage(token: widget.token),
                AccountPage(token: widget.token),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_activity), label: "Vé"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Lịch sử"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
    );
  }
}


class CustomerHomeContent extends StatelessWidget {
  final Map<String, dynamic>? userInfo;
  final List<dynamic> tickets;

  CustomerHomeContent({
    required this.userInfo,
    required this.tickets,
  });

  // Hàm nhóm các vé theo loại
  Map<String, List<dynamic>> _groupTicketsByType(List<dynamic> tickets) {
    Map<String, List<dynamic>> groupedTickets = {};

    for (var ticket in tickets) {
      String ticketType = ticket['ticketType'];
      if (!groupedTickets.containsKey(ticketType)) {
        groupedTickets[ticketType] = [];
      }
      groupedTickets[ticketType]?.add(ticket);
    }

    // Sắp xếp vé trong mỗi nhóm theo id (tăng dần) để lấy vé có id nhỏ nhất
    groupedTickets.forEach((key, value) {
      value.sort((a, b) => a['id'].compareTo(b['id']));
    });

    return groupedTickets;
  }

  // Hiển thị chi tiết mã QR của vé có id nhỏ nhất trong nhóm
  void _showTicketDetail(BuildContext context, List<dynamic> groupedTickets) {
    var ticket = groupedTickets.first; // Lấy vé có id nhỏ nhất
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Chi tiết vé"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Loại vé: ${ticket['ticketType']}"),
            Text("Mã vé: ${ticket['id']}"),
            SizedBox(height: 10),
            ticket['qrCode'] != null
                ? Image.memory(base64Decode(ticket['qrCode']))
                : Text("Không có mã QR"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nhóm vé theo loại
    Map<String, List<dynamic>> groupedTickets = _groupTicketsByType(tickets);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(userInfo),
          SizedBox(height: 20),
          _buildInfoCard("Tổng số vé hiện có", tickets.length),
          SizedBox(height: 20),
          groupedTickets.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Bạn chưa có vé nào", style: TextStyle(fontSize: 18)),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: groupedTickets.keys.map((ticketType) {
                      List<dynamic> ticketGroup = groupedTickets[ticketType]!;

                      return Card(
                        margin: EdgeInsets.only(bottom: 15),
                        child: ListTile(
                          title: Text("Loại vé: $ticketType", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mã vé: ${ticketGroup.first['id']}"),
                              // SizedBox(height: 4),
                              Text("Số vé còn lại: ${ticketGroup.length}"),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _showTicketDetail(context, ticketGroup),
                            child: Text("Xem mã QR"),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}


Widget _buildHeader(Map<String, dynamic>? userInfo) {
  return Container(
    width: double.infinity,
    height: 270,
    padding: EdgeInsets.only(top: 20),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/avatar.png'),
        ),
        SizedBox(height: 5),
        Text(
          userInfo != null ? userInfo['fullName'] ?? "Người dùng" : "Đang tải...",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        //SizedBox(height: 10),
        userInfo != null
            ? Align(
                alignment: Alignment.center,  // Căn phải toàn bộ phần tử dưới
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,  // Căn phải cho text bên trong Column
                  children: [
                    // Text(
                    //   "ID: ${userInfo['id']}",
                    //   style: TextStyle(fontSize: 20, color: Color(0xFFCCCCCC)),  // Màu #DDDDDD
                    // ),
                    Text(
                      "Email: ${userInfo['email']}",
                      style: TextStyle(fontSize: 16, color: Color(0xFFCCCCCC)),  // Màu #DDDDDD
                    ),
                    //SizedBox(height: 5),  // Thêm một chút khoảng cách giữa email và id
                    
                  ],
                ),
              )
            : Container(),
      ],
    ),
  );
}

Widget _buildInfoCard(String title, int totalTickets) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Số lượng vé", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              Text("$totalTickets vé", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
        ],
      ),
    ),
  );
}
  