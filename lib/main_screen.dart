// main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/custom_bottom_nav.dart';
import 'package:otlop_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/features/home/presentation/cubits/brands_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/categories_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/products_cubit.dart';
import 'package:otlop_app/features/home/presentation/screens/home_screen.dart';
import 'package:otlop_app/orders_screen.dart';

class MainScreen extends StatefulWidget {
   MainScreen({super.key,  this.index});
 int? index;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(
        currentIndex: widget.index ?? 0,
        onTap: (index) {
          setState(() {
            widget.index = index;
          });
        },
      ),
      body: [
        MultiBlocProvider(providers: [
          BlocProvider(create: (context) => ProductsCubit()),
          BlocProvider(create: (context) => BrandsCubitCubit()),
          BlocProvider(create: (context) => CategoriesCubit()),
        ], child: HomeScreen()),
         Center(child: Text("Explore")),
        BlocProvider(create: (context) => ProductsCubit(), child: CartScreen()),
        BlocProvider(create: (context) => ProductsCubit(), child: OrdersScreen()),

        Center(child: Text("Profile")),
      ][widget.index ?? 0],
    );
  }
}
