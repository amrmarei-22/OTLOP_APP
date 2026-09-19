// cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/core/theme/app_colors.dart';
import 'package:otlop_app/core/theme/app_styles.dart';
import 'package:otlop_app/features/cart/data/models/cart_item_model.dart';
import 'package:otlop_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:otlop_app/features/cart/presentation/states/cart_states.dart';
import 'package:otlop_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:otlop_app/features/orders/presentation/states/orders_states.dart';
import 'package:otlop_app/main_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const double deliveryFee = 25;

  double calculateSubtotal(List<CartItemModel> cartItems) {
    return cartItems.fold(
      0,
      (subtotal, item) => subtotal + (item.price * item.quantity),
    );
  }

  double calculateTotal(List<CartItemModel> cartItems) {
    return calculateSubtotal(cartItems) + deliveryFee;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartCubit>(context).getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: BlocBuilder<CartCubit, CartStates>(
              builder: (context, state) {
                if (state is GetCartItemsLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is GetCartItemsFailureState) {
                  if (state.error.contains("Internal Server Error")) {
                    return Center(
                      child: Text(
                        "No items in the cart",
                        style: AppStyles.style16Bold,
                      ),
                    );
                  }
                  return Text(state.error);
                } else if (state is GetCartItemsSuccessState) {
                  final cartItems = state.cartItems;
                  final subtotal = calculateSubtotal(cartItems);
                  final total = calculateTotal(cartItems);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Cart", style: AppStyles.style30ExtraBold),
                      Text(
                        "${cartItems.length} items",
                        style: AppStyles.style13Medium.copyWith(
                          color: AppColors.greyClr,
                        ),
                      ),
                      SizedBox(height: 10),

                      Column(
                        children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  15,
                                                ),
                                            child: Image.network(
                                              cartItems[index].pictureUrl,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItems[index].productName,
                                              style: AppStyles.style14Bold,
                                            ),
                                            Text(
                                              '${cartItems[index].brand} · ${cartItems[index].category}',
                                              style: AppStyles.style11Medium,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${cartItems[index].price} EGP',
                                                  style: AppStyles.style14Bold,
                                                ),
                                                Spacer(),
                                                IconButton(
                                                  onPressed: () {
                                                    final currentQuantity =
                                                        cartItems[index]
                                                            .quantity;
                                                    context
                                                        .read<CartCubit>()
                                                        .updateCartItem(
                                                          cartItems[index].id,
                                                          currentQuantity - 1,
                                                        );
                                                  },
                                                  icon: Icon(Icons.remove),
                                                ),
                                                Text(
                                                  '${cartItems[index].quantity}',
                                                  style: AppStyles.style14Bold,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    final currentQuantity =
                                                        cartItems[index]
                                                            .quantity;
                                                    context
                                                        .read<CartCubit>()
                                                        .updateCartItem(
                                                          cartItems[index].id,
                                                          currentQuantity + 1,
                                                        );
                                                  },
                                                  icon: Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if (cartItems.isNotEmpty)
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Text(
                                      "Order Summary",
                                      style: AppStyles.style14Bold,
                                    ),
                                    SizedBox(height: 10),
                                    CustomSummaryItem(
                                      title: 'Subtotal',
                                      value: subtotal,
                                    ),
                                    CustomSummaryItem(
                                      title: 'Delivery Fee',
                                      value: deliveryFee,
                                    ),

                                    Divider(),

                                    Row(
                                      children: [
                                        Text(
                                          'Total',
                                          style: AppStyles.style16Bold,
                                        ),
                                        Spacer(),
                                        Text(
                                          '${total.toStringAsFixed(2)} EGP',
                                          style: AppStyles.style16Bold.copyWith(
                                            color: AppColors.primayClr,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (cartItems.isNotEmpty) ...[
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final ordersCubit = context
                                      .read<OrdersCubit>();
                                  final orderId = await ordersCubit
                                      .postAndGetOrder();
                                  if (!context.mounted) return;
                                  if (orderId == null ||
                                      ordersCubit.state is OrdersFailureState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          (ordersCubit.state
                                                  as OrdersFailureState)
                                              .error,
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MainScreen(
                                        index: 3,
                                        orderId: orderId,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primayClr,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  'Proceed to Checkout • ${total.toStringAsFixed(2)} EGP',
                                  style: AppStyles.style14Bold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 30),
                    ],
                  );
                } else {
                  return Center(child: Text("No items in the cart"));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSummaryItem extends StatelessWidget {
  const CustomSummaryItem({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final double value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppStyles.style14Medium.copyWith(color: AppColors.greyClr),
        ),
        Spacer(),
        Text(
          '${value.toStringAsFixed(2)} EGP',
          style: AppStyles.style14SemiBold,
        ),
      ],
    );
  }
}
