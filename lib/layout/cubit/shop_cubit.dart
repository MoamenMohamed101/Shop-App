import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/cubit/shop_states.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/models/change_favorites_model.dart';
import 'package:salla/models/favorites_model.dart';
import 'package:salla/models/home_model.dart';
import 'package:salla/models/login_model.dart';
import 'package:salla/modules/category_screen.dart';
import 'package:salla/modules/favorites_screen.dart';
import 'package:salla/modules/home_screen.dart';
import 'package:salla/modules/settings_screen.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/get_it_helper.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> pages = [
    const ProductsScreen(),
    const CategoryScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.production_quantity_limits),
      label: "products",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: "categories",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: "favorite",
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: "settings",
    ),
  ];

  void changeIndex(index) {
    currentIndex = index;
    emit(ShopChangeIndexState());
  }

  HomeModel? homeModel;
  CategoriesModel? categoriesModel;
  ChangeFavoritesModel? changeFavoritesModel;
  Map<int, bool?> favorites = {};

  void getHomeData() {
    emit(ShopGetHomeDataLoadingState());
    getIt<DioHelper>().getData(endPoint: home, authorization: token).then(
      (onValue) {
        homeModel = HomeModel.fromJson(onValue.data);
        for (var action in homeModel!.data!.products) {
          favorites.addAll({action.id: action.inFavorites});
        }
        emit(ShopGetHomeDataSuccessState());
      },
    ).catchError(
      (onError) {
        emit(ShopGetHomeDataErrorState(onError.toString()));
      },
    );
  }

  void getCategoriesData() {
    emit(ShopGetCategoriesDataLoadingState());
    getIt<DioHelper>().getData(endPoint: categories, language: 'en').then(
      (onValue) {
        categoriesModel = CategoriesModel.fromJson(onValue.data);
        emit(ShopGetCategoriesDataSuccessState());
      },
    ).catchError(
      (onError) {
        debugPrint(onError.toString());
        emit(ShopGetCategoriesDataErrorState(onError.toString()));
      },
    );
  }

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesDataLoadingState());
    getIt<DioHelper>().postData(
      endPoint: favoritesEndPoint,
      authorization: token,
      data: {'product_id': productId},
    ).then((onValue) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(onValue.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      }
      getFavorites();
      emit(
        ShopChangeFavoritesDataSuccessState(
            changeFavoritesModel: changeFavoritesModel!),
      );
    }).catchError((onError) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopChangeFavoritesDataErrorState(onError.toString()));
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopGetFavoritesDataLoadingState());
    getIt<DioHelper>()
        .getData(
            endPoint: favoritesEndPoint, authorization: token, language: 'en')
        .then(
      (onValue) {
        emit(ShopGetFavoritesDataSuccessState());
        favoritesModel = FavoritesModel.fromJson(onValue.data);
      },
    ).catchError(
      (onError) {
        emit(ShopGetFavoritesDataErrorState(onError.toString()));
      },
    );
  }

  LoginModel? profileModel;

  void getProfileData() {
    emit(ShopGetProfileDataLoadingState());
    getIt<DioHelper>()
        .getData(endPoint: profile, language: 'en', authorization: token)
        .then(
      (onValue) {
        profileModel = LoginModel.fromJson(onValue.data);
        emit(ShopGetProfileDataSuccessState());
      },
    ).catchError(
      (onError) {
        emit(ShopGetProfileDataErrorState(onError.toString()));
      },
    );
  }

  LoginModel? editData;

  void updateUserData({
    required String? name,
    required String? phone,
    required String? email,
  }) {
    emit(ShopUpdateProfileDataLoadingState());
    getIt<DioHelper>()
        .updateData(
      endPoint: updateProfile,
      data: {
        'name': name,
        'phone': phone,
        'email': email,
      },
      language: 'en',
      authorization: token,
    )
        .then(
      (onValue) {
        editData = LoginModel.fromJson(onValue.data);
        getProfileData();
        emit(ShopUpdateProfileDataSuccessState(editData: editData!));
      },
    ).catchError(
      (onError) {
        emit(ShopUpdateProfileDataErrorState(onError.toString()));
      },
    );
  }
}
