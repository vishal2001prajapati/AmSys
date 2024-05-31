// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:am_sys/data/repository/refresh_token_repository.dart';
// import 'package:am_sys/utils/session_manager/session_manager.dart';
//
// class RefreshTokenRepositoryImpl {
//   final RefreshTokenRepository _refreshTokenRepository = RefreshTokenRepository();
//
//   Future<void> getRefreshTokenData() async {
//     print("getRefreshToken:");
//     try {
//       var response = await _refreshTokenRepository.getRefreshTokenData();
//
//       print("getRefreshToken: ${response.status}");
//
//       if (response.status == 200) {
//         String? encoded = response.data;
//         String decoded = utf8.decode(base64.decode(encoded ?? ''));
//         var decodedJson = json.decode(decoded);
//         log('decodedJson: $decodedJson');
//        await SessionManager.setUserDecodedData(decodedJson);
//       } else {
//         log('decodedJson: _refreshTokenRepository ');
//       }
//
//       if(response.status == 500) {
//         log('------500----');
//       }
//     } catch (error) {
//       log('Error: $error');
//     }
//   }
// }
