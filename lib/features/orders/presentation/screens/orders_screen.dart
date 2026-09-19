import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/orders/data/models/order_model.dart';
import 'package:otlop_app/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:otlop_app/features/orders/presentation/states/orders_states.dart';

class OrdersScreen extends StatefulWidget {
  final int? orderId;
  const OrdersScreen({super.key, this.orderId});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      context.read<OrdersCubit>().getOrders(widget.orderId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            final orders = state is OrdersSuccessState
                ? state.orders
                : <OrderModel>[];
            return RefreshIndicator(
              color: Colors.deepOrange,
              onRefresh: () =>
                  context.read<OrdersCubit>().getOrders(widget.orderId!),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  const Text(
                    'My Orders',
                    style: TextStyle(
                      color: Color(0xFF10233F),
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${orders.length} orders',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  if (state is OrdersLoadingState ||
                      state is OrdersInitialState)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                      ),
                    )
                  else if (state is OrdersFailureState)
                    _MessageState(
                      message: state.error,
                      onRetry: () => context.read<OrdersCubit>().getOrders(
                        widget.orderId!,
                      ),
                    )
                  else if (orders.isEmpty)
                    const _MessageState(message: 'You have no orders yet.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) =>
                          _OrderCard(order: orders[index]),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color _statusColor(String status) {
    final value = status.toLowerCase();
    if (value.contains('deliver')) return const Color(0xFF269653);
    if (value.contains('cancel')) return const Color(0xFFD64545);
    return const Color(0xFFF28B18);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status);
    final itemCount = order.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final date =
        '${order.orderDate.day.toString().padLeft(2, '0')} ${order.orderDate.month}/${order.orderDate.year}';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    color: Color(0xFF10233F),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 7, color: statusColor),
                      const SizedBox(width: 5),
                      Text(
                        order.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              date,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: order.items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final imageUrl = order.items[index].pictureUrl;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageUrl.isEmpty
                        ? _placeholder()
                        : Image.network(
                            imageUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '$itemCount items · ${order.deliveryMethod}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  '${order.total.toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                    color: Color(0xFF10233F),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 48,
    color: const Color(0xFFF0F2F5),
    child: const Icon(Icons.local_cafe_outlined, color: Colors.grey),
  );
}

class _MessageState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _MessageState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.receipt_long_outlined,
          size: 48,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        if (onRetry != null)
          TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}
