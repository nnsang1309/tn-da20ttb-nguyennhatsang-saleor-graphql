import 'package:flutter/material.dart';
import 'package:petshop/screen/order/order_item_card.dart';
import 'package:petshop/screen/order/order_manager.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersManager = OrdersManager();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: Consumer<OrdersManager>(builder: (ctx, ordersManager, child) {
        return ListView.builder(
          itemCount: ordersManager.orderCount,
          itemBuilder: (context, i) => OrderItemCard(ordersManager.orders[i]),
        );
      }),
    );
  }
}
