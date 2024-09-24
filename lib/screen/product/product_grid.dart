// /*
//   This is PRODUCT GIRD

//   Hiển thị một lưới các sản phẩm dựa trên hai tham số đầu  vào:

//   - category (chó, mèo, thỏ)
//   - productType (thức ăn, quần áo, phụ kiện)
// */

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../model/product.dart';
// import '../../service/product_service.dart';
// import '../product/product_grid_tile.dart';

// class ProductsGrid extends StatelessWidget {
//   ProductsGrid(this.category, this.productType, this.products, {super.key});

//   final String category; //(Chó, Mèo, Thỏ)
//   final String productType; //(Thức ăn, Quần áo, Phụ kiện)
//   final List<Product> products;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Product>>(
//       future:
//           context.read<ProductService>().filterProduct(category, productType),
//       builder: (ctx, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else {
//           if (snapshot.error != null) {
//             // Log the error for debugging
//             print('Error fetching products: ${snapshot.error.toString()}');
//             // Display a more informative message to the user
//             return Center(child: Text('Error fetching products.'));
//           } else {
//             return Consumer<ProductService>(
//               builder: (ctx, productService, child) {
//                 final products = snapshot.data ?? []; // Kiểm tra null
//                 print("test");
//                 print(category);
//                 print(productType);
//                 return Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.only(top: 5),
//                       height: 500,
//                       child: SizedBox(
//                         child: GridView.builder(
//                           padding: const EdgeInsets.all(10.0),
//                           // Sử dụng snapshot.data.length
//                           itemCount: products.length,
//                           itemBuilder: (ctx, i) => ProductGridTile(products[i]),
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: 3 / 2,
//                             crossAxisSpacing: 10,
//                             mainAxisSpacing: 10,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         }
//       },
//     );
//   }
// }

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
