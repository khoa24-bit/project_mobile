import 'package:flutter/material.dart';

class TicketHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lịch sử vé")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 10, // Giả lập có 10 vé trong lịch sử
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(Icons.receipt_long, color: Colors.blue),
              title: Text("Vé số ${index + 1}"),
              subtitle: Text("Ngày sử dụng: 2024-03-24"),
              trailing: Text("✔️", style: TextStyle(fontSize: 18, color: Colors.green)),
            ),
          );
        },
      ),
    );
  }
}
