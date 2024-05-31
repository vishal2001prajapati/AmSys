import 'dart:developer';

import 'package:am_sys/data/repository/auth_repository.dart';
import 'package:am_sys/model/login_request/login_reuqest_data.dart';
import 'package:am_sys/model/login_response/user_decoded_data.dart';
import 'package:am_sys/screens/bottom_navigation/view/bottom_navigation_page.dart';
import 'package:am_sys/utils/app_consts/app_consts.dart';
import 'package:am_sys/utils/colors/app_colors.dart';
import 'package:am_sys/utils/loadder/progress_indicator.dart';
import 'package:am_sys/utils/regex/regex.dart';
import 'package:am_sys/utils/session_manager/session_manager.dart';
import 'package:am_sys/utils/snack_bar/snack_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isShow = false;
  bool isLoading = false;
  final AuthRepository _authRepository = AuthRepository();
  late UserDecodedData userDecodedData;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.login,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: const Text(AppConstants.enterEmail),
                fillColor: AppColors.listBGColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.listBGColor,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                // border: const OutlineInputBorder(
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(8),
                //   ),
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderSide: BorderSide(
                //     color: AppColors.primaryColor,
                //     width: 2,
                //   ),
                // ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: !isShow,
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isShow = !isShow;
                    });
                  },
                  icon: isShow
                      ? const Icon(
                          Icons.visibility_outlined,
                        )
                      : const Icon(
                          Icons.visibility_off_outlined,
                        ),
                ),
                label: const Text(AppConstants.enterPassword),
                fillColor: AppColors.listBGColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.listBGColor,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                // border: const OutlineInputBorder(
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(8),
                //   ),
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderSide: BorderSide(
                //     color: AppColors.primaryColor,
                //     width: 2,
                //   ),
                // ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
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
                onPressed: () {
                  _validateAndLogin();
                },
                child: isLoading == false
                    ? Text(
                        AppConstants.login,
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
        ),
      ),
    );
  }

  Future<void> _validateAndLogin() async {
    if (!_validateInput()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await _loginApiCall();
  }

  bool _validateInput() {
    if (emailController.text.isEmpty) {
      showSnackBar(context, AppConstants.pleaseEnterEmailErrorMessage);
      return false;
    } else if (!isValidEmail(emailController.text.trim())) {
      showSnackBar(context, AppConstants.pleaseEnterValidEmailErrorMessage);
      return false;
    } else if (passwordController.text.isEmpty) {
      showSnackBar(context, AppConstants.pleaseEnterPasswordErrorMessage);
      return false;
    } else if (passwordController.text.length < 6) {
      showSnackBar(context, AppConstants.passwordErrorMessage);
      return false;
    }

    return true;
  }

  Future<void> _loginApiCall() async {
    Map<String, String> credentials = {
      "userIdentity": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    String jsonCredentials = json.encode(credentials);
    Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
    String encoded = stringToBase64Url.encode(jsonCredentials);

    /// Header in pass input-parameters
    AppConstants.encodedValue = encoded;
    log('Encoded data is: $encoded');

    var loginRequest = LoginRequestData(
      userIdentity: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      var response = await _authRepository.login(loginRequest);

      if (response.status == 200) {
        setState(() {
          isLoading = false;
        });

        String? encoded = response.data;
        String decoded = utf8.decode(base64.decode(encoded ?? ''));
        Map<String, dynamic> decodedJson = json.decode(decoded);

        userDecodedData = UserDecodedData.fromJson(decodedJson);

        await SessionManager.setUserDecodedData(userDecodedData);
        await SessionManager.setIsUserLogin(true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationBarScreen(),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, AppConstants.invalidCredentialMessage);
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      log('Error: $error');
      showSnackBar(context, error.toString());
    }
  }
}
