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

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const double deliveryFee = 25;
  bool _isCheckingOut = false;

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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: BlocBuilder<CartCubit, CartStates>(
              builder: (context, state) {
                if (state is GetCartItemsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetCartItemsFailureState) {
                  if (state.error.contains("Internal Server Error")) {
                    return Center(
                      child: Text(
                        "No items in the cart",
                        style: AppStyles.style16Bold.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return Text(
                    state.error,
                    style: TextStyle(color: colorScheme.error),
                  );
                } else if (state is GetCartItemsSuccessState) {
                  final cartItems = state.cartItems;
                  final subtotal = calculateSubtotal(cartItems);
                  final total = calculateTotal(cartItems);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Cart",
                        style: AppStyles.style30ExtraBold.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "${cartItems.length} items",
                        style: AppStyles.style13Medium.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),

                      Column(
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 0,
                                color: colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: colorScheme.outline,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        child: Image.network(
                                          cartItems[index].pictureUrl,
                                          width: 72,
                                          height: 72,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            width: 72,
                                            height: 72,
                                            color: colorScheme
                                                .surfaceContainerHighest,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItems[index].productName,
                                              style: AppStyles.style14Bold
                                                  .copyWith(
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${cartItems[index].brand} · ${cartItems[index].category}',
                                              style: AppStyles.style11Medium
                                                  .copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Text(
                                                  '${cartItems[index].price} EGP',
                                                  style: AppStyles.style14Bold
                                                      .copyWith(
                                                    color: colorScheme.primary,
                                                  ),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  visualDensity:
                                                      VisualDensity.compact,
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
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: 18,
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                                Text(
                                                  '${cartItems[index].quantity}',
                                                  style: AppStyles.style14Bold
                                                      .copyWith(
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                                IconButton(
                                                  visualDensity:
                                                      VisualDensity.compact,
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
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: 18,
                                                    color: colorScheme.primary,
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
                              );
                            },
                          ),
                          if (cartItems.isNotEmpty)
                            Card(
                              elevation: 0,
                              color: colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: colorScheme.outline,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Text(
                                      "Order Summary",
                                      style: AppStyles.style14Bold.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    CustomSummaryItem(
                                      title: 'Subtotal',
                                      value: subtotal,
                                    ),
                                    CustomSummaryItem(
                                      title: 'Delivery Fee',
                                      value: deliveryFee,
                                    ),
                                    Divider(color: colorScheme.outlineVariant),
                                    Row(
                                      children: [
                                        Text(
                                          'Total',
                                          style: AppStyles.style16Bold.copyWith(
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${total.toStringAsFixed(2)} EGP',
                                          style: AppStyles.style16Bold.copyWith(
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (cartItems.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() => _isCheckingOut = true);
                                  final ordersCubit = context
                                      .read<OrdersCubit>();
                                  final cartCubit = context.read<CartCubit>();
                                  try {
                                    final orderId = await ordersCubit
                                        .postAndGetOrder(total: total);
                                    if (orderId == null ||
                                        ordersCubit.state
                                            is OrdersFailureState) {
                                      throw Exception(
                                        ordersCubit.state is OrdersFailureState
                                            ? (ordersCubit.state
                                                      as OrdersFailureState)
                                                  .error
                                            : 'Checkout failed',
                                      );
                                    }
                                    await cartCubit.clearCart();
                                    if (cartCubit.state
                                        is ClearCartFailureState) {
                                      throw Exception(
                                        (cartCubit.state
                                                as ClearCartFailureState)
                                            .error,
                                      );
                                    }
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Order #$orderId placed successfully',
                                        ),
                                      ),
                                    );
                                  } catch (error) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isCheckingOut = false);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _isCheckingOut
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: colorScheme.onPrimary,
                                        ),
                                      )
                                    : Text(
                                        'Proceed to Checkout • ${total.toStringAsFixed(2)} EGP',
                                        style: AppStyles.style14Bold.copyWith(
                                          color: colorScheme.onPrimary,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  );
                } else {
                  return const Center(child: Text("No items in the cart"));
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
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          title,
          style: AppStyles.style14Medium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          '${value.toStringAsFixed(2)} EGP',
          style: AppStyles.style14SemiBold.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
