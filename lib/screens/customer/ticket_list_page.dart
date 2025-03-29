import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart' as qr;
import 'ticket_page.dart';
import 'customer_home_page.dart';


class TicketListPage extends StatelessWidget {
  final List<Map<String, dynamic>> tickets = [
    {"type": "Xe khách đỏ", "remaining": 5, "qrData": "RED12345"},
    {"type": "Xe khách xanh", "remaining": 3, "qrData": "BLUE67890"},
    {"type": "Xe khách vàng", "remaining": 2, "qrData": "YELLOW54321"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vé của tôi"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      tickets[index]["type"],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Số vé còn lại: ${tickets[index]["remaining"]}"),
                    trailing: Icon(Icons.qr_code, color: Colors.blue),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketDetailPage(ticket: tickets[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => CustomerHomePage(initialIndex: 2)),
                        (route) => false,
                    );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text("Mua vé", style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketDetailPage extends StatelessWidget {
  final Map<String, dynamic> ticket;

  TicketDetailPage({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết vé"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ticket["type"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            qr.QrImageView(
                data: ticket["qrData"],
                version: qr.QrVersions.auto,
                size: 200,
            ),

            SizedBox(height: 20),
            Text("Mã vé: ${ticket["qrData"]}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Số vé còn lại: ${ticket["remaining"]}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
