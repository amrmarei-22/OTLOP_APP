import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:otlop_app/features/home/data/data_source/home_remote_data_source.dart';
import 'package:otlop_app/features/home/presentation/states/brands_states.dart';

 final HomeRemoteDataSource homeRemoteDataSource = HomeRemoteDataSource();
class BrandsCubitCubit extends Cubit<BrandsCubitState> {
 
  BrandsCubitCubit() : super(BrandsCubitInitial());

  Future<void> getBrands() async {
    emit(BrandsCubitLoading());
    await homeRemoteDataSource.getBrands()
        .then (
          onError: (error) {
        emit(BrandsCubitError(error: error.toString()));
      },
      (val) {
        log("brands fetched successfully");
        emit(BrandsCubitSuccess(brands: val));
      });
  }
}
