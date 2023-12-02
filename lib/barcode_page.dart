import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_widget/barcode_widget.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'env.dart';

class BarcodePage extends StatefulWidget {
  @override
  BarcodePageState createState() => BarcodePageState();
}

class BarcodePageState extends State<BarcodePage> {
  final GlobalKey _globalKey = GlobalKey();
  final _sellerNameController = TextEditingController();
  final _productNameController = TextEditingController();
  Future<String> fetchBarcodeNumber() async {
    final requestBody = jsonEncode({
      'sellerName': _sellerNameController.text,
      'productName': _productNameController.text,
    });

    var response = await http.post(
      Uri.parse(Env.pass2),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // 最初のデコードで、JSONオブジェクトを取得します。
      var jsonResponse = jsonDecode(response.body);

      // 'body' キーに関連するエスケープされたJSON文字列をもう一度デコードします。
      var barcodeData = jsonDecode(jsonResponse['body']);

      // バーコードナンバーを取得します。
      var barcodeNumber = barcodeData['BarcodeNumber'];
      if (barcodeNumber != null) {
        return barcodeNumber;
      } else {
        throw Exception('バーコードナンバーが見つかりません。');
      }
    } else {
      throw Exception('APIからの応答が失敗しました: ステータスコード ${response.statusCode}');
    }
  }

  Future<MemoryImage> generateBarcodeImage() async {
    final RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return MemoryImage(pngBytes);
  }

  String _barcodeData = '123456789012'; // 初期値を設定

  void _updateBarcode(String barcodeNumber) {
    setState(() {
      _barcodeData = barcodeNumber; // 新しいバーコード番号で更新
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('バーコード生成'),
        leading: IconButton(
          // AppBarの左側にIconButtonを配置
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/form'); // '/form'へのルーティング
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 200.0, 8.0, 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _sellerNameController,
                decoration: const InputDecoration(labelText: '出品者名'),
              ),
              TextField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: '商品名'),
              ),
              RepaintBoundary(
                key: _globalKey,
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: _barcodeData,
                  width: 200,
                  height: 80,
                  color: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final barcodeNumber = await fetchBarcodeNumber();
                    _updateBarcode(barcodeNumber); // バーコード番号でUIを更新
                    final memoryImage = await generateBarcodeImage();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('バーコード'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Image(image: memoryImage),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    // エラー通知を表示
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('エラー'),
                        content: Text('エラーが発生しました: $e'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('生成'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
