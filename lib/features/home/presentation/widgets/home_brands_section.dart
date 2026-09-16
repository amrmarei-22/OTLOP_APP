// home_brands_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/app_styles.dart';
import 'package:otlop_app/features/home/presentation/cubits/brands_cubit.dart';
import 'package:otlop_app/features/home/presentation/states/brands_states.dart';
import 'package:otlop_app/features/home/presentation/screens/filter_products_screen.dart';

class HomeBrandsSection extends StatefulWidget {
  const HomeBrandsSection({super.key});

  @override
  State<HomeBrandsSection> createState() => _HomeBrandsSectionState();
}

class _HomeBrandsSectionState extends State<HomeBrandsSection> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BrandsCubitCubit>(context).getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Brands", style: AppStyles.style18Bold),
        SizedBox(height: 10),
        SizedBox(
          height: 55,
          child: BlocBuilder<BrandsCubitCubit, BrandsCubitState>(
            
            builder: (context, state) {
              if (state is BrandsCubitLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is BrandsCubitError) {
                return Center(child: Text("Error: ${state.error}"));
              }

              else if (state is BrandsCubitSuccess) {
                final brands = state.brands;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.whiteClr,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilterProductsScreen(
                            title: brands[index]['name'],
                            brandId: brands[index]['id'],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      brands[index]['name'],
                      style: AppStyles.style14SemiBold.copyWith(
                        color: AppColors.blackClr,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 15);
                },
              );
            }
            else {
                return Center(child: Text("No brands found"));
              }
            },
          ),
        ),
      ],
    );
  }
}
