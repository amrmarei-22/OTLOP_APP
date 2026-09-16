// features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:otlop_app/core/theme/app_styles.dart';
import 'package:otlop_app/features/home/presentation/widgets/home_brands_section.dart';
import 'package:otlop_app/features/home/presentation/widgets/home_categories_section.dart';
import 'package:otlop_app/features/home/presentation/widgets/home_products_section.dart';
import 'package:otlop_app/features/home/presentation/widgets/home_screen_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 30),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeScreenHeader(),
                HomeCategoriesSection(),

                HomeBrandsSection(),
                Text("Popular right now", style: AppStyles.style18Bold),
                HomeProductsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
