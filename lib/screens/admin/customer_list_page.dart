import 'package:flutter/material.dart';
import 'customer_detail_page.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = List.generate(20, (index) => {
      "id": "23",
      "name": "Trần Công Khoa",
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách khách hàng"),
        backgroundColor: Color(0xFF2979FF),
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                columnWidths: const {
                  0: FixedColumnWidth(60),
                  1: FixedColumnWidth(50),
                  2: FlexColumnWidth(),
                  3: FixedColumnWidth(80),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xFFD6CDCD),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("STT", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Tên Khách hàng", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(""),
                      ),
                    ],
                  ),
                  ...customers.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    var customer = entry.value;
                    return TableRow(
                      decoration: BoxDecoration(
                        color: index.isOdd ? Colors.grey.shade100 : Colors.white,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("$index"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(customer["id"]!),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(customer["name"]!),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: InkWell(
                            child: Text(
                              "Chi tiết",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,

                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerDetailPage(
                                    customer: customer,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
