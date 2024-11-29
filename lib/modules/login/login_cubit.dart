import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/login_model.dart';
import 'package:salla/modules/login/login_state.dart';
import 'package:salla/shared/get_it_helper.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  LoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    getIt<DioHelper>().postData(endPoint: login, data: {
      'email': email,
      'password': password,
    }).then((onValue) {
      loginModel = LoginModel.fromJson(onValue.data);
      emit(LoginSuccessState(loginModel!));
    }).catchError((onError) {
      debugPrint("Error ya moamen: ${onError.toString()}");
      emit(LoginErrorState(onError.toString()));
    });
  }

  void changePostfixIcon(){
    isPassword = !isPassword;
    emit(LoginChangePostfixIconState());
  }
}