import 'package:flutter/material.dart';

import '../locator.dart';
import '../data/model/logIn.dart';
import '../state/user_store.dart';
import './Widgets/custom_text_feild.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: LoginInputFeilds(),
      ),
    );
  }
}

class LoginInputFeilds extends StatefulWidget {
  @override
  _LoginInputFeildsState createState() => _LoginInputFeildsState();
}

class _LoginInputFeildsState extends State<LoginInputFeilds> {
  late GlobalKey<FormState> _formKey;

  late TextEditingController userNameController;
  late TextEditingController passwordController;
  bool showPass = false;

  @override
  void initState() {
    _formKey = GlobalKey();
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
            CustomTextFeild(
              controller: userNameController,
              hintText: "User Name",
              prefixIcon: Icon(Icons.person),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a value';
                } else if (value.length <= 3) {
                  return 'your username is too short';
                }
                return null;
              },
            ),
            CustomTextFeild(
              controller: passwordController,
              hintText: 'Password',
              prefixIcon: Icon(Icons.password),
              obscureText: showPass,
              suffixWidget: InkWell(
                onTap: () => setState(() => showPass = !showPass),
                child: showPass
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter a Password';
                } else if (value.length <= 5) {
                  return 'your password is too short';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () => submit(
                      Login(
                        username: userNameController.text,
                        password: passwordController.text,
                      ),
                    ),
                child: Text("Login"))
          ],
        ),
      ),
    );
  }

  void submit(Login credentials) {
    final userStore = getIt.get<UserStore>();
    if (_formKey.currentState!.validate()) userStore.login(credentials);
  }
}
