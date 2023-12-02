// main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_application/form_page.dart'; // FormPageをインポート
import 'package:flutter_application/barcode_page.dart'; // BarcodePageをインポート
import 'package:go_router/go_router.dart';
import 'inventory.dart';
import 'soldout.dart';

void main() {
  if (kIsWeb) {
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp(),
      ),
    );
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // 修正を追加

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/form', // .dart拡張子を削除
      routes: [
        GoRoute(
          path: '/form', // .dart拡張子を削除
          builder: (context, state) => const FormPage(),
        ),
        GoRoute(
          path: '/barcode', // .dart拡張子を削除
          builder: (context, state) => BarcodePage(),
        ),
        GoRoute(
          path: '/inventory', // .dart拡張子を削除
          builder: (context, state) => InventoryPage(),
        ),
        GoRoute(
          path: '/soldout', // .dart拡張子を削除
          builder: (context, state) => const SoldOutPage(),
        ),
      ],
    );

    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      title: 'Flutter Application',
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
