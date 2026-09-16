class CategoriesStates {}
class CategoriesInitialState extends CategoriesStates {}
class CategoriesLoadingState extends CategoriesStates {}
class CategoriesSuccessState extends CategoriesStates {
  final List categories;
  CategoriesSuccessState({required this.categories});
}
class CategoriesErrorState extends CategoriesStates {
  final String error;
  CategoriesErrorState({required this.error});
}