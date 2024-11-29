import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/search_model.dart';
import 'package:salla/modules/search/search_state.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/get_it_helper.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);


  SearchModel? searchModel;

  void searchData(String? text) {
    emit(ShopSearchDataLoadingState());
    getIt<DioHelper>().postData(
        endPoint: search,
        authorization: token,
        language: 'en',
        data: {
          'text': text,
        }).then(
          (onValue) {
        searchModel = SearchModel.fromJson(onValue.data);
        emit(ShopSearchDataSuccessState());
      },
    ).catchError(
          (onError) {
        emit(ShopSearchDataErrorState(onError.toString()));
      },
    );
  }
}
