// form_page.dart
import 'package:flutter/material.dart';
import 'API/form_POST.dart';
import 'package:go_router/go_router.dart';

class FormPage extends StatelessWidget {
  const FormPage({Key? key}) : super(key: key); // 'key'をsuperパラメータとして使用

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品フォーム'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              context.go('/barcode'); // BarcodePageへ遷移
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 200.0), // AppBarから30pxの間隔を追加
        child: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _sellerNameController = TextEditingController();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _sellerNameController.dispose();
    _productNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: _sellerNameController,
              decoration: const InputDecoration(
                hintText: '出品者名',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '出品者名を入力してください';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: _productNameController,
              decoration: const InputDecoration(
                hintText: '商品名',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '商品名を入力してください';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                hintText: '価格',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '価格を入力してください';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('データを送信中...')),
                    );

                    await addItemToInventory(
                      _sellerNameController.text,
                      _productNameController.text,
                      double.tryParse(_priceController.text) ?? 0,
                    );
                  }
                },
                child: const Text('登録'),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.inventory),
                          onPressed: () {
                            context.go('/inventory');
                          },
                          iconSize: 40.0,
                        ),
                        const Text('在庫'),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.monetization_on),
                          onPressed: () {
                            context.go('/soldout');
                          },
                          iconSize: 40.0,
                        ),
                        const Text('売上'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
