import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/shop_cubit.dart';
import 'package:salla/layout/cubit/shop_states.dart';
import 'package:salla/models/login_model.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final TextEditingController emailController = TextEditingController(),
      phoneController = TextEditingController(),
      nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopUpdateProfileDataSuccessState) {
          showToast(message: state.editData.message, state: ToastStates.success);
        }
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.profileModel != null,
          builder: (BuildContext context) {
            emailController.text = cubit.profileModel!.data!.email!;
            nameController.text = cubit.profileModel!.data!.name!;
            phoneController.text = cubit.profileModel!.data!.phone!;
            return profileItem(cubit.profileModel!.data, context, state);
          },
          fallback: (BuildContext context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget profileItem(Data? data, BuildContext context, ShopStates state) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state is ShopUpdateProfileDataLoadingState)
              const LinearProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            defaultTextFormField(
              validate: (value) {
                if (value!.isEmpty) return "Please enter your email";
                return null;
              },
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              radius: 10,
              hintText: 'enter your email',
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
              hintText: 'enter your name',
            ),
            const SizedBox(
              height: 20,
            ),
            defaultTextFormField(
              validate: (value) {
                if (value!.isEmpty) return "Please enter your phone";
                return null;
              },
              controller: phoneController,
              textInputType: TextInputType.phone,
              prefixIcon: Icons.phone,
              radius: 10,
              hintText: 'enter your phone',
            ),
            const SizedBox(
              height: 20,
            ),
            defaultButton(
                text: 'edit',
                voidCall: () {
                  ShopCubit.get(context).updateUserData(
                    name: nameController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            defaultButton(
              text: 'logout',
              voidCall: () {
                signOut(context);
                showToast(
                  message: "Logout successfully",
                  state: ToastStates.success,
                );
              },
            ),
          ],
        ),
      );
}