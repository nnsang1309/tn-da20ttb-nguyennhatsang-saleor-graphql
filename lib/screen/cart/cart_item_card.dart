import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petshop/model/cart.dart';
import 'package:petshop/popup/dialog_utils.dart';
import 'package:petshop/screen/cart/cart_manager.dart';

class CartItemCard extends StatelessWidget {
  final String productId;
  final CartItem cartItem;

  const CartItemCard({
    required this.productId,
    required this.cartItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showConfirmDialog(
        context,
        'Do you want to remove the item from the cart?',
      ),
      onDismissed: (direction) {
        context.read<CartManager>().removeItem(productId);
        print('Cart item dismissed');
      },
      child: buildItemCard(),
    );
  }

  Widget buildItemCard() {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$${cartItem.price}'),
              ),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Total: \$${cartItem.price * cartItem.quantity}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
