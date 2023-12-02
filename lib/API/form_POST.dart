import 'dart:convert';
import 'package:http/http.dart' as http;
import '../env.dart';

Future<void> addItemToInventory(
    String sellerName, String productName, double price) async {
  const url = Env.pass1;
  final headers = {
    'Content-Type': 'application/json',
  };

  // 内側のJSONオブジェクト
  final innerBody = jsonEncode({
    'seller_name': sellerName,
    'product_name': productName,
    'price': price,
  });

  // 期待される形式の外側のJSONオブジェクト
  final body = jsonEncode({'body': innerBody});

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      // 成功した場合の処理
      print('Item added to inventory successfully.');
    } else {
      // サーバーからエラーレスポンスが返ってきた場合の処理
      print('Failed to add item to inventory.');
    }
  } catch (e) {
    // リクエスト送信中にエラーが発生した場合の処理
    print('Error adding item to inventory: $e');
  }
}
