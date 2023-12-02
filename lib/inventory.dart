import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'env.dart';

String formatDateTime(String dateTimeStr) {
  DateTime dateTime = DateTime.parse(dateTimeStr);
  return DateFormat('yyyy-MM-dd-HH:mm').format(dateTime);
}

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _sellerNameController = TextEditingController();
  List<dynamic> inventoryList = [];

  @override
  void dispose() {
    _sellerNameController.dispose();
    super.dispose();
  }

  Future<void> fetchInventory() async {
    var response = await http.post(
      Uri.parse(Env.pass3),
      body: json.encode({'SellerName': _sellerNameController.text}),
    );

    if (response.statusCode == 200) {
      setState(() {
        inventoryList = json.decode(response.body);
      });
    } else {
      // エラーハンドリング
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('在庫情報'),
        leading: IconButton(
          // AppBarの左側にIconButtonを配置
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/form'); // '/form'へのルーティング
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _sellerNameController,
              decoration: const InputDecoration(
                labelText: '出店者名',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: fetchInventory,
            child: const Text('表示'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inventoryList.length,
              itemBuilder: (context, index) {
                var item = inventoryList[index];
                String formattedTime = formatDateTime(item['RegisteredTime']);
                return ListTile(
                  title: Text(item['ProductName']),
                  subtitle: Text('価格: ${item['Price']}'),
                  trailing: Text('登録時間: $formattedTime'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
