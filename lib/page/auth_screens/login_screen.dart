import 'dart:convert';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/login_conroller.dart';
import 'package:cabme_driver/controller/phone_number_controller.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/add_profile_photo_screen.dart';
import 'package:cabme_driver/page/auth_screens/document_verify_screen.dart';
import 'package:cabme_driver/page/auth_screens/forgot_password.dart';
import 'package:cabme_driver/page/auth_screens/mobile_number_screen.dart';
import 'package:cabme_driver/page/auth_screens/signup_screen.dart';
import 'package:cabme_driver/page/auth_screens/vehicle_info_screen.dart';
import 'package:cabme_driver/page/dash_board.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/themes/text_field_them.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cabme_driver/widget/permission_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:location/location.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();
  final cont = Get.put(PhoneNumberController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LoginController(),
        initState: (state) async {
          try {
            PermissionStatus location = await Location().hasPermission();
            print(location);
            if (PermissionStatus.granted != location) {
              showDialogPermission(context);
            }
          } on PlatformException catch (e) {
            ShowToastDialog.showToast("${e.message}");
          }
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "login".tr,
                        style: const TextStyle(
                            letterSpacing: 0.60,
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      // SizedBox(
                      //     width: 80,
                      //     child: Divider(
                      //       color: ConstantColors.primary,
                      //       thickness: 3,
                      //     )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ConstantColors
                                            .textFieldBoarderColor,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6))),
                                  padding: const EdgeInsets.only(left: 10),
                                  child: IntlPhoneField(
                                    initialCountryCode: "IQ",
                                    onChanged: (phone) {
                                      cont.phoneNumber.value =
                                          phone.completeNumber;
                                    },
                                    invalidNumberMessage: "number invalid",
                                    showDropdownIcon: false,
                                    disableLengthCheck: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                      hintText: 'phone_number'.tr,
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: TextFieldThem.boxBuildTextField(
                                  hintText: 'password'.tr,
                                  controller: _passwordController,
                                  textInputType: TextInputType.text,
                                  obscureText: false,
                                  contentPadding: EdgeInsets.zero,
                                  validators: (String? value) {
                                    if (value!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'required'.tr;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: ButtonThem.buildButton(
                                    context,
                                    title: 'log in'.tr,
                                    btnHeight: 50,
                                    btnColor: ConstantColors.primary,
                                    txtColor: Colors.white,
                                    onPress: () async {
                                      if (_formKey.currentState!.validate()) {
                                        Map<String, String> bodyParams = {
                                          'credential':
                                              cont.phoneNumber.value.trim(),
                                          'mdp': _passwordController.text,
                                          'user_cat': 'driver',
                                        };
                                        await controller
                                            .loginAPI(bodyParams)
                                            .then((value) {
                                          if (value != null) {
                                            print(value.success);
                                            // print(value.error);
                                            // print(value.success);
                                            // print(value.userData!.statut);
                                            print(value.success == "Success");
                                            if (value.success == "Success") {
                                              print("A######33");
                                              Preferences.setString(
                                                  Preferences.user,
                                                  jsonEncode(value));
                                              Preferences.setBoolean(
                                                  Preferences.isLogin, true);
                                              UserData? userData =
                                                  value.userData;

                                              if (userData != null) {
                                                Preferences.setInt(
                                                    Preferences.userId,
                                                    int.parse(userData.id
                                                        .toString()));

                                                print("User Data: $userData");
                                                print(
                                                    "Photo Path: ${userData.photoPath}");
                                                print(
                                                    "Licence Path: ${userData.photoLicencePath}");
                                                print(
                                                    "Vehicle Status: ${userData.statutVehicule}");

                                                if (userData.photoPath ==
                                                        "null" ||
                                                    userData
                                                        .photoPath!.isEmpty) {
                                                  print(
                                                      "Navigating to AddProfilePhotoScreen");
                                                  Get.to(AddProfilePhotoScreen(
                                                      fromOtp: true));
                                                } else if (userData
                                                    .photoLicencePath!
                                                    .isEmpty) {
                                                  print(
                                                      "Navigating to DocumentVerifyScreen");
                                                  Get.to(
                                                      () =>
                                                          DocumentVerifyScreen(
                                                              fromOtp: true),
                                                      duration: const Duration(
                                                          milliseconds: 400),
                                                      transition: Transition
                                                          .rightToLeft);
                                                } else if (userData
                                                            .statutVehicule !=
                                                        "yes" ||
                                                    userData.statutVehicule!
                                                        .isEmpty) {
                                                  print(
                                                      "Navigating to VehicleInfoScreen");
                                                  Get.to(
                                                      () =>
                                                          const VehicleInfoScreen(),
                                                      duration: const Duration(
                                                          milliseconds: 400),
                                                      transition: Transition
                                                          .rightToLeft);
                                                } else {
                                                  print(
                                                      "All conditions satisfied, navigating to Dashboard");
                                                  Get.offAll(DashBoard(),
                                                      duration: const Duration(
                                                          milliseconds: 400),
                                                      transition: Transition
                                                          .rightToLeft);
                                                }
                                              } else {
                                                print("User data is null");
                                              }
                                            } else {
                                              ShowToastDialog.showToast(
                                                  value.error);
                                              print(value.error);
                                            }
                                          }
                                        });
                                      }
                                    },
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Get.to(ForgotPasswordScreen(),
                                      duration: const Duration(
                                          milliseconds:
                                              400), //duration of transitions, default 1 sec
                                      transition: Transition.rightToLeft);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Center(
                                    child: Text(
                                      'forgot'.tr,
                                      style: TextStyle(
                                          color: ConstantColors.primary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(
                              //     padding: const EdgeInsets.only(top: 40),
                              //     child: ButtonThem.buildBorderButton(
                              //       context,
                              //       title: 'Login With Phone Number'.tr,
                              //       btnHeight: 50,
                              //       btnColor: Colors.white,
                              //       txtColor: ConstantColors.primary,
                              //       onPress: () {
                              //         FocusScope.of(context).unfocus();
                              //         Get.to(
                              //             MobileNumberScreen(isLogin: true),
                              //             duration: const Duration(
                              //                 milliseconds:
                              //                     400), //duration of transitions, default 1 sec
                              //             transition: Transition.rightToLeft);
                              //       },
                              //       btnBorderColor: ConstantColors.primary,
                              //     )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'You don’t have an account yet? '.tr,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(MobileNumberScreen(isLogin: false),
                                duration: const Duration(
                                    milliseconds:
                                        400), //duration of transitions, default 1 sec
                                transition: Transition
                                    .rightToLeft); //transition effect);
                          },
                      ),
                      TextSpan(
                        text: 'SIGNUP'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ConstantColors.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(
                                SignupScreen(
                                  phoneNumber: "",
                                ),
                                duration: const Duration(
                                    milliseconds:
                                        400), //duration of transitions, default 1 sec
                                transition: Transition
                                    .rightToLeft); //transition effect);
                          },
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  showDialogPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LocationPermissionDisclosureDialog(),
    );
  }
}
