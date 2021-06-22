import 'package:flutter/material.dart';

import '../locator.dart';
import '../state/user_store.dart';
import '../data/model/user.dart';
import './widgets/daily_work_paged_listview.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          TextButton(
              onPressed: () {
                getIt.get<UserStore>().logout();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
      body: DailyWorkPagedListView(),
    );
  }
}
