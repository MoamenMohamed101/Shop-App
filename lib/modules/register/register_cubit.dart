import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/login_model.dart';
import 'package:salla/modules/register/register_state.dart';
import 'package:salla/shared/get_it_helper.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? registerModel;

  bool isPassword = true;

  void changePostfixIcon(){
    isPassword = !isPassword;
    emit(RegisterChangePostfixIconState());
  }

  void userRegister({
    required String? name,
    required String? email,
    required String? password,
    required String? phone,
  }) {
    emit(RegisterLoading());
    getIt<DioHelper>().postData(endPoint: register, language: 'en', data: {
      'email': email,
      'name': name,
      'password': password,
      'phone': phone,
    }).then(
      (onValue) {
        registerModel = LoginModel.fromJson(onValue.data);
        emit(RegisterSuccess(registerModel: registerModel!));
      },
    ).catchError(
      (onError) {
        emit(RegisterError());
      },
    );
  }
}
