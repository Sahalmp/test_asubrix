import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/cartmodel.dart';

class CartController extends GetxController {
  final _storage = GetStorage();

  RxList<CartItem> cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    List<dynamic>? storedItems = _storage.read('cartItems');
    log(storedItems.toString());

    if (storedItems != null) {
      log(storedItems.toString());
      cartItems.value = storedItems
          .map((item) => CartItem(
                id: item['id'],
                name: item['name'],
                calories: item['calories'],
                amount: item['amount'],
                type: item['type'],
                quantity: item['quantity'],
              ))
          .toList();
    }
  }

  void addToCart(CartItem item) async {
    final existingItem =
        cartItems.firstWhereOrNull((cartItem) => cartItem.id == item.id);
    // log(item.toString());

    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      cartItems.add(item);
    }

    await _storage.write('cartItems', cartItems.toList());
    cartItems.refresh();
  }

  void removeCartItem(CartItem item) {
    final existingItemIndex =
        cartItems.indexWhere((cartItem) => cartItem.id == item.id);

    if (existingItemIndex != -1) {
      if (cartItems[existingItemIndex].quantity > 1) {
        cartItems[existingItemIndex].quantity--;
      } else {
        cartItems.removeAt(existingItemIndex);
      }

      _storage.write('cartItems', cartItems.toList());
      cartItems.refresh();
    }
  }

  void clearCartItems() {
    cartItems.clear();
    _storage.remove('cartItems');
    cartItems.refresh();
  }

  int getQuantityForItem(String itemId) {
    final item =
        cartItems.firstWhereOrNull((cartItem) => cartItem.id == itemId);
    return item?.quantity ?? 0;
  }

  int getTotalItems() {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double calculateTotalAmount() {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item.amount * item.quantity));
  }

  double calculateItemAmount({required CartItem item}) {
    return (item.amount * item.quantity);
  }
}
