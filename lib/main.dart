import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/bloc_observer.dart';
import 'package:salla/layout/cubit/shop_cubit.dart';
import 'package:salla/layout/shop_layout.dart';
import 'package:salla/modules/login/login_screen.dart';
import 'package:salla/modules/on_boarding_screen.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/get_it_helper.dart';
import 'package:salla/shared/network/local/cache_helper.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();
  await setup();
  await getIt<DioHelper>().init();
  Bloc.observer = MyBlocObserver();
  var onBoarding = CashHelper.getData('onBoarding');
  token = CashHelper.getData('token');
  debugPrint(token);
  Widget startWidget;
  if (onBoarding != null) {
    if (token != null) {
      startWidget = const ShopLayout();
    } else {
      startWidget = LoginScreen();
    }
  } else {
    startWidget = OnBoardingScreen();
  }
  runApp(
    MyApp(
      startWidget: startWidget,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavorites()
            ..getProfileData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 25, fontFamily: "jannah"),
            bodySmall: TextStyle(fontSize: 20, fontFamily: "jannah"),
          ),
        ),
        home: startWidget,
      ),
    );
  }
}
