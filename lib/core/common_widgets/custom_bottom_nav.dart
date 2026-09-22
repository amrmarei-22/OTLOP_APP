import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    const selectedColor = Colors.deepOrange;
    const unselectedColor = Colors.grey;

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex == 0 ? selectedColor : unselectedColor,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: _svgIcon("assets/icons/search.svg.svg", 1),
          label: "explore",
        ),
        BottomNavigationBarItem(
          icon: _svgIcon("assets/icons/cart.svg.svg", 2),
          label: "cart",
        ),
        BottomNavigationBarItem(
          icon: _svgIcon("assets/icons/orders.svg.svg", 3),
          label: "orders",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle_outlined,
            color: currentIndex == 4 ? selectedColor : unselectedColor,
          ),
          label: "Profile",
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget _svgIcon(String assetPath, int index) {
    final color = currentIndex == index ? Colors.deepOrange : Colors.grey;
    return SvgPicture.asset(
      assetPath,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
