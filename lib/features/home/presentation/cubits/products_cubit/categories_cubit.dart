import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/home/data/data_source/home_remote_data_source.dart';
import 'package:otlop_app/features/home/presentation/states/categories_states.dart';

final HomeRemoteDataSource homeRemoteDataSource = HomeRemoteDataSource();
class CategoriesCubit extends Cubit<CategoriesStates> {
  CategoriesCubit() : super(CategoriesInitialState());

  Future<void> getCategories() async {
    emit(CategoriesLoadingState());
    await homeRemoteDataSource.getCategories()
        .then(
           onError: (error) {
        emit(CategoriesErrorState(error: error.toString()));
      },
      (val) {
        log("categories fetched successfully");
        emit( CategoriesSuccessState(categories: val));
      });
  }

}