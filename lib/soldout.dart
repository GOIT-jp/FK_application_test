import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'env.dart';

// 日付時刻をフォーマットするユーティリティ関数
String formatDateTime(String dateTimeStr) {
  DateTime dateTime = DateTime.parse(dateTimeStr);
  return DateFormat('yyyy-MM-dd-HH:mm').format(dateTime);
}

// 売り切れ商品のページを表すステートフルウィジェット
class SoldOutPage extends StatefulWidget {
  // ウィジェットのコンストラクタにkeyパラメータを追加
  const SoldOutPage({Key? key}) : super(key: key);

  @override
  _SoldOutPageState createState() => _SoldOutPageState();
}

// _SoldOutPageStateクラス: SoldOutPageの状態を管理します。
class _SoldOutPageState extends State<SoldOutPage> {
  // 出店者名を入力するためのテキストフィールドコントローラ
  final TextEditingController _sellerNameController = TextEditingController();
  // 売り切れ商品リストを保持するリスト
  List<dynamic> soldOutList = [];

  @override
  void dispose() {
    // コントローラのリソースを解放
    _sellerNameController.dispose();
    super.dispose();
  }

  // 売り切れ商品データをフェッチする非同期関数
  Future<void> fetchSoldOut() async {
    try {
      var response = await http.post(
        Uri.parse(Env.pass4),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'SellerName': _sellerNameController.text}),
      );

      // printステートメントの使用を避け、代わりにロギングフレームワークを使用
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          soldOutList = data; // 直接dataを使用
        });
      } else {
        // エラー処理
      }
    } catch (e) {
      // 例外処理
    }
  }

  @override
  Widget build(BuildContext context) {
    // UIの構築
    return Scaffold(
      appBar: AppBar(
        title: const Text('売上情報'),
        leading: IconButton(
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
            onPressed: fetchSoldOut,
            child: const Text('表示'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: soldOutList.length,
              itemBuilder: (context, index) {
                var item = soldOutList[index];
                String formattedTime = formatDateTime(item['SoldoutTime']);
                return ListTile(
                  title: Text(item['ProductName']),
                  subtitle: Text('価格: ${item['Price']}'),
                  trailing: Text('売上時間: $formattedTime'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
