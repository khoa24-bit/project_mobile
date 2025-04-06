import 'package:flutter/material.dart';
import '../customer/account_page.dart';
import 'customer_list_page.dart';
import 'driver_detail_page.dart';
import 'driver_list_page.dart';

class AdminHomePage extends StatelessWidget {
  final String token;
  AdminHomePage({required this.token});


  Widget statCard(String label, String value,
      {double width = double.infinity}) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFDF0D5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tiêu đề màu xanh có icon ở góc trên cùng
            Stack(
              children: [
                Container(
                  height: 310,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2979FF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(height: 30),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "ADMIN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Icon account ở góc phải trên cùng
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.account_circle_outlined,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CustomerListPage()),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Nội dung thống kê
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  children: [
                    statCard("Số vé bán được trong ngày", "120"),
                    statCard("Số vé đã quét trong ngày", "150"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CustomerListPage()),
                              );
                            },
                            child: statCard("Tổng số khách hàng", "3454"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const DriverListPage()),
                              );
                            },
                            child: statCard("Tổng số tài xế", "23"),
                          ),
                        ),
                      ],
                    ),
                    statCard("Doanh thu của tháng", "150"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
