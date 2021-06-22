import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/logIn.dart';
import '../data/model/user.dart';
import '../shared/config/connection.dart';

abstract class UserRepository {
  Future<User> login(Login credentials);
  void logout();
  Future<User> getCurrentUser();
  void setCurrentUser(jsonString);
}

class ApiUserRepository implements UserRepository {
  @override
  Future<User> login(Login credentials) async {
    final uri = getUri('users/login');

    Dio _dio = Dio();

    Response response;
    try {
      response = await _dio.postUri(uri,
          data: credentials.toJson(),
          options: Options(contentType: "application/json"));
      switch (response.statusCode) {
        case 200:
          log(response.data);
          User _user = User.fromJson(response.data);
          _user.auth = true;
          return _user;
        case 404:
          throw ('User not found');
        case 500:
          throw ("Server error. Try again later");
        default:
          throw ("An unexpected error occurred, please try again later");
      }
    } on DioError {
      throw ("An unexpected error occurred, please try again later");
    } catch (e) {
      throw ("An unexpected error occurred, please try again later");
    }
  }

  @override
  Future<User> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  void setCurrentUser(jsonString) {}

  @override
  void logout() {}
}

class FakeUserRepository implements UserRepository {
  @override
  Future<User> login(Login credentials) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () {
        final random = Random();
        // Simulate some network error
        if (random.nextBool()) {
          throw NetworkError();
        }

        if (credentials.username != 'task' ||
            credentials.password != 'task1234') {
          throw CredentialError();
        }
        final response = json.encode({
          "data": {
            "name": "Bilal",
            "department": "mobile",
            "apiToken": "MySecretToken",
          }
        });
        setCurrentUser(response);

        final user = User.fromMap(json.decode(response)["data"]);
        user.auth = true;

        return user;
      },
    );
  }

  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = User.initial();
    if (prefs.containsKey('current_user')) {
      user = User.fromJson(prefs.get('current_user').toString());
    }
    return user;
  }

  void setCurrentUser(jsonString) async {
    if (json.decode(jsonString)['data'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'current_user', json.encode(json.decode(jsonString)['data']));
    }
  }

  @override
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('current_user')) {
      prefs.remove('current_user');
    }
  }
}

class NetworkError extends Error {}

class CredentialError extends Error {}
