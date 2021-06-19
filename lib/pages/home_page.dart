import 'package:flutter/material.dart';
import '../data/model/daily_work.dart';
import '../data/model/user.dart';
import '../state/daily_work_store.dart';
import '../state/user_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DailyWorkStore? _dailyWorkStore;
  late List<ReactionDisposer> _disposers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dailyWorkStore ??= Provider.of<DailyWorkStore>(context);
    _dailyWorkStore!.getData(10);
    _disposers = [
      reaction<String>(
        (_) => _dailyWorkStore!.errorMessage!,
        (String message) {
          print(message);
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              backgroundColor: Colors.red,
              message: message,
            ),
          );
        },
      ),
    ];
  }

  @override
  void dispose() {
    _disposers.forEach((d) => d());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_dailyWorkStore!.state) {
      case StoreState.initial:
        return buildInitialInput();
      case StoreState.loading:
        return buildLoading();
      case StoreState.loaded:
        return buildColumnWithData(_dailyWorkStore!.dailywork!, widget.user);
    }
  }

  Widget buildInitialInput() {
    return Container();
  }

  Widget buildLoading() {
    return CircularProgressIndicator();
  }
}

Widget buildColumnWithData(List<DailyWork> dialyWork, User user) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          user.name,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          user.depatment,
          style: TextStyle(fontSize: 80),
        ),
        Text(dialyWork.first.toString())
      ]);
}
