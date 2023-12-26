import 'package:chair_shop/model/product_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Cart {
  List<ProductData> items = [];
}

class CartProvider {
  final String key = 'cart';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<ProductData>> getCartItems() async {
    final prefs = await _prefs;
    final cartJson = prefs.getString(key);

    if (cartJson != null) {
      List<dynamic> cartList = json.decode(cartJson);
      List<ProductData> cartItems =
          cartList.map((item) => ProductData.fromJson(item)).toList();
      return cartItems;
    } else {
      return [];
    }
  }

  Future<void> updateCartItems(List<ProductData> cartItems) async {
    final prefs = await _prefs;
    final cartList = cartItems.map((item) => item.toJson()).toList();
    final cartJson = json.encode(cartList);
    await prefs.setString(key, cartJson);
  }

  Future<void> removeCartItem(String productId) async {
    final prefs = await _prefs;
    final cartJson = prefs.getString(key);
    if (cartJson != null) {
      List<dynamic> cartList = json.decode(cartJson);
      List<ProductData> cartItems =
          cartList.map((item) => ProductData.fromJson(item)).toList();
      int indexToRemove =
          cartItems.indexWhere((item) => item.productId == productId);
      if (indexToRemove != -1) {
        cartItems.removeAt(indexToRemove);
        final updatedCartJson = json.encode(cartItems);
        await prefs.setString(key, updatedCartJson);
      }
    }
  }
}
