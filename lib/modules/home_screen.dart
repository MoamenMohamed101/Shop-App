import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/shop_cubit.dart';
import 'package:salla/layout/cubit/shop_states.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/models/home_model.dart';
import 'package:salla/shared/components/components.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopChangeFavoritesDataSuccessState) {
          showToast(
            message: state.changeFavoritesModel.message,
            state: ToastStates.success,
          );
        }
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null,
          builder: (BuildContext context) {
            return bannersBuildItem(cubit.homeModel, context);
          },
          fallback: (BuildContext context) =>
          const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget bannersBuildItem(HomeModel? homeModel, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
            items: homeModel!.data!.banners
                .map(
                  (toElement) =>
                  Image(
                    fit: BoxFit.cover,
                    image: NetworkImage("${toElement.image}"),
                  ),
            )
                .toList(),
            options: CarouselOptions(
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: ShopCubit
                  .get(context)
                  .categoriesModel!
                  .data!
                  .categoriesData
                  .length,
              itemBuilder: (BuildContext context, int index) =>
                  buildCategoriesItem(
                      ShopCubit
                          .get(context)
                          .categoriesModel!
                          .data!
                          .categoriesData[index],
                      context),
              separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(
                width: 10,
              ),
            ),
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              childAspectRatio: 1 / 1.62,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              children: List.generate(
                homeModel.data!.products.length,
                    (index) =>
                    productsBuildItem(homeModel.data!.products[index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productsBuildItem(Products product, BuildContext context) =>
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  width: double.infinity,
                  height: 200,
                  image: NetworkImage(product.image),
                ),
                if (product.discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.red,
                    child: Text(
                      "DISCOUNT",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15, height: 1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        product.price.round().toString(),
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if (product.discount != 0)
                        Text(
                          product.oldPrice.round().toString(),
                          style:
                          Theme
                              .of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                            fontSize: 15,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey,
                            decorationThickness: 2.0,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(product.id);
                        },
                        icon: CircleAvatar(
                          radius: 15,
                          //backgroundColor: product.inFavorites!? Colors.blue : Colors.grey,
                          backgroundColor: ShopCubit
                              .get(context)
                              .favorites[product.id]! ? Colors.blue : Colors
                              .grey,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildCategoriesItem(CategoriesData categoriesData,
      BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image(
          height: 100,
          width: 100,
          fit: BoxFit.cover,
          image: NetworkImage(categoriesData.image),
        ),
        Container(
          width: 100,
          color: Colors.black.withOpacity(.8),
          child: Text(
            textAlign: TextAlign.center,
            categoriesData.name,
            maxLines: 1,
            style: Theme
                .of(context)
                .textTheme
                .bodySmall!
                .copyWith(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
