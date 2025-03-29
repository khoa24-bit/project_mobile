import 'package:flutter/material.dart';
import 'ticket_list_page.dart';
import 'history_page.dart';
import 'account_page.dart';

class CustomerHomePage extends StatefulWidget {
  final int initialIndex;

  CustomerHomePage({this.initialIndex = 0});

  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages.clear();
    _pages.addAll([
      CustomerHomeContent(onTicketPressed: () => _onTabTapped(1)), // Truyền callback
      TicketListPage(),
      HistoryPage(),
      AccountPage(),
    ]);
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
      body: _pages[_currentIndex],
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
  final VoidCallback onTicketPressed;

  CustomerHomeContent({required this.onTicketPressed});

  @override
  Widget build(BuildContext context) {
    Map<String, int> usedTickets = {
      "Xe khách đỏ": 15,
      "Xe khách xanh": 7,
      "Xe khách vàng": 3,
    };

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(),
          SizedBox(height: 40),
          _buildInfoCard("Số vé còn lại của bạn:", {"Tổng vé": 0}),
          SizedBox(height: 25),
          _buildInfoCard("Số vé sử dụng trong tháng", usedTickets),
          SizedBox(height: 30),
          _buildTicketButton("Vé của tôi", onTicketPressed), // Gọi callback
          SizedBox(height: 20),
        ],
      ),
    );
  }
}


Widget _buildHeader() {
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
        SizedBox(height: 15),
        Text(
          "Trần Công Khoa",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
  );
}

Widget _buildInfoCard(String title, Map<String, int> ticketData) {
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
          Column(
            children: ticketData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "${entry.value} vé",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTicketButton(String text, VoidCallback onPressed) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber[700],
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    ),
  );
}
