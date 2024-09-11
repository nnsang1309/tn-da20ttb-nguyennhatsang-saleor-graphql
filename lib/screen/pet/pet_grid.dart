import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:petshop/model/pet.dart';
import 'package:petshop/screen/pet/pet_grid_tile.dart';
import 'package:petshop/screen/pet/pet_manager.dart';

class ProductsGrid extends StatelessWidget {
  final int loai;
  final String category;

  ProductsGrid(this.loai, this.category, {super.key});
  // final bool showFavorites;

  // const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productsManager = PetsManager();
    final products = context.read<PetsManager>().filterPet(loai, category);
    print("aaa");
    print(loai);
    print(category);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 5),
          height: 500,
          child: SizedBox(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: products.length,
              itemBuilder: (ctx, i) => ProductGridTile(products[i]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
            ),
          ),
        ),
      ],
    );
  }
}
