import 'dart:convert';

import 'package:am_sys/data/api/rest_client.dart';
import 'package:am_sys/model/server_response.dart';

import '../api/api_client.dart';

class RefreshTokenRepository {
  late RestClient _restClient;

  RefreshTokenRepository() {
    _restClient = RestClientX.instance();
  }

  // Future<ServerResponse> getRefreshTokenData() => _restClient.getRefreshTokenData();
}
