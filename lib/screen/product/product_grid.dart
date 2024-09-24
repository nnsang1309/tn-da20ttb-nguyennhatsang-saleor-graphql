/*
  This is PRODUCT GIRD

  Hiển thị một lưới các sản phẩm dựa trên hai tham số đầu  vào:

  - category (chó, mèo, thỏ)
  - productType (thức ăn, quần áo, phụ kiện)
  - product 

 */

import 'package:flutter/material.dart';
import '../../model/product.dart';
import '../product/product_grid_tile.dart';

class ProductsGrid extends StatelessWidget {
  ProductsGrid(this.category, this.productType, this.products, {super.key});

  final String category; //(Chó, Mèo, Thỏ)
  final String productType; //(Thức ăn, Quần áo, Phụ kiện)
  final List<Product> products; // Danh sách sản phẩm đã được lọc

  @override
  Widget build(BuildContext context) {
    // Lọc sản phẩm theo loại sản phẩm
    final filteredProducts = products.where((product) {
      return product.category == category && product.productType == productType;
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: filteredProducts.length,
      itemBuilder: (ctx, i) => ProductGridTile(filteredProducts[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
