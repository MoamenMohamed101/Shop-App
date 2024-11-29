import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/shop_layout.dart';
import 'package:salla/modules/register/register_cubit.dart';
import 'package:salla/modules/register/register_state.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/local/cache_helper.dart';
import 'package:salla/shared/styles/app_strings.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController(),
      phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            if (state.registerModel.status!) {
              CashHelper.saveData('token', state.registerModel.data!.token)
                  .then((onValue) {
                token = state.registerModel.data!.token;
                showToast(
                  message: state.registerModel.message!,
                  state: ToastStates.success,
                );
                navigateTo(
                  context: context,
                  widget: const ShopLayout(),
                );
              });
            }else{
              showToast(message: state.registerModel.message, state: ToastStates.error);
            }
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
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
                      AppStrings.register,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      AppStrings.registerSubTitle,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 19,
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextFormField(
                      validate: (value) {
                        if (value!.isEmpty) return "Please enter your email";
                        return null;
                      },
                      controller: emailController,
                      textInputType: TextInputType.text,
                      prefixIcon: Icons.email,
                      radius: 10,
                      hintText: "enter your email",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextFormField(
                      validate: (value) {
                        if (value!.isEmpty) return "Please enter your password";
                        return null;
                      },
                      controller: passwordController,
                      textInputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.password,
                      radius: 10,
                      hintText: "enter your password",
                      iconButtonFunction: (){
                        cubit.changePostfixIcon();
                      },
                      suffixIcon: cubit.isPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      isObscure: cubit.isPassword
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextFormField(
                      validate: (value) {
                        if (value!.isEmpty) return "Please enter your name";
                        return null;
                      },
                      controller: nameController,
                      textInputType: TextInputType.name,
                      prefixIcon: Icons.person,
                      radius: 10,
                      hintText: "enter your name",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextFormField(
                      onField: (value) {
                        if (formKey.currentState!.validate()) {
                          cubit.userRegister(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                      validate: (value) {
                        if (value!.isEmpty) return "Please enter your phone";
                        return null;
                      },
                      controller: phoneController,
                      textInputType: TextInputType.phone,
                      prefixIcon: Icons.phone,
                      radius: 10,
                      hintText: "enter your phone",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                      condition: state is! RegisterLoading,
                      builder: (BuildContext context) => defaultButton(
                        text: 'register',
                        voidCall: () {
                          if (formKey.currentState!.validate()) {
                            cubit.userRegister(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                      ),
                      fallback: (BuildContext context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
