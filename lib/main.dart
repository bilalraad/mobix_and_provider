import 'package:flutter/material.dart';
import './data/user_repository.dart';
import './pages/login_page.dart';
import './state/user_store.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Provider(
        create: (_) => UserStore(FakeUserRepository()),
        child: LoginPage(),
      ),
    );
  }
}
