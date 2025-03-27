import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kelola_kos/shared/widgets/loading_bar.dart';
import 'package:kelola_kos/utils/functions/show_error_bottom_sheet.dart';
import 'package:kelola_kos/utils/services/global_service.dart';

class HttpService extends GetxService {
  HttpService._();
  static final HttpService dioService = HttpService._();
  static String? _token;

  static void _showLoading() {
    Get.bottomSheet(
      const SizedBox(
        height: 150,
        child: LoadingBar(),
      ),
      isDismissible: false,
    );
  }

  static void _hideLoading() {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }
  }

  factory HttpService() {
    return dioService;
  }

  @override
  onInit() async {
    super.onInit();
    await _init();
  }

  Future<void> _init() async {
    _token = await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  /// Manually refresh token (call when needed)
  Future<void> refreshToken() async {
    _token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
  }

  static const Duration timeoutInMiliSeconds = Duration(
    seconds: 20000,
  );

  static Dio dioCall({
    Duration timeout = timeoutInMiliSeconds,
    String? authorization,
  }) {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_token != null) {
      headers['token'] = _token!;
    }

    if (authorization != null) {
      headers['Authorization'] = authorization;
    }

    var dio = Dio(
      BaseOptions(
        headers: headers,
        baseUrl: 'https://67c936f40acf98d070894099.mockapi.io/',
        connectTimeout: timeoutInMiliSeconds,
        contentType: "application/json",
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(_authInterceptor());

    return dio;
  }

  static Interceptor _authInterceptor() {
    return QueuedInterceptorsWrapper(
      onRequest: (reqOptions, handler) {
        log('==============================================');
        log('${reqOptions.uri}', name: 'REQUEST URL');
        log('${reqOptions.headers}', name: 'HEADER');
        log(reqOptions.method, name: "METHOD");
        log('${reqOptions.data}', name: 'DATA');
        log('==============================================');
        if(reqOptions.method == 'POST' || reqOptions.method == 'DELETE' || reqOptions.method == 'PUT') {
          _showLoading();
        }
        return handler.next(reqOptions);
      },
      onError: (error, handler) async {
        _hideLoading();
        log('==============================================');
        log(error.message.toString(), name: 'ERROR MESSAGE');
        log('${error.response}', name: 'RESPONSE');
        log('==============================================');
        showErrorBottomSheet('Error', error.message ?? 'An error occurred');
        return handler.next(error);
      },
      onResponse: (response, handler) async {
        log('==============================================');
        log('${response.data}', name: 'RESPONSE');
        log('==============================================');
        if(response.requestOptions.method == 'POST' || response.requestOptions.method == 'DELETE' || response.requestOptions.method == 'PUT') {
          GlobalService.refreshData();
        }
        _hideLoading();

        return handler.resolve(response);
      },
    );
  }
}
