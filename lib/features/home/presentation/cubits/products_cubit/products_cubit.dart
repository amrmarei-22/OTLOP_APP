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

 

  

  
}
