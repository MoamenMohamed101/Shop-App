import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/shop_cubit.dart';
import 'package:salla/layout/cubit/shop_states.dart';
import 'package:salla/models/categories_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.categoriesModel != null,
          builder: (BuildContext context) => ListView.separated(
            itemBuilder: (BuildContext context, int index) =>
                buildCategoriesItem(
              cubit.categoriesModel!.data!.categoriesData[index],
              context,
            ),
            separatorBuilder: (BuildContext context, int index) => Container(
              color: Colors.grey,
              height: 1,
              width: double.infinity,
            ),
            itemCount: cubit.categoriesModel!.data!.categoriesData.length,
          ),
          fallback: (BuildContext context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildCategoriesItem(
      CategoriesData categoriesData, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image(
            height: 90,
            fit: BoxFit.cover,
            image: NetworkImage(categoriesData.image),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            categoriesData.name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_sharp),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}