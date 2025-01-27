import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/shop_cubit.dart';
import 'package:salla/layout/cubit/shop_states.dart';
import 'package:salla/models/favorites_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return cubit.favoritesModel!.data!.data!.isEmpty
            ? emptyData()
            : ConditionalBuilder(
                condition: state is! ShopGetFavoritesDataLoadingState,
                builder: (BuildContext context) => ListView.separated(
                  itemBuilder: (BuildContext context, int index) =>
                      buildFavoritesItem(
                    cubit.favoritesModel!.data!.data![index],
                    context,
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                    color: Colors.grey,
                    height: 1,
                    width: double.infinity,
                  ),
                  itemCount: cubit.favoritesModel!.data!.data!.length,
                ),
                fallback: (BuildContext context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}

Widget buildFavoritesItem(FavoritesData favoritesData, BuildContext context) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 120,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  height: 120,
                  width: 120,
                  image: NetworkImage(
                    favoritesData.product!.image!,
                  ),
                ),
                if (favoritesData.product!.discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: Colors.red,
                    child: Text(
                      "DISCOUNT",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favoritesData.product!.name!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15, height: 1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          favoritesData.product!.price!.toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (favoritesData.product!.discount != 0)
                          Text(
                            favoritesData.product!.oldPrice!.toString(),
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
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
                            ShopCubit.get(context)
                                .changeFavorites(favoritesData.product!.id!);
                          },
                          icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: ShopCubit.get(context)
                                    .favorites[favoritesData.product!.id]!
                                ? Colors.blue
                                : Colors.grey,
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
            ),
          ],
        ),
      ),
    );

Widget emptyData() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            color: Colors.grey.withOpacity(.5),
            size: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Add favorites",
            style: TextStyle(
              color: Colors.grey.withOpacity(.5),
              fontSize: 50,
            ),
          ),
        ],
      ),
    );