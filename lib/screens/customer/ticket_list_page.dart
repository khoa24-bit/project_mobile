import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart' as qr;

class TicketListPage extends StatefulWidget {
  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  final List<Map<String, dynamic>> tickets = [
    {"type": "Xe khách đỏ", "remaining": 5, "qrData": "RED12345"},
    {"type": "Xe khách xanh", "remaining": 3, "qrData": "BLUE67890"},
    {"type": "Xe khách vàng", "remaining": 2, "qrData": "YELLOW54321"},
  ];

  bool isBuyingTicket = false;
  int ticketCount = 1;
  String selectedTransport = "Xe buýt xanh";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isBuyingTicket ? "Mua vé" : "Vé của tôi"),
        backgroundColor: Colors.blue,
        leading: isBuyingTicket
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    isBuyingTicket = false;
                  });
                },
              )
            : null,
      ),
      body: isBuyingTicket ? buildBuyTicketScreen() : buildTicketListScreen(),
    );
  }

  /// Danh sách vé hiện có
  Widget buildTicketListScreen() {
    return Column(
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
                  onTap: () => showTicketDetail(tickets[index]),
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
                setState(() {
                  isBuyingTicket = true;
                });
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
    );
  }

  /// Chi tiết vé với QR Code
 void showTicketDetail(Map<String, dynamic> ticket) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Chi tiết vé"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ticket["type"], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white, // Nền trắng để QR Code rõ hơn
                child: SizedBox(
                  width: 200, // Đặt kích thước cụ thể cho QR Code
                  height: 200,
                  child: qr.QrImageView(
                    data: ticket["qrData"] ?? "UNKNOWN",
                    version: qr.QrVersions.auto,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Mã vé: ${ticket["qrData"]}", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text("Số vé còn lại: ${ticket["remaining"]}", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Đóng"),
          ),
        ],
      );
    },
  );
}




  /// Giao diện mua vé
  Widget buildBuyTicketScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Lưu ý:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 8),
          Text(
            "Trước khi mua vé, vui lòng kiểm tra chuyến đi để xác định số lượng vé cần mua!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Chọn loại phương tiện:", style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedTransport,
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                    items: ["Xe buýt xanh", "Xe khách", "Tàu hỏa"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTransport = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Số vé cần mua", style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (ticketCount > 1) ticketCount--;
                          });
                        },
                      ),
                      Text("${ticketCount.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            ticketCount++;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // Xử lý logic mua vé tại đây
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      child: Text("Mua vé", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
