// features/home/presentation/widgets/home_products_section.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/app_styles.dart';
import 'package:otlop_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:otlop_app/features/cart/presentation/states/cart_states.dart';
import 'package:otlop_app/features/home/data/models/product_model.dart';
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
    BlocProvider.of<ProductsCubit>(
      context,
    ).getProducts(widget.catId, widget.brandId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProductsFailureState) {
          return Text(state.errMessage);
        } else if (state is ProductsSuccessState) {
          final List<ProductModel> products = state.products;
          return products.isEmpty
              ? Text("No products found")
              : BlocListener<CartCubit, CartStates>(
                  listener: (context, state) {
                    if (state is AddToCartLoadingState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Adding to cart..."),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else if (state is AddToCartSuccessState) {
                      context.read<CartCubit>().getCartItems();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          duration: Duration(seconds: 1),
                          backgroundColor: AppColors.greenClr,
                        ),
                      );
                    } else if (state is AddToCartFailureState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          duration: Duration(seconds: 1),
                          backgroundColor: AppColors.redClr,
                        ),
                      );
                    }
                  },
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      final colorScheme = Theme.of(context).colorScheme;
                      return Stack(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<CartCubit>(context),
                                    child: DetailsScreen(
                                      product: products[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: colorScheme.outline,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        products[index].image,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: colorScheme.surfaceContainerHighest,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      spacing: 5,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          products[index].name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.style12.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          products[index].description,
                                          style: AppStyles.style14Bold.copyWith(
                                            color: colorScheme.onSurface,
                                          ),
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
                                                    style: AppStyles.style17Bold
                                                        .copyWith(
                                                          color: colorScheme
                                                              .onSurface,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: '  EGP',
                                                    style: AppStyles
                                                        .style10SemiBold
                                                        .copyWith(
                                                          color: colorScheme
                                                              .onSurfaceVariant,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    colorScheme.primary,
                                              ),
                                              onPressed: () async {
                                                //* Add to Cart
                                                log(
                                                  "Id: ${products[index].id}",
                                                );
                                                await context
                                                    .read<CartCubit>()
                                                    .addOrUpdateProduct(
                                                      productId:
                                                          products[index].id,
                                                      amountToAdd: 1,
                                                    );
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                color: colorScheme.onPrimary,
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .55),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                products[index].category,
                                style: AppStyles.style12.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }
}
