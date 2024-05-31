import 'dart:convert';
import 'dart:developer';
import 'package:am_sys/data/repository/profile_repository.dart';
import 'package:am_sys/model/login_response/user_decoded_data.dart';
import 'package:am_sys/model/user_info/user.dart';
import 'package:am_sys/screens/login_screen/view/login_page.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:am_sys/utils/session_manager/session_manager.dart';
import 'package:am_sys/utils/snack_bar/snack_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserDecodedData? userData;
  UserData? _userData;

  final ProfileRepository _profileRepository = ProfileRepository();
  bool isLoading = true;

  static const textStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  @override
  void initState() {
    super.initState();
    getUserData();
    // getRefreshTokenData();

    getAssetStatesData(context);
  }

  void getUserData() async {
    userData = await SessionManager.getUserDecodedData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Stack(
          children: [
            if (isLoading == false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      minRadius: 50,
                      maxRadius: 70,
                      backgroundImage: NetworkImage(_userData?.user?.photo ?? AppConstants.placeHolderImage),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _userData?.user?.displayName ?? '',
                      style: textStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // ProfileTile(
                  //   userData: _userData?.user?.displayName ?? '--',
                  //   textStyle: textStyle,
                  //   icon: Icons.person,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  ProfileTile(
                    userData:
                        '${_userData?.user?.firstName ?? ''}${_userData?.user?.middleName != null ? ' ${_userData?.user?.middleName} ' : ' '}${_userData?.user?.lastName ?? ''}',
                    textStyle: textStyle,
                    icon: Icons.person,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileTile(
                    userData: _userData?.user?.mobile ?? '--',
                    textStyle: textStyle,
                    icon: Icons.call,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileTile(
                    userData: _userData?.user?.email ?? '--',
                    textStyle: textStyle,
                    icon: Icons.mail,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 1.5,
                    color: AppColors.listBGColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '${AppConstants.uploadedAssets}:',
                            style: textStyle,
                          ),
                          Text(
                            ' ${_userData?.uploadedAssetCount ?? '0'}',
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 1.5,
                    color: AppColors.listBGColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '${AppConstants.surveyedAssets}:',
                            style: textStyle,
                          ),
                          Text(
                            ' ${_userData?.surveyedAssetCount ?? '0'}',
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  if ((_userData?.uploadedAssetCount ?? 0) > 0 && (_userData?.surveyedAssetCount ?? 0) > 0)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            _showModalBottomSheet(context);
                          },
                          child: Text(
                            AppConstants.history,
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            if (isLoading == true)
              Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 3.5,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppConstants.cancel,
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> getRefreshTokenData() async {
  //   final dio = Dio(BaseOptions(baseUrl: 'http://stag.voucherskout.com:9000'));
  //   final sessionToken = await SessionManager.getUserDecodedData();
  //
  //   dio.options.headers = {
  //     'content-type': 'application/json',
  //     'accept': 'application/json',
  //     'application-access-key': AppConstants.applicationAccessKey,
  //     'input-parameters': AppConstants.encodedValue,
  //     'session-token': sessionToken?.password,
  //   };
  //
  //   final RefreshTokenRepository _refreshTokenRepository = RefreshTokenRepository();
  //
  //   try {
  //     Response tempResponse = await dio.get(AppConstants.refreshTokenAPI);
  //     log("Response:: ${tempResponse.statusCode}");
  //
  //     var response = await _refreshTokenRepository.getRefreshTokenData();
  //
  //     print("getRefreshToken: ${response.status}");
  //
  //     if (response.status == 200) {
  //       String? encoded = response.data;
  //       String decoded = utf8.decode(base64.decode(encoded ?? ''));
  //       var decodedJson = json.decode(decoded);
  //       log('decodedJson: $decodedJson');
  //       await SessionManager.setUserDecodedData(decodedJson);
  //     } else {
  //       throw Exception('Failed to load data: ${response.status}');
  //       log('decodedJson: _refreshTokenRepository ');
  //     }
  //
  //     if (response.status == 500) {
  //       log('------500----');
  //     }
  //   } on DioException catch (error) {
  //     log('exception: $error');
  //   } catch (e) {
  //     log('catch ');
  //   }
  // }

  /// API call of UserProfile
  Future<void> getAssetStatesData(BuildContext context) async {
    try {
      var response = await _profileRepository.getUserProfileData();

      if (response.status == 200) {
        setState(() {
          isLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        Map<String, dynamic> decodedJson = json.decode(decoded);
        _userData = UserData.fromJson(decodedJson);
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, response.description);
      }
      // if (response.status == 500 || response.status == 401) {
      //   await SessionManager.setIsUserLogin(false);
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const LoginPage(),
      //     ),
      //   );
      // }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            content: const Text(
              AppConstants.sessionExpiredInactivity,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () async {
                    await SessionManager.setIsUserLogin(false);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false);
                  },
                  child: isLoading == false
                      ? Text(
                          AppConstants.reLogin,
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.whiteColor,
                          ),
                        )
                      : SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: AppColors.whiteColor,
                            strokeWidth: 3.5,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      );
      log('Error: $error');
      //showSnackBar(context, error.toString());
    }
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required String? userData,
    required this.textStyle,
    required this.icon,
  }) : _userData = userData;

  final String? _userData;
  final TextStyle textStyle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: AppColors.listBGColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _userData ?? '--',
              style: textStyle,
            ),
            Icon(
              icon,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
