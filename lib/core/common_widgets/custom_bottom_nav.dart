import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:otlop_app/features/orders/presentation/cubit/orders_cubit.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = colorScheme.primary;
    final unselectedColor = colorScheme.onSurfaceVariant;

    final cartState = context.watch<CartCubit>().state;
    final ordersState = context.watch<OrdersCubit>().state;
    final cartCount = context.watch<CartCubit>().cartItems.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );
    final ordersCount = context.watch<OrdersCubit>().orders.length;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.8),
        ),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 28,
              color: currentIndex == 0 ? selectedColor : unselectedColor,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _svgIcon(context, "assets/icons/search.svg.svg", 1),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: _badgedIcon(
              context,
              _svgIcon(context, "assets/icons/cart.svg.svg", 2),
              cartCount,
            ),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: _badgedIcon(
              context,
              _svgIcon(context, "assets/icons/orders.svg.svg", 3),
              ordersCount,
            ),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              size: 28,
              color: currentIndex == 4 ? selectedColor : unselectedColor,
            ),
            label: "Profile",
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        backgroundColor: colorScheme.surface,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _svgIcon(BuildContext context, String assetPath, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = currentIndex == index
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;
    return SvgPicture.asset(
      assetPath,
      width: 27,
      height: 27,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  Widget _badgedIcon(BuildContext context, Widget icon, int count) {
    if (count == 0) return icon;
    final colorScheme = Theme.of(context).colorScheme;
    return Badge(
      label: Text(count > 99 ? '99+' : '$count'),
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
      child: icon,
    );
  }
}
