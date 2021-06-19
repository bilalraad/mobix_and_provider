import 'dart:io';
import 'dart:math';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import '../data/model/logIn.dart';
import '../data/model/user.dart';
import '../shared/config/connection.dart';

abstract class UserRepository {
  Future<User> login(Login credentials);
}

class ApiUserRepository implements UserRepository {
  @override
  Future<User> login(Login credentials) async {
    final uri = getUri('users/login');

    Dio _dio = Dio();

// This should be used while in development mode,
// remove this when you want to release to production,
// the aim of this fix is to make the development a bit easier,
// for production, you need to fix your certificate issue and use it properly,
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    Response response;
    try {
      response = await _dio.postUri(uri,
          data: credentials.toJson(),
          options: Options(contentType: "application/json"));
      switch (response.statusCode) {
        case 200:
          log(response.data);
          User _user = User.fromJson(response.data);
          print(_user.name);

          //TODO: save token to the local database

          return _user;
        case 404:
          throw ('User not found');
        case 500:
          throw ("Server error. Try again later");
        default:
          throw ("An unexpected error occurred, please try again later");
      }
    } on DioError {
      print('dio error');
      throw ("An unexpected error occurred, please try again later");
    } catch (e) {
      print(e.toString());
      throw ("An unexpected error occurred, please try again later");
    }
  }
}

class FakeUserRepository implements UserRepository {
  late String name;
  late String dep;

  @override
  Future<User> login(Login credentials) {
    // Simulate network delay
    print('object');
    return Future.delayed(
      Duration(seconds: 1),
      () {
        final random = Random();
        // Simulate some network error
        // if (random.nextBool()) {
        //   throw NetworkError();
        // }
        name = 'bilal';
        dep = 'mobile';
        if (credentials.username != 'task' &&
            credentials.password != 'task1234') {
          throw CredentialError();
        }

        return User(
          name: name,
          depatment: dep,
        );
      },
    );
  }
}

class NetworkError extends Error {}

class CredentialError extends Error {}
