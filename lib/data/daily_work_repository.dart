import 'dart:io';
import 'dart:math';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import '../data/user_repository.dart';
import '../shared/config/connection.dart';

import 'model/daily_work.dart';

abstract class DailyWorkRepository {
  Future<List<DailyWork>> getData(int take);
}

List<DailyWork> dailyWork = [];

final work = DailyWork(
  agentName: 'علي محمد',
  address: 'بغداد المنصور',
  phoneNumber: '078XXXXXXXX',
  workType: 'صفحة ويب',
);

class ApiDailyWorkRepository implements DailyWorkRepository {
  @override
  Future<List<DailyWork>> getData(int take) async {
    final uri = getUri('daily_work/getListMyWork');

    Dio _dio = Dio(BaseOptions(headers: {
      HttpHeaders.authorizationHeader:
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xOTIuMTY4LjIyNC4yNzo4NVwvU3VwcG9ydC1CYWNrLUVuZFwvcHVibGljXC9hcGlcL3YxXC91c2Vyc1wvbG9naW4iLCJpYXQiOjE2MDg5ODQ5NjEsImV4cCI6MTY0MDA4ODk2MSwibmJmIjoxNjA4OTg0OTYxLCJqdGkiOiJjMk1mVUllRkwzVDlUclEwIiwic3ViIjoyODQsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.rXBsYXaILldPhsaBsiupvJ45TrYs3Yygl9i7Br6Ny_U',
      HttpHeaders.contentTypeHeader: "application/json",
    }));

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
    _dio.interceptors.add(CustomInterceptors());
    _dio.interceptors.add(LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true));
    Response response;
    try {
      response = await _dio.postUri(
        uri,
        data: {'skip': '0', 'take': '10'},
      );
      switch (response.statusCode) {
        case 200:
          log(response.data);
          print(response.statusMessage);

          return dailyWork;
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

class FakeDailyWorkRepository implements DailyWorkRepository {
  late String name;
  late String dep;

  @override
  Future<List<DailyWork>> getData(int take) {
    for (int i = 0; i <= take; i++) {
      dailyWork.add(work);
    }
    print('object');
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () {
        final random = Random();
        // Simulate some network error
        if (random.nextBool()) {
          throw NetworkError();
        }

        return dailyWork;
      },
    );
  }
}

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] =>Path:${response.requestOptions.path} data: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} Message: ${err.response?.statusMessage} ${err.message}');
    return super.onError(err, handler);
  }
}
