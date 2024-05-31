import 'package:am_sys/data/api/rest_client.dart';
import 'package:am_sys/model/server_response.dart';

import '../api/api_client.dart';

class ProfileRepository {
  late RestClient _restClient;

  ProfileRepository() {
// _restClient = RestClient(ApiClient().dio);
    _restClient = RestClientX.instance();

  }

  Future<ServerResponse> getUserProfileData() => _restClient.getUserProfileData();
}
