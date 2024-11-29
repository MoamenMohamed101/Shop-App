import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/shop_cubit.dart';
import 'package:salla/layout/cubit/shop_states.dart';
import 'package:salla/modules/search/search_screen.dart';
import 'package:salla/shared/components/components.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Salla',style: Theme.of(context).textTheme.bodyMedium,),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context: context,widget: SearchScreen());
                },
                icon: const Icon(Icons.search),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.items,
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
          ),
          body: cubit.pages[cubit.currentIndex],
        );
      },
    );
  }
}
