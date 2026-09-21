import 'package:otlop_app/features/cart/data/models/cart_item_model.dart';

class CartStates {}

class CartInitialState extends CartStates {}

class AddToCartLoadingState extends CartStates {}

class AddToCartSuccessState extends CartStates {
  final String message;
  AddToCartSuccessState({required this.message});
}

class AddToCartFailureState extends CartStates {
  final String error;
  AddToCartFailureState({required this.error});
}

class GetCartItemsLoadingState extends CartStates {}

class GetCartItemsSuccessState extends CartStates {
  final List<CartItemModel> cartItems;
  GetCartItemsSuccessState({required this.cartItems});
}

class ClearCartLoadingState extends CartStates {}

class ClearCartSuccessState extends CartStates {}

class ClearCartFailureState extends CartStates {
  final String error;
  ClearCartFailureState({required this.error});
}

class GetCartItemsFailureState extends CartStates {
  final String error;
  GetCartItemsFailureState({required this.error});
}
