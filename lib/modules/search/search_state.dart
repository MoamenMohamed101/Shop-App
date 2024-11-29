abstract class SearchState {}

final class SearchInitial extends SearchState {}

class ShopSearchDataSuccessState extends SearchState {}

class ShopSearchDataLoadingState extends SearchState {}

class ShopSearchDataErrorState extends SearchState {
  final String error;

  ShopSearchDataErrorState(this.error);
}