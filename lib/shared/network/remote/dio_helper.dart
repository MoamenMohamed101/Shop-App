import 'package:dio/dio.dart';
import 'package:salla/shared/get_it_helper.dart';

class DioHelper {
  Dio? dio;

  init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://student.valuxapps.com/api/",
        receiveDataWhenStatusError: true,
      ),
    );
  }

  Future<Response> getData({
    required String endPoint,
    Map<String, dynamic>? query,
    String? language = 'en',
    String? authorization,
  }) async {
    getIt<DioHelper>().dio!.options.headers = {
      'lang': language,
      'Content-Type': 'application/json',
      'Authorization': authorization ?? '',
    };
    return await getIt<DioHelper>().dio!.get(
      endPoint,
      queryParameters: query,
    );
  }

  Future<Response> postData({
    required String endPoint,
    Map<String, dynamic>? data,
    String? language = 'en',
    String? authorization,
  }) async {
    getIt<DioHelper>().dio!.options.headers = {
      'lang': language,
      'Content-Type': 'application/json',
      'Authorization': authorization ?? '',
    };
    return await getIt<DioHelper>().dio!.post(
      endPoint,
      data: data,
    );
  }

  Future<Response> updateData({
    required String endPoint,
    Map<String, dynamic>? data,
    String? language = 'en',
    String? authorization,
  }) async {
    getIt<DioHelper>().dio!.options.headers = {
      'lang': language,
      'Content-Type': 'application/json',
      'Authorization': authorization ?? '',
    };
    return await getIt<DioHelper>().dio!.put(
      endPoint,
      data: data,
    );
  }
}