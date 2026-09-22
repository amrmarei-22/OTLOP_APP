// main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/common_widgets/custom_bottom_nav.dart';
import 'package:otlop_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:otlop_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:otlop_app/features/explore/presentation/screens/explore_screen.dart';
import 'package:otlop_app/features/home/presentation/cubits/brands_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/categories_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/products_cubit.dart';
import 'package:otlop_app/features/home/presentation/screens/home_screen.dart';
import 'package:otlop_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:otlop_app/features/orders/presentation/screens/orders_screen.dart';
import 'package:otlop_app/features/profile/presentation/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.index});
  final int? index;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex = widget.index ?? 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const CartScreen(),
      const OrdersScreen(),
      ProfileScreen(
        onOrdersTap: () {
          setState(() {
            currentIndex = 3;
          });
        },
      ),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsCubit()),
        BlocProvider(create: (context) => BrandsCubitCubit()),
        BlocProvider(create: (context) => CategoriesCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => OrdersCubit()),
      ],
      child: Scaffold(
        bottomNavigationBar: CustomBottomNav(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        body: screens[currentIndex],
      ),
    );
  }
}
