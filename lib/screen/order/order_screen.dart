import 'package:flutter/material.dart';
import 'package:petshop/screen/order/order_item_card.dart';
import 'package:provider/provider.dart';

import '../../service/order_service.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final ordersManager = OrdersManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: Consumer<OrderService>(builder: (ctx, ordersManager, child) {
        return ListView.builder(
          itemCount: ordersManager.orderCount,
          itemBuilder: (context, i) => OrderItemCard(ordersManager.orders[i]),
        );
      }),
    );
  }
}
