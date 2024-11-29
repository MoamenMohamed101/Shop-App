import 'package:salla/models/change_favorites_model.dart';
import 'package:salla/models/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeIndexState extends ShopStates {}

class ShopGetHomeDataSuccessState extends ShopStates {}

class ShopGetHomeDataLoadingState extends ShopStates {}

class ShopGetHomeDataErrorState extends ShopStates {
  final String error;

  ShopGetHomeDataErrorState(this.error);
}

class ShopGetCategoriesDataSuccessState extends ShopStates {}

class ShopGetCategoriesDataLoadingState extends ShopStates {}

class ShopGetCategoriesDataErrorState extends ShopStates {
  final String error;

  ShopGetCategoriesDataErrorState(this.error);
}

class ShopChangeFavoritesDataSuccessState extends ShopStates {
  final ChangeFavoritesModel changeFavoritesModel;

  ShopChangeFavoritesDataSuccessState({required this.changeFavoritesModel});
}

class ShopChangeFavoritesDataLoadingState extends ShopStates {}

class ShopChangeFavoritesDataErrorState extends ShopStates {
  final String error;

  ShopChangeFavoritesDataErrorState(this.error);
}

class ShopGetFavoritesDataSuccessState extends ShopStates {}

class ShopGetFavoritesDataLoadingState extends ShopStates {}

class ShopGetFavoritesDataErrorState extends ShopStates {
  final String error;

  ShopGetFavoritesDataErrorState(this.error);
}

class ShopGetProfileDataSuccessState extends ShopStates {}

class ShopGetProfileDataLoadingState extends ShopStates {}

class ShopGetProfileDataErrorState extends ShopStates {
  final String error;

  ShopGetProfileDataErrorState(this.error);
}

class ShopUpdateProfileDataSuccessState extends ShopStates {
  final LoginModel editData;

  ShopUpdateProfileDataSuccessState({required this.editData});

}

class ShopUpdateProfileDataLoadingState extends ShopStates {}

class ShopUpdateProfileDataErrorState extends ShopStates {
  final String error;

  ShopUpdateProfileDataErrorState(this.error);
}