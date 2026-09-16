// features/home/presentation/cubits/products_cubit/products_cubit.dart
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/home/data/data_source/home_remote_data_source.dart';
import 'package:otlop_app/features/home/presentation/states/products_states.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitialState());
  final HomeRemoteDataSource homeRemoteDataSource = HomeRemoteDataSource();
  Future<void> getProducts(
    [int? catId,
    int? brandId]
  ) async {
    emit(ProductsLoadingState());
    await homeRemoteDataSource.getProducts(brandId: brandId, categoryId: catId).then(
      onError: (error) {
        // log("Error in cubit: $error");
        emit(ProductsFailureState(errMessage: error.toString()));
      },
      (val) {
        // log("Value in cubit: $val");
        emit(ProductsSuccessState(products: val));
      },
    );
  }

  Future<void> addToCart(int productId) async {
    emit(AddToCartLoadingState());
    await homeRemoteDataSource.addToCart(productId).then(
      onError: (error) {
        log("Error in cubit: $error");
        emit(AddToCartFailureState(error: error.toString()));
        getProducts();
      },
      (val) {
        log("Value in cubit");
        emit(AddToCartSuccessState(message: "Product added to cart successfully"));
        getProducts(); 
      },
    );
  }

  Future <void> getCategories() async {
    emit(GetCategoriesLoadingState());
    await homeRemoteDataSource.getCategories().then(
      onError: (error) {
        log("Error in cubit: $error");
        emit(GetCategoriesFailureState(errMessage: error.toString()));
      },
      (val) {
        // log("Value in cubit: $val");
        emit(GetCategoriesSuccessState(categories: val));
      },
    );
  }

  Future <void> getBrands() async {
    emit(GetBrandsLoadingState());
    await homeRemoteDataSource.getBrands().then(
      onError: (error) {
        // log("Error in cubit: $error");
        emit(GetBrandsFailureState(errMessage: error.toString()));
      },
      (val) {
        // log("Value in cubit: $val");
        emit(GetBrandsSuccessState(brands: val));
      },
    );
  }
}
