import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart' as qr;

class TicketListPage extends StatefulWidget {
  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  /// Danh sách các loại phương tiện
  final List<String> transportOptions = [
    "Xe khách đỏ",
    "Xe khách xanh",
    "Xe khách vàng",
    "Xe buýt xanh",
    "Xe buýt đỏ",
    "Tàu hỏa",
    "Máy bay",
    "Taxi",
  ];

  /// Danh sách vé có sẵn
  final List<Map<String, dynamic>> tickets = [
    {"type": "Xe khách đỏ", "remaining": 5, "qrData": "RED12345"},
    {"type": "Xe khách xanh", "remaining": 3, "qrData": "BLUE67890"},
    {"type": "Xe khách vàng", "remaining": 2, "qrData": "YELLOW54321"},
    {"type": "Xe buýt đỏ", "remaining": 10, "qrData": "BUSRED0001"},
    {"type": "Tàu hỏa", "remaining": 15, "qrData": "TRAIN98765"},
  ];

  bool isBuyingTicket = false;
  int ticketCount = 1;
  String selectedTransport = "Xe khách đỏ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Padding(
    padding: EdgeInsets.only(top: 10, bottom: 5), // Lùi xuống 10px
    child: Text(
      isBuyingTicket ? "Mua vé" : "Vé của tôi",
      style: TextStyle(fontSize: 30, color: Colors.black),
    ),
  ),
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
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 8),
          Text(
            "Trước khi mua vé, vui lòng kiểm tra chuyến đi để xác định số lượng vé cần mua!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
          ),
          SizedBox(height: 20),
          Card(
            color: Color(0xFFE0E0E0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Chọn loại phương tiện:", style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
  value: selectedTransport,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),
  ),
  items: transportOptions.map((option) {
    return DropdownMenuItem(
      value: option, // Loại bỏ việc đặt giá trị null
      child: Text(option),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedTransport = value!;
    });
  },
  borderRadius: BorderRadius.circular(12),
  menuMaxHeight: 200,
),

                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Số vé cần mua", style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(height: 10),
                  Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    /// Nút "-" có border
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5), // Viền màu xám nhạt
        borderRadius: BorderRadius.circular(8), // Bo góc 8px
      ),
      child: IconButton(
        icon: Icon(Icons.remove, color: Colors.black),
        onPressed: () {
          setState(() {
            if (ticketCount > 1) ticketCount--;
          });
        },
      ),
    ),
    SizedBox(width: 15),

    /// Hiển thị số lượng vé
    Text("${ticketCount.toString().padLeft(2, '0')}", style: TextStyle(fontSize: 22)),

    SizedBox(width: 15),

    /// Nút "+" có border
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5), // Viền màu xám nhạt
        borderRadius: BorderRadius.circular(8), // Bo góc 8px
      ),
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          setState(() {
            ticketCount++;
          });
        },
      ),
    ),
  ],
),

                  SizedBox(height: 16),
                  ElevatedButton(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.blue[700]!; // Khi bấm, màu xanh đậm hơn
      } else if (states.contains(MaterialState.hovered)) {
        return Colors.blue[300]!; // Khi di chuột vào (chỉ trên web)
      }
      return Colors.blue; // Mặc định
    }),
    padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  onPressed: () {
    // Xử lý logic mua vé
  },
  child: Text("Mua vé", style: TextStyle(fontSize: 16, color: Colors.white)),
)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
