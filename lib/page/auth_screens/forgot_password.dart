import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/forgot_password_controller.dart';
import 'package:cabme_driver/controller/phone_number_controller.dart';
import 'package:cabme_driver/page/auth_screens/forgot_password_otp_screen.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/themes/text_field_them.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = Get.put(ForgotPasswordController());

  static final _formKey = GlobalKey<FormState>();
  final cont = Get.put(PhoneNumberController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot Password".tr,
                        style: const TextStyle(
                            letterSpacing: 0.60,
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                          width: 80,
                          child: Divider(
                            color: ConstantColors.primary,
                            thickness: 3,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Enter the email address we will send an OPT to create new password."
                              .tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              letterSpacing: 1.0,
                              color: ConstantColors.hintTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: IntlPhoneField(
                          initialCountryCode: "IQ",
                          onChanged: (phone) {
                            cont.phoneNumber.value = phone.completeNumber;
                          },
                          invalidNumberMessage: "number invalid",
                          showDropdownIcon: false,
                          disableLengthCheck: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                            hintText: 'Phone number'.tr,
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: ButtonThem.buildButton(
                            context,
                            title: 'send'.tr,
                            btnHeight: 50,
                            btnColor: ConstantColors.primary,
                            txtColor: Colors.white,
                            onPress: () {
                              FocusScope.of(context).unfocus();
                              if (cont.phoneNumber.isNotEmpty) {
                                Map<String, String> bodyParams = {
                                  'credential': cont.phoneNumber.value.trim(),
                                  'user_cat': "driver",
                                };
                                cont.sendCode(
                                  cont.phoneNumber.value,
                                  true,
                                  bodyParams,
                                );
                                //     .then((value) {
                                //   if (value != null) {
                                //     if (value == true) {
                                //       ShowToastDialog.showToast(
                                //           "OTP sent successfully".tr);
                                //       // Get.to(
                                //       //     ForgotPasswordOtpScreen(
                                //       //         email: _emailTextEditController
                                //       //             .text
                                //       //             .trim()),
                                //       //     duration:
                                //       //         const Duration(milliseconds: 400),
                                //       //     //duration of transitions, default 1 sec
                                //       //     transition: Transition.rightToLeft);
                                //     } else {
                                //       ShowToastDialog.showToast(
                                //           "Please try again later".tr);
                                //     }
                                //   }
                                // });
                              }
                            },
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
