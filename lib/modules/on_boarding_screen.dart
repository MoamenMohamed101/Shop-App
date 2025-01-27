import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/shop_cubit.dart';
import 'package:salla/layout/cubit/shop_states.dart';
import 'package:salla/models/onboarding_model.dart';
import 'package:salla/modules/login/login_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/network/local/cache_helper.dart';
import 'package:salla/shared/styles/app_assets.dart';
import 'package:salla/shared/styles/app_strings.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  final PageController controller = PageController();

  final List<OnBoardingModel> pages = [
    OnBoardingModel(
      image: AppAssets.onBoarding1,
      title: AppStrings.onBoarding1Title,
      subTitle: AppStrings.onBoarding1Subject,
    ),
    OnBoardingModel(
      image: AppAssets.onBoarding2,
      title: AppStrings.onBoarding1Title,
      subTitle: AppStrings.onBoarding1Subject,
    ),
    OnBoardingModel(
      image: AppAssets.onBoarding3,
      title: AppStrings.onBoarding3Title,
      subTitle: AppStrings.onBoarding1Subject,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                commonTextButton(
                  text: 'skip',
                  textStyle: const TextStyle(
                    fontSize: 24,
                  ),
                  function: () {
                    controller.jumpToPage(2);
                  },
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: pages.length,
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return buildItem(
                        context: context,
                        onboarding: pages[index],
                        index: index,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, left: 30),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: pages.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  buildItem(
          {required BuildContext context,
          required OnBoardingModel onboarding,
          required int index}) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                onboarding.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              onboarding.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              onboarding.subTitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Expanded(
              child: Row(
                children: [
                  index == 0
                      ? Container()
                      : defaultButton(
                          text: "back",
                          voidCall: () {
                            controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                          width: 10,
                        ),
                  const Spacer(),
                  index == 2
                      ? Container()
                      : defaultButton(
                          width: 10,
                          text: "next",
                          voidCall: () {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                        ),
                  index == 2
                      ? defaultButton(
                          text: 'get started',
                          voidCall: () {
                            CashHelper.saveData('onBoarding', true)
                                .then((onValue) {
                              navigateAndFinish(
                                context: context,
                                widget: LoginScreen(),
                              );
                            });
                          },
                          width: 10,
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      );
}
