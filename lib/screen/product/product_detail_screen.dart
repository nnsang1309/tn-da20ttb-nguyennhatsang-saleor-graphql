// lib/screen/product/product_detail_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petshop/model/product.dart';
import '../../service/graphql_config.dart';
import '../../service/product_service.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/pet-detail';
  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  final Product product;

  Future<Map<String, dynamic>> fetchProductById(String id) async {
    final client = GraphqlConfig.initializeClient().value;
    final productService = ProductService(client: client);
    return await productService.getProductDetailById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm"),
        backgroundColor: Colors.blue,
      ),
      // body: FutureBuilder<Map<String, dynamic>>(
      //   future: fetchProductById(productId),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else if (!snapshot.hasData) {
      //       return const Center(child: Text('No data found'));
      //     }

      //     final product = snapshot.data!;
      //     final description = getDecodedDescription(product['description']);

      //     return SingleChildScrollView(
      //       child: Column(
      //         children: <Widget>[
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 height: 300,
      //                 width: 200,
      //                 decoration: const BoxDecoration(
      //                   shape: BoxShape.circle,
      //                 ),
      //                 child: Image.network(
      //                   product['media'][0]['url'],
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //             ],
      //           ),
      //           const SizedBox(height: 20),
      //           Container(
      //             height: 400,
      //             width: double.infinity,
      //             padding: const EdgeInsets.all(20),
      //             child: Column(
      //               children: [
      //                 Text(
      //                   product['name'],
      //                   style: const TextStyle(
      //                     color: Colors.grey,
      //                     fontSize: 20,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                 ),
      //                 Text(
      //                   '${product['pricing']['priceRange']['start']['gross']['amount']} ${product['pricing']['priceRange']['start']['gross']['currency']}',
      //                   style: const TextStyle(
      //                     color: Colors.grey,
      //                     fontSize: 20,
      //                   ),
      //                 ),
      //                 Text(
      //                   description,
      //                   textAlign: TextAlign.justify,
      //                   softWrap: true,
      //                   style: const TextStyle(fontSize: 16),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
    );
  }

  String getDecodedDescription(String jsonString) {
    try {
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      return decodedJson['blocks'][0]['data']['text'];
    } catch (e) {
      return 'Mô tả không khả dụng';
    }
  }
}
