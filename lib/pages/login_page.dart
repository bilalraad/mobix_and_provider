import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../data/daily_work_repository.dart';
import '../data/model/logIn.dart';
import '../data/model/user.dart';
import '../pages/home_page.dart';
import '../state/daily_work_store.dart';
import '../state/user_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserStore? _userStore;
  late List<ReactionDisposer> _disposers;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
    _userStore ??= Provider.of<UserStore>(context);
    _disposers = [
      reaction<String>(
        (_) => _userStore!.errorMessage!,
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("login"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Observer(
          builder: (_) {
            switch (_userStore!.state) {
              case StoreState.initial:
                return buildInitialInput();
              case StoreState.loading:
                return buildLoading();
              case StoreState.loaded:
                return buildColumnWithData(_userStore!.user!);
            }
          },
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildColumnWithData(User user) {
    print(user.name);
    return Provider(
        create: (_) => DailyWorkStore(FakeDailyWorkRepository()),
        child: HomePage(user: user));
  }
}

class CityInputField extends StatefulWidget {
  @override
  _CityInputFieldState createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  GlobalKey<FormFieldState> _formKey = GlobalKey();

  late TextEditingController userNameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: userNameController,
              decoration: InputDecoration(
                hintText: "User Name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: Icon(Icons.person),
              ),
            ),
            TextFormField(
              textInputAction: TextInputAction.send,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: Icon(Icons.password),
              ),
            ),
            ElevatedButton(
                onPressed: () => submit(
                    context,
                    Login(
                      username: userNameController.text,
                      password: passwordController.text,
                    )),
                child: Text("hello"))
          ],
        ),
      ),
    );
  }

  void submit(BuildContext context, Login credentials) {
    final weatherStore = Provider.of<UserStore>(context, listen: false);
    weatherStore.login(credentials);
  }
}
