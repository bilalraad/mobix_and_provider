import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import '../data/user_repository.dart';
import '../shared/config/connection.dart';

import 'model/daily_work.dart';

abstract class DailyWorkRepository {
  Future<List<DailyWork>> getData(int page);
}

List<DailyWork> _dailyWork = [];

final work = DailyWork(
  agentName: 'علي محمد',
  address: 'بغداد المنصور',
  phoneNumber: '078XXXXXXXX',
  workType: 'صفحة ويب',
);

class FakeDailyWorkRepository implements DailyWorkRepository {
  @override
  Future<List<DailyWork>> getData(int page) {
    // Simulate network delay
    return Future.delayed(
      Duration(seconds: 1),
      () {
        //ideally this will return different items for each new page
        //basically each page have ten items so each request will return 10 and
        //the pagination controller will append them to the previous pages
        for (int i = 0; i <= 10; i++) _dailyWork.add(work);

        final random = Random();
        // Simulate some network error
        if (random.nextBool()) {
          throw NetworkError();
        }

        return _dailyWork;
      },
    );
  }
}

class ApiDailyWorkRepository implements DailyWorkRepository {
  @override
  Future<List<DailyWork>> getData(int take) async {
    final uri = getUri('daily_work/getListMyWork');

    Dio _dio = Dio(BaseOptions(headers: {
      HttpHeaders.authorizationHeader:
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xOTIuMTY4LjIyNC4yNzo4NVwvU3VwcG9ydC1CYWNrLUVuZFwvcHVibGljXC9hcGlcL3YxXC91c2Vyc1wvbG9naW4iLCJpYXQiOjE2MDg5ODQ5NjEsImV4cCI6MTY0MDA4ODk2MSwibmJmIjoxNjA4OTg0OTYxLCJqdGkiOiJjMk1mVUllRkwzVDlUclEwIiwic3ViIjoyODQsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.rXBsYXaILldPhsaBsiupvJ45TrYs3Yygl9i7Br6Ny_U',
      HttpHeaders.contentTypeHeader: "application/json",
    }));

    _dio.interceptors.add(LogInterceptor(
      error: true,
      request: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
    ));
    Response response;
    try {
      response = await _dio.postUri(
        uri,
        data: {'skip': '0', 'take': '10'},
      );
      switch (response.statusCode) {
        case 200:
          return _dailyWork;
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
}
