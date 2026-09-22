// home_categories_section.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/app_styles.dart';
import 'package:otlop_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/categories_cubit.dart';
import 'package:otlop_app/features/home/presentation/screens/filter_products_screen.dart';
import 'package:otlop_app/features/home/presentation/states/categories_states.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeCategoriesSection extends StatefulWidget {
  const HomeCategoriesSection({super.key});

  @override
  State<HomeCategoriesSection> createState() => _HomeCategoriesSectionState();
}

final Map<String, String> categoryIcons = {
  "Frappuccino": "assets/icons/frappe-svgrepo-com.svg",
  "Mocha": "assets/icons/mocha-svgrepo-com.svg",
  "Latte": "assets/icons/latte.svg",
  "Macchiato": "assets/icons/Frapp.svg",
  "Matcha": "assets/icons/cocktail-svgrepo-com.svg",
  "Donuts": "assets/icons/donut-doughnut-sweet-dessert-food-fastfood-svgrepo-com.svg",
  "Cake": "assets/icons/cake-svgrepo-com.svg",
  "Salad": "assets/icons/salad-svgrepo-com.svg",
};

class _HomeCategoriesSectionState extends State<HomeCategoriesSection> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoriesCubit>(context).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Categories", style: AppStyles.style18Bold)],
        ),

        SizedBox(
          height: 120,
          child: BlocBuilder<CategoriesCubit, CategoriesStates>(
            builder: (context, state) {
              if (state is CategoriesLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CategoriesErrorState) {
                return Center(child: Text(state.error));
              } else if (state is CategoriesSuccessState) {
                final myCategories = state.categories;
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 15),
                  scrollDirection: Axis.horizontal,
                  itemCount: myCategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => CategoriesCubit(),
                                ),
                                BlocProvider(
                                  create: (context) => CartCubit(),
                                ),
                              ],
                              child: FilterProductsScreen(
                                title: '${myCategories[index]['name']} Products',
                                catId: myCategories[index]['id'],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.whiteClr,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Builder(builder: (context) {
                              final categoryName = myCategories[index]['name'];
                              final iconPath = categoryIcons[categoryName];
                              if (iconPath != null) {
                                return SvgPicture.asset(
                                  iconPath,
                                  width: 30,
                                  height: 40,
                                );
                              } else {
                                return Icon(
                                  Icons.category,
                                  size: 30,
                                );
                              }
                            }),
                            
                            
                          ),
                          SizedBox(height: 10),
                          Text(
                            myCategories[index]["name"],
                            style: AppStyles.style12.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                log("No categories available");
                return Center(child: Text("No categories available"));
              }
            },
          ),
        ),
      ],
    );
  }
}
