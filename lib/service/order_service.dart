import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petshop/model/cart.dart';
import 'package:petshop/model/order.dart';

class OrderService with ChangeNotifier {
  final List<OrderItem> _orders = [];
  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    _orders.insert(
      0,
      OrderItem(
        id: 'o${DateTime.now().toIso8601String()}',
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
