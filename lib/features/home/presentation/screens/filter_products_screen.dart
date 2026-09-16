// features/home/presentation/screens/filter_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/home/presentation/cubits/brands_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/categories_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/products_cubit.dart';
import 'package:otlop_app/features/home/presentation/widgets/home_products_section.dart';

class FilterProductsScreen extends StatelessWidget {
  const FilterProductsScreen({
    super.key,
    required this.title,
    this.catId,
    this.brandId,
  });
  final String title;
  final int? catId, brandId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ProductsCubit()),
            BlocProvider(create: (context) => CategoriesCubit()),
            BlocProvider(create: (context) => BrandsCubitCubit()),
          ],
          child: HomeProductsSection(catId: catId, brandId: brandId),
        ),
      ),
    );
  }
}
