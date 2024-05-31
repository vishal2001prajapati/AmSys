import 'dart:io';

import 'package:am_sys/model/add_assert_request/add_assert_decoded_request_.dart';
import 'package:am_sys/model/add_assert_request/assert_detail_request.dart';
import 'package:am_sys/model/add_assert_request/update_assest.dart';
import 'package:am_sys/model/assets_type_response/assets_type_response.dart';
import 'package:am_sys/model/login_request/login_reuqest_data.dart';
import 'package:am_sys/model/login_response/login_response_data.dart';
import 'package:am_sys/model/server_response.dart';
import 'package:am_sys/model/service_lines_response/service_lines_response.dart';
import 'package:am_sys/screens/bottom_navigation/view/bottom_navigation_page.dart';
import 'package:am_sys/screens/login_screen/view/login_page.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/session_manager/session_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';

import 'dio_intercepter.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: AppConstants.developmentUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET(AppConstants.sessionTokenAPI)
  Future<ServerResponse<LoginResponseData>> login(@Body() LoginRequestData request);

  @GET(AppConstants.assetTypesAPI)
  Future<ServerResponse<AssetTypeResponse>> getAssetTypeData();

  @GET(AppConstants.serviceLinesAPI)
  Future<ServerResponse<ServiceLinesResponse>> getServiceLinesData();

  @GET(AppConstants.organizationsAPI)
  Future<ServerResponse> getOrganizationsData();

  @GET(AppConstants.personsAPI)
  Future<ServerResponse> getPersonsData();

  @GET(AppConstants.locationTypesAPI)
  Future<ServerResponse> getLocationTypeData();

  @GET(AppConstants.locationUsagesAPI)
  Future<ServerResponse> getLocationUsageData();

  @GET(AppConstants.currenciesAPI)
  Future<ServerResponse> getCurrenciesData();

  @GET(AppConstants.assetStatesAPI)
  Future<ServerResponse> getAssetStatesData();

  @GET(AppConstants.assetAPI)
  Future<ServerResponse> getAssetData();

  @GET(AppConstants.locationsAPI)
  Future<ServerResponse> getLocationsData();

  /// Header in pass the session token(password)
  @GET(AppConstants.userProfileAPI)
  Future<ServerResponse> getUserProfileData();

  @GET(AppConstants.refreshTokenAPI)
  Future<ServerResponse> getRefreshTokenData();

  @POST(AppConstants.postAssetAPI)
  Future<ServerResponse> postAsset(@Body() AddAssetsDecodedRequest request);

  @GET(AppConstants.assetDetailAPI)
  Future<ServerResponse> getAssetDetailData(@Body() AssertDetailRequest request);

  @POST(AppConstants.updatePostAssetStateAPI)
  Future<ServerResponse> updateStateData(@Body() AddAssetsDecodedRequest request);
}

extension RestClientX on RestClient {
  static RestClient instance() {
    final dio = Dio(BaseOptions(
        validateStatus: (status) {
          if (status != null && ((status >= 200 && status < 300) || (status >= 400 && status < 500))) {
            return true;
          }
          return false;
        },
        receiveTimeout: const Duration(minutes: 1),
        connectTimeout: const Duration(minutes: 1)))
      ..interceptors.add(InterceptorsWrapper(onRequest: (request, handler) async {
        request.headers['content-type'] = 'application/json';
        request.headers['accept'] = 'application/json';
        request.headers['application-access-key'] = AppConstants.applicationAccessKey;
        request.headers['input-parameters'] = AppConstants.encodedValue;
        final sessionToken = await SessionManager.getUserDecodedData();
        if (sessionToken != null && sessionToken != '') {
          request.headers['session-token'] = sessionToken.password;
          // request.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(request);
      }, onError: (error, handler) async {
        // if (error.response?.statusCode == 401) {
        //   await SessionManager.setIsUserLogin(false);
        //   Navigator.pushReplacement(
        //     globalContext!,
        //     MaterialPageRoute(
        //       builder: (context) => const LoginPage(),
        //     ),
        //   );
        // }
        // print('------------------- Inside onError -----------');
        // final RefreshTokenRepositoryImpl refreshTokenRepositoryImpl = RefreshTokenRepositoryImpl();
        // print("StatusCode:: ${error.response!.statusCode.runtimeType}");
        //
        // if (error.response!.statusCode == 500) {
        //   print("StatusCode check::");
        // }
        //
        // if (error.response?.statusCode == 500) {
        //   await refreshTokenRepositoryImpl.getRefreshTokenData();
        //   final sessionToken = await SessionManager.getUserDecodedData();
        //   error.requestOptions.headers['session-token'] = '${sessionToken?.password}';
        //   return _retry(error.requestOptions);
        // }

        if (error.type == DioExceptionType.unknown && error.error != null && error.error is SocketException) {
          handler.next(error.copyWith(message: 'Internet not available. Please check your internet connection and try again.'));
        } else {
          handler.next(error.copyWith(message: 'Something went wrong.'));
        }
      }))
      ..interceptors.add(DioInterceptor(printOnSuccess: true));
    final restClient = RestClient(dio);
    return restClient;
  }

  static Future<void> _retry(RequestOptions requestOptions) async {
    final sessionToken = await SessionManager.getUserDecodedData();
    Map<String, dynamic> tempHeaders = requestOptions.headers;
    print("Before:: ${tempHeaders["session-token"]}");
    tempHeaders["session-token"] = sessionToken?.password;
    print("After:: ${tempHeaders["session-token"]}");

    /*Map<String, dynamic> headers = {
      'session-token': sessionToken?.password,
    };*/

    final options = Options(
      method: requestOptions.method,
      headers: tempHeaders,
    );

    Dio dio = Dio();
    print('Request Call of Retry');
    await dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
