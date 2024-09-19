import 'package:flutter/material.dart';
import 'package:petshop/screen/product/product_manager.dart';
import 'package:provider/provider.dart';
import 'package:petshop/screen/product/product_grid_tile.dart';

class ProductsGrid extends StatelessWidget {
  final String? typePet;
  final String? type;

  ProductsGrid(this.typePet, this.type);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        if (productsManager.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (productsManager.errorMessage != null) {
          return Center(child: Text('Error: ${productsManager.errorMessage}'));
        }

        // Fetch products if not already fetched
        if (productsManager.products.isEmpty) {
          productsManager.fetchProducts(typePet!, type!);
        }

        final products = productsManager.products;

        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              height: 500,
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: products.length,
                itemBuilder: (ctx, i) =>
                    ProductGridTile(products[i], typePet, type),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
