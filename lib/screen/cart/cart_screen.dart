import 'package:flutter/material.dart';
import 'package:petshop/screen/cart/cart_item_card.dart';
import 'package:petshop/service/order_service.dart';
import 'package:provider/provider.dart';

import '../../service/cart_service.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Column(
        children: <Widget>[
          buildCartSummary(cart, context),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: buildCartDetail(cart),
          ),
        ],
      ),
    );
  }

  Widget buildCartDetail(CartService cart) {
    return ListView(
        children: cart.productEntries
            .map(
              (entry) => CartItemCard(
                productId: entry.key,
                cartItem: entry.value,
              ),
            )
            .toList());
  }

  Widget buildCartSummary(CartService cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Tổng',
              style: TextStyle(fontSize: 20),
            ),
            const Spacer(),
            Chip(
              label: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            TextButton(
              onPressed: cart.totalAmount <= 0
                  ? null
                  : () {
                      context.read<OrderService>().addOrder(
                            cart.products,
                            cart.totalAmount,
                          );
                      cart.clear();
                    },
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor),
              ),
              child: const Text('ĐẶT NGAY'),
            ),
          ],
        ),
      ),
    );
  }
}
