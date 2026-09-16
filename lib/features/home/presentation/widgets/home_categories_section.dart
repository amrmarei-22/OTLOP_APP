// home_categories_section.dart

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/app_styles.dart';
import 'package:otlop_app/core/common_widgets/custom_text_button.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/categories_cubit.dart';
import 'package:otlop_app/features/home/presentation/screens/filter_products_screen.dart';
import 'package:otlop_app/features/home/presentation/states/categories_states.dart';

class HomeCategoriesSection extends StatefulWidget {
  const HomeCategoriesSection({super.key});

  @override
  State<HomeCategoriesSection> createState() => _HomeCategoriesSectionState();
}

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
          children: [
            Text("Categories", style: AppStyles.style18Bold),
            
          ],
        ),

        SizedBox(
          height: 120,
          child: BlocBuilder<CategoriesCubit, CategoriesStates>(
            builder: (context, state) {
              if (state is  CategoriesLoadingState) {
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
                          builder: (context) => FilterProductsScreen(
                            title: myCategories[index]['name'],
                            catId: myCategories[index]['id'],
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
                          child: Image.network(
                            myCategories[index]['pictureUrl'],
                            width: 30,
                            height: 40,
                          ),
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
            }
            else {
              log("No categories available");
              return Center(child: Text("No categories available"));
            }},
          ),
        ),
      ],
    );
  }
}
