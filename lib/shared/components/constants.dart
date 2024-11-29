import 'package:flutter/cupertino.dart';
import 'package:salla/modules/login/login_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/network/local/cache_helper.dart';

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach(
        (element) => debugPrint(
      element.group(0),
    ),
  );
}

String? token = '';

signOut(context) {
  CashHelper.removeData('token').then((value) {
    if (value) {
      navigateAndFinish(context: context, widget: LoginScreen());
    }
  });
}