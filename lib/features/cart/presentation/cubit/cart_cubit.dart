import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlop_app/features/cart/data/cart_datasource.dart';
import 'package:otlop_app/features/cart/data/models/cart_item_model.dart';
import 'package:otlop_app/features/cart/presentation/states/cart_states.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitialState());
  final CartRemoteDataSource cartRemoteDataSource = CartRemoteDataSource();
  List<CartItemModel> cartItems = [];
  bool _cartLoaded = false;
  Future<void> _addQueue = Future<void>.value();

  Future<void> addOrUpdateProduct({
    required int productId,
    int amountToAdd = 1,
  }) async {
    final operation = _addQueue.then(
      (_) => _addOrUpdateProduct(productId, amountToAdd),
    );
    _addQueue = operation.catchError((_) {});
    await operation;
  }

  Future<void> _addOrUpdateProduct(int productId, int amountToAdd) async {
    emit(AddToCartLoadingState());
    try {
      if (!_cartLoaded) {
        cartItems = await cartRemoteDataSource.getCartItems();
        _cartLoaded = true;
      }

      final itemIndex = cartItems.indexWhere((item) => item.id == productId);
      final existingQuantity = itemIndex == -1
          ? 0
          : cartItems[itemIndex].quantity;
      final newQuantity = existingQuantity + amountToAdd;

      if (itemIndex != -1) {
        cartItems[itemIndex].quantity = newQuantity;
        emit(GetCartItemsSuccessState(cartItems: cartItems));
      }

      await cartRemoteDataSource.addToCart(productId, newQuantity);

      if (itemIndex == -1) {
        cartItems = await cartRemoteDataSource.getCartItems();
        emit(GetCartItemsSuccessState(cartItems: cartItems));
      }
      emit(
        AddToCartSuccessState(message: "Product added to cart successfully"),
      );
    } catch (error) {
      log("Error in cart cubit: $error");
      emit(AddToCartFailureState(error: error.toString()));
    }
  }

  Future<void> getCartItems() async {
    emit(GetCartItemsLoadingState());
    try {
      final cartItems = await cartRemoteDataSource.getCartItems();
      this.cartItems = cartItems;
      _cartLoaded = true;
      emit(GetCartItemsSuccessState(cartItems: this.cartItems));
    } catch (error) {
      log("Error in d cubit: $error");
      emit(GetCartItemsFailureState(error: error.toString()));
    }
  }

  Future<void> updateCartItem(int id, int quantity) async {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity = quantity;
      }
    }

    emit(GetCartItemsSuccessState(cartItems: cartItems));

    try {
      if (quantity <= 0) {
        await cartRemoteDataSource.removeFromCart(id);
      } else {
        await cartRemoteDataSource.addToCart(id, quantity);
      }
    } catch (error) {
      log("Error in cart cubit: $error");
      await getCartItems();
    }
  }
}
