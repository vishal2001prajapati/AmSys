import 'package:am_sys/data/api/api_client.dart';
import 'package:am_sys/data/api/rest_client.dart';
import 'package:am_sys/model/add_assert_request/add_assert_decoded_request_.dart';
import 'package:am_sys/model/add_assert_request/assert_detail_request.dart';
import 'package:am_sys/model/add_assert_request/update_assest.dart';
import 'package:am_sys/model/assets_type_response/assets_type_response.dart';
import 'package:am_sys/model/server_response.dart';
import 'package:am_sys/model/service_lines_response/service_lines_response.dart';

class AddEstateRepository {
  late RestClient _restClient;

  AddEstateRepository() {
    // _restClient = RestClient(ApiClient().dio);

    _restClient = RestClientX.instance();
  }

  Future<ServerResponse<AssetTypeResponse>> getAssetTypeData() => _restClient.getAssetTypeData();

  Future<ServerResponse<ServiceLinesResponse>> getServiceLinesData() => _restClient.getServiceLinesData();

  Future<ServerResponse> getOrganizationsData() => _restClient.getOrganizationsData();

  Future<ServerResponse> getPersonsData() => _restClient.getPersonsData();

  Future<ServerResponse> getLocationTypeData() => _restClient.getLocationTypeData();

  Future<ServerResponse> getLocationUsageData() => _restClient.getLocationUsageData();

  Future<ServerResponse> getCurrenciesData() => _restClient.getCurrenciesData();

  Future<ServerResponse> getAssetStatesData() => _restClient.getAssetStatesData();

  Future<ServerResponse> getAssetData() => _restClient.getAssetData();

  Future<ServerResponse> getLocationsData() => _restClient.getLocationsData();

  Future<ServerResponse> postAsset(AddAssetsDecodedRequest request) => _restClient.postAsset(request);

  Future<ServerResponse> getAssetDetailData(AssertDetailRequest request) => _restClient.getAssetDetailData(request);

  Future<ServerResponse> updateStateData(AddAssetsDecodedRequest request) => _restClient.updateStateData(request);
}
