import 'package:salla/models/login_model.dart';

abstract class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final LoginModel registerModel;

  RegisterSuccess({required this.registerModel});
}

final class RegisterError extends RegisterState {}

final class RegisterChangePostfixIconState extends RegisterState {}
