import 'package:salla/models/login_model.dart';

abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginSuccessState extends LoginState {
  final LoginModel? loginModel;

  LoginSuccessState(this.loginModel);
}

final class LoginLoadingState extends LoginState {}

final class LoginChangePostfixIconState extends LoginState {}

final class LoginErrorState extends LoginState {
  String? error;

  LoginErrorState(error);
}
