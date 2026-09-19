// main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/custom_bottom_nav.dart';
import 'package:otlop_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:otlop_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:otlop_app/features/home/presentation/cubits/brands_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/categories_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/products_cubit.dart';
import 'package:otlop_app/features/home/presentation/screens/home_screen.dart';
import 'package:otlop_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:otlop_app/features/orders/presentation/screens/orders_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key, this.index, this.orderId});
  int? index;
  final int? orderId;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const Center(child: Text("Explore")),
      const CartScreen(),
      OrdersScreen(orderId: widget.orderId),
      const Center(child: Text("Profile")),
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
          currentIndex: widget.index ?? 0,
          onTap: (index) {
            setState(() {
              widget.index = index;
            });
          },
        ),
        body: screens[widget.index ?? 0],
      ),
    );
  }
}
