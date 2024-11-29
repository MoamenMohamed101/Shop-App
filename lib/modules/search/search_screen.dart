import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/search_model.dart';
import 'package:salla/modules/search/search_cubit.dart';
import 'package:salla/modules/search/search_state.dart';
import 'package:salla/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          SearchCubit cubit = SearchCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultTextFormField(
                      onChanged: (value) {
                       cubit.searchData(value);
                      },
                      validate: (value) {
                        if (value!.isEmpty) return "Please search";
                        return null;
                      },
                      controller: searchController,
                      textInputType: TextInputType.text,
                      prefixIcon: Icons.search,
                      radius: 10,
                      hintText: 'search for item',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (state is ShopSearchDataLoadingState)
                      const LinearProgressIndicator(),
                    if (state is ShopSearchDataSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemCount: cubit.searchModel!.data!.data!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              searchWidget(
                            cubit.searchModel!.data!.data![index],
                            context,
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
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

  Widget searchWidget(ResultData resultData, BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 120,
      child: Row(
        children: [
          Image(
            height: 120,
            width: 120,
            image: NetworkImage(
              resultData.image!,
            ),
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
                    resultData.name!,
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
                        resultData.price.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                              fontSize: 15,
                              color: Colors.blue,
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
}