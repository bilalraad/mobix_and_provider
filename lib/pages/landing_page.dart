import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:mobx/mobx.dart';

import '../shared/store_state.dart';
import '../state/user_store.dart';
import '../locator.dart';
import './home_page.dart';
import './login_page.dart';
import './widgets/loading.dart';

class FlutterMobx extends StatefulWidget {
  const FlutterMobx({Key? key}) : super(key: key);

  @override
  _FlutterMobxState createState() => _FlutterMobxState();
}

class _FlutterMobxState extends State<FlutterMobx> {
  UserStore? _userStore;
  late List<ReactionDisposer> _disposers;

  @override
  void initState() {
    _userStore ??= getIt.get<UserStore>();
    _userStore!.getCurrentUser();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disposers = [
      reaction<String>(
        (_) => _userStore!.errorMessage!,
        (String message) {
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: Observer(
        builder: (_) {
          switch (_userStore!.state) {
            case StoreState.loading:
              return Loading();
            case StoreState.loaded:
              return _userStore!.user!.auth
                  ? HomePage(user: _userStore!.user!)
                  : LoginPage();
            case StoreState.error:
              return LoginPage();
            //here might be a splash screen
            case StoreState.initial:
              return LoginPage();
          }
        },
      ),
    );
  }
}
