// features/home/presentation/widgets/home_products_section.dart
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/app_styles.dart';
import 'package:otlop_app/features/home/data/models/product_model.dart';
import 'package:otlop_app/features/home/presentation/cubits/brands_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/categories_cubit.dart';
import 'package:otlop_app/features/home/presentation/cubits/products_cubit/products_cubit.dart';
import 'package:otlop_app/features/home/presentation/states/products_states.dart';
import 'package:otlop_app/features/home/presentation/screens/products_details_screen.dart';

class HomeProductsSection extends StatefulWidget {
  const HomeProductsSection({super.key, this.catId, this.brandId});
  final int? catId, brandId;
  @override
  State<HomeProductsSection> createState() => _HomeProductsSectionState();
}

class _HomeProductsSectionState extends State<HomeProductsSection> {
 

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsCubit>(context).getProducts(widget.catId, widget.brandId);
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      buildWhen: (previous, current)  { if(current is ProductsSuccessState || current is ProductsFailureState || current is ProductsLoadingState) {
        return true;
      } 
        return false;
      },
      listener: (context, state) => {
        if (state is AddToCartLoadingState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Adding to cart..."),
              duration: Duration(seconds: 1),
            ),
          )
        } else if (state is AddToCartSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: Duration(seconds: 1),
              backgroundColor: AppColors.greenClr,
            ),
          )
        } else if (state is AddToCartFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              duration: Duration(seconds: 1),
              backgroundColor: AppColors.redClr,
            ),
          )
        }
        else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar()
        }
      },
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProductsFailureState) {
          return Text(state.errMessage);
        } else if (state is ProductsSuccessState) {
          final List<ProductModel> products = state.products;
          return products.isEmpty
              ? Text("No products found")
              : GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: .7,
            ),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigate to product details screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(product: products[index]),
                        ),
                      );
                      
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                products[index].image,
                    
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  products[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                    
                                  style: AppStyles.style12.copyWith(
                                    color: AppColors.primayClr,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  products[index].description,
                                  style: AppStyles.style14Bold,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: products[index].price
                                                .toString(),
                                            style: AppStyles.style17Bold.copyWith(
                                              color: AppColors.blackClr,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '  EGP',
                                            style: AppStyles.style10SemiBold
                                                .copyWith(
                                                  color: AppColors.greyClr,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppColors.primayClr,
                                      ),
                                      onPressed: () async {
                                        //* Add to Cart
                                        log("Id: ${products[index].id}");
                                        await BlocProvider.of<ProductsCubit>(context).addToCart(products[index].id);
                                        
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: AppColors.whiteClr,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    left: 15,
                    top: 15,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.blackClr.withValues(alpha: .4),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        products[index].category,
                        style: AppStyles.style12.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteClr,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
