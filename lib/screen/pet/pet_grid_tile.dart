import 'package:flutter/material.dart';
import 'package:petshop/screen/pet/pet_detail_screen.dart';
import 'package:provider/provider.dart';

import 'package:petshop/model/pet.dart';
import 'package:petshop/screen/cart/cart_manager.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(
    this.product, {
    super.key,
  });

  final Pet product;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: buildGridFooterBar(context),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PetDetailScreen(product),
              ),
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildGridFooterBar(BuildContext context) {
    return GridTileBar(
      backgroundColor: const Color.fromARGB(221, 157, 152, 152),
      title: Text(
        product.title,
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.shopping_cart,
        ),
        //add item to card
        onPressed: () {
          print('Add item to card');
          final cart = context.read<CartManager>();
          cart.addItem(product);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: const Text(
                  'Item added to cart',
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id!);
                  },
                ),
              ),
            );
        },
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
