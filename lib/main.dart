import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobix_and_provider/locator.dart';
import 'pages/landing_page.dart';

// This should be used while in development mode,
// remove this when you want to release to production,
// the aim of this fix is to make the development a bit easier,
// for production, you need to fix your certificate issue and use it properly,
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: FlutterMobx(),
    );
  }
}
