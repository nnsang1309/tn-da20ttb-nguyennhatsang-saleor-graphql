// lib/screen/product/product_detail_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petshop/model/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/pet-detail';

  const ProductDetailScreen(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final description =
        product.getDecodedDescription(); // Use the method from Product model

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 400,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  //Product name
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Product price
                  Text(
                    '${product.pricing} VND',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  //Product description
                  Text(
                    description,
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
