import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:am_sys/data/api/api_client.dart';
import 'package:am_sys/data/repository/refresh_token_repository.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/session_manager/session_manager.dart';
import 'package:dio/dio.dart';

import '../repository/refresh_token_repository_impl.dart';

class DioInterceptor extends Interceptor {
  final bool? printOnSuccess;
  final bool convertFormData;

  DioInterceptor({this.printOnSuccess, this.convertFormData = true});

  // Dio dio = Dio();
  // RefreshTokenRepository refreshTokenRepository = RefreshTokenRepository();

  @override
  Future<void> onRequest(RequestOptions request, RequestInterceptorHandler handler) async {
    // request.headers['content-type'] = 'application/json';
    // request.headers['accept'] = 'application/json';
    // request.headers['application-access-key'] = AppConstants.applicationAccessKey;
    // request.headers['input-parameters'] = AppConstants.encodedValue;
    // final sessionToken = await SessionManager.getUserDecodedData();
    // if (sessionToken != null && sessionToken != '') {
    //   request.headers['session-token'] = sessionToken.password;
    //   // request.headers['Authorization'] = 'Bearer $token';
    // }
    //
    // return handler.next(request);

    log("┌------------------------------------------------------------------------------");
    log('| [DIO] Request: ${request.method} ${request.uri}');
    log('| ${request.data.toString()}');
    log('| Headers:');
    request.headers.forEach((key, value) {
      log('|\t$key: $value');
    });
    log("├------------------------------------------------------------------------------");
    super.onRequest(request, handler);
    // super.onRequest(request, handler);
    // return super.onRequest(request, handler);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    _renderCurlRepresentation(error.requestOptions);

    log("| [DIO] Error Type: ${error.type}");
    log("| [DIO] Error: ${error.error}: ${error.response.toString()}");
    log("└------------------------------------------------------------------------------");
    return handler.next(error); //continue

    // final RefreshTokenRepositoryImpl refreshTokenRepositoryImpl = RefreshTokenRepositoryImpl();
    // if (error.response?.statusCode == 500 || error.response?.statusCode == 401) {
    //     await refreshTokenRepositoryImpl.getRefreshTokenData();
    //     final sessionToken = await SessionManager.getUserDecodedData();
    //     error.requestOptions.headers['session-token'] = '$sessionToken';
    //     return _retry(error.requestOptions);
    // }
    //
    // if (error.type == DioExceptionType.unknown && error.error != null && error.error is SocketException) {
    //   handler.next(error.copyWith(message: 'Internet not available. Please check your internet connection and try again.'));
    // } else {
    //   handler.next(error.copyWith(message: 'Something went wrong.'));
    // }

    // // Check if the user is unauthorized.
    // if (error.response?.statusCode == 401) {
    //   // Refresh the user's authentication token.
    // // await  refreshTokenRepository.getRefreshTokenData();
    //
    //   // Retry the request.
    //   try {
    //     handler.resolve(await _retry(error.requestOptions));
    //   } on DioException catch (e) {
    //     // If the request fails again, pass the error to the next interceptor in the chain.
    //     handler.next(e);
    //   }
    //   // Return to prevent the next interceptor in the chain from being executed.
    //   return;
    // }
    // // Pass the error to the next interceptor in the chain.
    // handler.next(error);

    log("| [DIO] Error Type: ${error.type}");
    log("| [DIO] Error: ${error.error}: ${error.response.toString()}");
    log("└------------------------------------------------------------------------------");
    return handler.next(error);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (printOnSuccess != null && printOnSuccess == true) {
      _renderCurlRepresentation(response.requestOptions);
    }

    log("| [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}");
    log("└------------------------------------------------------------------------------");
    return handler.next(response);
  }

  void _renderCurlRepresentation(RequestOptions requestOptions) {
    // add a breakpoint here so all errors can break
    try {
      log(_cURLRepresentation(requestOptions));
    } catch (err) {
      log('unable to create a CURL representation of the requestOptions');
    }
  }

  String _cURLRepresentation(RequestOptions options) {
    List<String> components = ['curl -i'];
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method}');
    }

    options.headers.forEach((k, v) {
      if (k != 'Cookie') {
        components.add('-H "$k: $v"');
      }
    });

    if (options.data != null) {
      // FormData can't be JSON-serialized, so keep only their fields attributes
      if (options.data is FormData && convertFormData == true) {
        options.data = Map.fromEntries(options.data.fields);
      }

      final data = json.encode(options.data).replaceAll('"', '\\"');
      components.add('-d "$data"');
    }

    components.add('"${options.uri.toString()}"');

    return components.join(' \\\n\t');
  }

  // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
  //   // Create a new `RequestOptions` object with the same method, path, data, and query parameters as the original request.
  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: {
  //       // "session-token": "Bearer ${token}",
  //     },
  //   );
  //
  //   // Retry the request with the new `RequestOptions` object.
  //   return dio.request<dynamic>(requestOptions.path,
  //       data: requestOptions.data,
  //       queryParameters: requestOptions.queryParameters,
  //       options: options);
  // }

  static Future<void> _retry(RequestOptions requestOptions) async {
    final sessionToken = await SessionManager.getUserDecodedData();
    Map<String, dynamic> headers = {
      'session-token': sessionToken?.password,
    };
    final options = Options(
      method: requestOptions.method,
      headers: headers,
    );

    print('Request Call of Retry');
    await ApiClient().dio.request<dynamic>(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: options,
        );
  }
}
