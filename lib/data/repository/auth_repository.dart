import 'package:am_sys/data/api/rest_client.dart';
import 'package:am_sys/model/login_request/login_reuqest_data.dart';
import 'package:am_sys/model/login_response/login_response_data.dart';
import 'package:am_sys/model/server_response.dart';

import '../api/api_client.dart';

class AuthRepository {
  late RestClient _restClient;

  AuthRepository() {
     // _restClient = RestClient(ApiClient().dio);
     _restClient = RestClientX.instance();

  }

// Future<ServerResponse<ChatData>> uploadFile(FormData file) => _restClient.uploadChatFile(file);
  Future<ServerResponse<LoginResponseData>> login(LoginRequestData request) => _restClient.login(request);
}
