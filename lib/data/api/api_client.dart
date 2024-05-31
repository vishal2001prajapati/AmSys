import 'package:am_sys/data/api/dio_intercepter.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:dio/dio.dart';

class  ApiClient  {
  factory ApiClient() {
    return _apiClient;
  }

  ApiClient._internal() {
    final BaseOptions options = BaseOptions(
      baseUrl: AppConstants.developmentUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(options)..interceptors.add(DioInterceptor(printOnSuccess: true));

  }

  static final ApiClient _apiClient = ApiClient._internal();

  late final Dio _dio;

  Dio get dio => _dio;
}