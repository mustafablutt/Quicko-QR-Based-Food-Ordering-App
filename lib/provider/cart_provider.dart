import 'package:flutter/cupertino.dart';
import 'package:quicko/models/cart_attributes.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttributes> _cartItems = {};

  Map<String, CartAttributes> get getCartItems {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.00;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addProductToCart(String productName, String productId, List imageUrl,
      int quantity, int productQuantity, double price, String vendorId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
              (existingCart) => CartAttributes(
              productName: existingCart.productName,
              productId: existingCart.productId,
              imageUrl: existingCart.imageUrl,
              quantity: existingCart.quantity + 1,
              productQuantity: existingCart.productQuantity,
              price: existingCart.price,
              vendorId: existingCart.vendorId));
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
              () => CartAttributes(
              productName: productName,
              productId: productId,
              imageUrl: imageUrl,
              quantity: quantity,
              productQuantity: productQuantity,
              price: price,
              vendorId: vendorId));
      notifyListeners();
    }
  }

  void increment(CartAttributes cartAttributes) {
    cartAttributes.increase();
    notifyListeners();
  }

  void decreament(CartAttributes cartAttributes) {
    cartAttributes.decrease();
    notifyListeners();
  }

  void removeItem(productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void removeAllItem() {
    _cartItems.clear();
    notifyListeners();
  }

  bool isVendorIdSame(String newVendorId) {
    if (_cartItems.isEmpty) {
      return true;
    } else {
      final existingVendorId = _cartItems.values.first.vendorId;
      for (var item in _cartItems.values) {
        if (item.vendorId != existingVendorId || newVendorId != existingVendorId) {
          return false;
        }
      }
      return true;
    }
  }
}