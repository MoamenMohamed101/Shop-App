import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/shop_layout.dart';
import 'package:salla/modules/login/login_cubit.dart';
import 'package:salla/modules/login/login_state.dart';
import 'package:salla/modules/register/register_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/local/cache_helper.dart';
import 'package:salla/shared/styles/app_strings.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // mmoamen10@gmail.com
  // moamen10@gmail.com
  // 123456
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Scaffold(
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.login,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppStrings.loginSubTitle,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextFormField(
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                      radius: 10,
                      hintText: "enter email",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextFormField(
                      onField: (value) {
                        if (formKey.currentState!.validate()) {
                          cubit.userLogin(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      textInputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.password,
                      radius: 10,
                      hintText: "enter password",
                      isObscure: cubit.isPassword,
                      suffixIcon: cubit.isPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      isSuffix: true,
                      iconButtonFunction: () {
                        cubit.changePostfixIcon();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoginLoadingState,
                      builder: (BuildContext context) => defaultButton(
                          text: "login",
                          voidCall: () {
                            if (formKey.currentState!.validate()) {
                              cubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          }),
                      fallback: (BuildContext context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 19,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            navigateTo(
                                context: context, widget: RegisterScreen());
                          },
                          child: Text(
                            "Register",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.blue,
                                      fontSize: 17,
                                    ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, LoginState state) {
          if (state is LoginSuccessState) {
            if (state.loginModel!.status!) {
              CashHelper.saveData('token', state.loginModel!.data!.token)
                  .then((onValue) {
                token = state.loginModel!.data!.token;
                showToast(
                  message: state.loginModel!.message!,
                  state: ToastStates.success,
                );
                navigateTo(
                  context: context,
                  widget: const ShopLayout(),
                );
              });
            } else {
              showToast(
                message: state.loginModel!.message!,
                state: ToastStates.error,
              );
            }
          }
        },
      ),
    );
  }
}
