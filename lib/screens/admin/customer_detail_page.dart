import 'package:flutter/material.dart';

class CustomerDetailPage extends StatelessWidget {
  final Map<String, String> customer;

  const CustomerDetailPage({super.key, required this.customer});

  Widget statCard(String label, String value, {Color valueColor = Colors.red}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF0D5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final String name = customer['name'] ?? 'Tên khách hàng';
    final String id = customer['id'] ?? '0000';
    final String email = customer['email'] ?? 'abcxyz@gmail.com';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header với nền xanh và avatar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF2979FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: const CircleAvatar(
                      radius: 47,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "ID: $id",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Email: $email",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Nội dung thống kê
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    statCard("Số vé còn lại", "0"),
                    statCard("Số vé đã sử dụng trong tháng", "25", valueColor: Colors.blue),
                    statCard("Tổng số vé đã sử dụng", "25", valueColor: Colors.blue),

                    const Spacer(),

                    // Nút xóa
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.redAccent, Colors.deepOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Xác nhận"),
                              content: const Text("Bạn có chắc muốn xóa khách hàng này không?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Hủy"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Xử lý xóa
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Xóa",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            "Xóa khách hàng",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
