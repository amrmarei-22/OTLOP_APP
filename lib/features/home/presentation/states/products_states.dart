// features/home/presentation/cubits/products_cubit/products_states.dart
import 'package:otlop_app/features/home/data/models/product_model.dart';

class ProductsState {}

class ProductsInitialState extends ProductsState {}

class ProductsLoadingState extends ProductsState {}

class ProductsSuccessState extends ProductsState {
  final List<ProductModel> products;

  ProductsSuccessState({required this.products});
}

class ProductsFailureState extends ProductsState {
  final String errMessage;

  ProductsFailureState({required this.errMessage});
}
class GetCategoriesLoadingState extends ProductsState {}
class GetCategoriesSuccessState extends ProductsState {
  final List categories;

  GetCategoriesSuccessState({required this.categories});
}
class GetCategoriesFailureState extends ProductsState {
  final String errMessage;

  GetCategoriesFailureState({required this.errMessage});
}

class GetBrandsLoadingState extends ProductsState {}
class GetBrandsSuccessState extends ProductsState {
  final List brands;

  GetBrandsSuccessState({required this.brands});
}
class GetBrandsFailureState extends ProductsState {
  final String errMessage;

  GetBrandsFailureState({required this.errMessage});
}

