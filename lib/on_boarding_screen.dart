// ignore_for_file: implicit_call_tearoffs

import 'package:cabme_driver/controller/on_boarding_controller.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Container(
          decoration: const BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/images/8_150 2.png"),
              //   fit: BoxFit.cover,
              // ),
              ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        controller.selectedPageIndex.value != 2
                            ? Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    controller.pageController.jumpToPage(2);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'skip'.tr,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const Offstage(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: controller.selectedPageIndex,
                      itemCount: controller.onBoardingList.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          controller: ScrollController(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 45.0,
                                  vertical: 90.0,
                                ),
                                child: Image.asset(
                                  controller.onBoardingList[index].imageAsset
                                      .toString(),
                                  width: 330,
                                  height: 278,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                                child: Text(
                                  controller.onBoardingList[index].title
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 45.0, vertical: 20.0),
                                child: Text(
                                  controller.onBoardingList[index].description
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: controller.selectedPageIndex.value ==
                            controller.onBoardingList.length - 1
                        ? MainButton(
                            text: "Get started".tr,
                            backGroundColor: ConstantColors.primary,
                            onTap: () {
                              Preferences.setBoolean(
                                  Preferences.isFinishOnBoardingKey, true);
                              Get.offAll(LoginScreen());
                            },
                          )
                        : MainButton(
                            text: "Continue".tr,
                            backGroundColor: ConstantColors.primary,
                            onTap: () {
                              controller.pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SmoothPageIndicator(
                      controller: controller.pageController,
                      count: controller.onBoardingList.length,
                      effect: const ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: Colors.black,
                        dotWidth: 10,
                        dotHeight: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MainButton extends StatelessWidget {
  final String text;
  final Color backGroundColor;
  final VoidCallback onTap;

  const MainButton({
    Key? key,
    required this.text,
    required this.backGroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: backGroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Text(text),
      ),
    );
  }
}
