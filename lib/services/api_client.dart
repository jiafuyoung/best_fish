import 'dart:io';

import 'package:dio/dio.dart';
//因为 dio 和 get 都有Response，隐藏不需要的
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';
// 添加网络检查（需connectivity包）
import 'package:connectivity_plus/connectivity_plus.dart';

import 'auth_service.dart';

class ApiClient extends GetxService {
  static const String _baseUrl = "https://your-api-gateway.com";
  final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  Future<void> init() async {
    // 添加拦截器
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('agc_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        // 修改原有onError拦截器（增加重试逻辑）
        onError: (error, handler) async {
          final response = error.response;
          if (response?.statusCode == 401 &&
              !error.requestOptions.path.contains('/auth/refresh')) {
            try {
              await _refreshToken();
              return handler.resolve(await _retry(error.requestOptions));
            } catch (refreshError, stackTrace) {
              // 将普通异常转换为DioException
              final dioError = DioException(
                  requestOptions: error.requestOptions,
                  error: refreshError,
                  stackTrace: stackTrace,
                  response: Response(
                      requestOptions: error.requestOptions,
                      statusCode: 401,
                      statusMessage: 'Token refresh failed'
                  )
              );
              return handler.reject(dioError);
            }
          }
          return handler.next(error);
        }
    ));
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      return _handleError(e); // 调用统一错误处理器
    }
  }

  // 添加重试计数器
  int _retryCount = 0;
  // 请求重试机制（需在ApiClient类中定义）
  Future<Response> _retry(RequestOptions requestOptions) async {
    if (_retryCount >= 3) throw DioException(requestOptions: requestOptions);
    _retryCount++;
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw DioException(
          requestOptions: requestOptions,
          error: 'No network connection'
      );
    }
    // 创建新请求配置（保留原始参数）
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    try {
      // 使用Dio实例重新发送请求
      return await _dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      // 处理二次请求失败
      if (e.response?.statusCode == 401) {
        await Get.find<AuthService>().logout();
      }
      rethrow;
    }
    _retryCount = 0; // 成功时重置
  }

// 其他HTTP方法封装...
// 在ApiClient类内添加以下方法
  Future<Response> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('agc_refresh_token');
    final response = await _dio.post('/auth/refresh', data: {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken
    });
    // 在_refreshToken方法中增加过期判断
    // if (DateTime.now().difference(lastRefreshTime) > Duration(hours: 1)) {
    //   throw '登录状态已过期，请重新登录';
    // }

    await prefs.setString('agc_token', response.data['access_token']);
    return response;
  }

  // 在ApiClient类中添加私有方法
  Future<Response> _handleError(DioException e) {
    final response = e.response;
    String errorMessage = '网络请求异常';

    if (response != null) {
      // 解析服务端错误信息（网页5的异常上报模式）
      errorMessage = response.data?['message'] ??
          '服务器错误：${response.statusCode}';
    } else if (e.error is SocketException) {
      errorMessage = '网络连接不可用（网页4的网络检测）';
    }

    // 统一错误提示（网页7的异常处理规范）
    Get.snackbar('操作失败', errorMessage,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP
    );

    // 抛出结构化错误（网页5的异常上报需求）
    throw {
      'timestamp': DateTime.now().toIso8601String(),
      'path': e.requestOptions.path,
      'error': errorMessage
    };
  }

// 华为认证接口封装
  Future<Response> huaweiAuth(String type, dynamic credentials) async {
    const authPath = {
      'anonymous': '/auth/anonymous',
      'phone': '/auth/phone',
      'email': '/auth/email'
    };

    return post(authPath[type]!, {
      'provider': 'HUAWEI',
      'credentials': credentials
    });
  }
}