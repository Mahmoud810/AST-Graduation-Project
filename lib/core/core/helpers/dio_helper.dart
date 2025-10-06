import 'dart:developer' as dev;
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get/utils.dart';
import 'package:haretna/core/utils/common_method.dart';
import 'package:haretna/core/utils/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/remote/end_points.dart';

class DioHelper {
  static final DioHelper _apiRequest = DioHelper._();

  DioHelper._() {
    _init();
  }
  factory DioHelper() {
    return _apiRequest;
  }
  late final Dio dio;

  void _init() {
    // print("_init dio");
    // print(isArabic);
    // print(Get.locale?.languageCode);
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Accept-Language": isArabic ? 'ar' : 'en'
        },
      ),
    );
    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
      );
    }

    _fixCertificateProblem();
  }

  void _fixCertificateProblem() {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      return HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
    };
  }

  void updateHeaderLanguage() {
    dio.options.headers.update("Accept-Language",
        (value) => Get.locale != null ? Get.locale?.languageCode : 'ar');
  }

  Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    bool isAuthorized = false,
  }) async {
    // print("getData");
    // print(isArabic);
    // print(Get.locale?.languageCode);

    if (isAuthorized) {
      dio.options.headers.addAll({
        "Authorization": "Bearer ${LocalStorage.getTokenFromCache()}",
        // "Authorization": "Bearer 15|IAA8McJcJuzWLaAJY31ssVgzIsyTkrEh1VJbxMky109c22ed",
      });
    }
    updateHeaderLanguage();

    final response = await dio.get(
      url,
      queryParameters: query,
    );

    return response;
  }

  Future<Response> postData({
    required String url,
    Map<String, dynamic>? data,
    dynamic dynamicData,
    Map<String, dynamic>? query,
    bool isAuthorized = false,
  }) async {
    if (isAuthorized) {
      dio.options.headers.addAll({
        "Authorization": "Bearer ${LocalStorage.getTokenFromCache()}",
      });
    }
    updateHeaderLanguage();
    final response = await dio.post(
      url,
      queryParameters: query,
      data: dynamicData ?? data,
    );

    return (response);
  }

  Future<Response> postForm({
    required String url,
    required FormData data,
    Map<String, dynamic>? query,
    bool isAuthorized = false,
  }) async {
    if (isAuthorized) {
      dio.options.headers.addAll({
        "Authorization": "Bearer ${LocalStorage.getTokenFromCache()}",
      });
    }
    updateHeaderLanguage();
    final response = await dio.post(
      url,
      queryParameters: query,
      data: data,
    );
    dev.log((response.data['error'] != null).toString());

    return (response);
  }

  Future<Response> patchData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    bool isAuthorized = false,
  }) async {
    if (isAuthorized) {
      dio.options.headers.addAll({
        "Authorization": "Bearer ${LocalStorage.getTokenFromCache()}",
      });
    }
    updateHeaderLanguage();
    final response = await dio.patch(
      url,
      queryParameters: query,
      data: data,
    );

    return (response);
  }

  Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    bool isAuthorized = false,
  }) async {
    if (isAuthorized) {
      dio.options.headers.addAll({
        "Authorization": "Bearer ${LocalStorage.getTokenFromCache()}",
      });
    }
    updateHeaderLanguage();

    final response = await dio.put(
      url,
      queryParameters: query,
      data: data,
    );

    return (response);
  }

  Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    bool isAuthorized = false,
  }) async {
    if (isAuthorized) {
      dio.options.headers.addAll({
        "Authorization": "Bearer ${LocalStorage.getTokenFromCache()}",
      });
    }
    updateHeaderLanguage();

    final response = await dio.delete(
      url,
      data: data,
      queryParameters: query,
    );

    return (response);
  }

  bool isSuccessResponse({required Response<dynamic> response}) {
    if (response.statusCode! == 200 ||
        response.statusCode! == 201 ||
        response.statusCode! == 204) {
      return true;
    }

    return false;
  }

  dynamic handleResponse(Response response) {
    log(response.statusCode.toString());
    log(response.data.toString());
    if (!isSuccessResponse(response: response)) {
      log('handle response ${response.data}');
      throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          type: DioExceptionType.badResponse);
    }
    return response.data;
  }
}
