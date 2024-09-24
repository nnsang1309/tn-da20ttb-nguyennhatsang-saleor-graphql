import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/product/product_queries.dart';
import '../model/product.dart';

class ProductService with ChangeNotifier {
  final GraphQLClient client;

  ProductService({required this.client});

  // Danh sách sản phẩm
  List<Product> _productList = [];

  // Lấy danh sách sản phẩm
  List<Product> get products => [..._productList];

  // Lấy danh sách sản phẩm từ API
  Future<List<Product>> getProducts() async {
    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(getProductsList),
        ),
      );

      if (result.hasException) {
        debugPrint('Query exception: ${result.exception.toString()}');
        throw Exception('Query exception: ${result.exception.toString()}');
      }

      if (result.data == null || result.data!['products'] == null) {
        debugPrint('No data found for products');
        throw Exception('No data found for products');
      }

      final List<dynamic> productsData = result.data!['products']['edges'];
      debugPrint('Fetched products: $productsData');

      return productsData
          .map((dynamic product) => Product.fromJson(product['node']))
          .toList();
    } catch (e) {
      debugPrint('Failed to fetch products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Lấy chi tiết sản phẩm theo ID
  Future<Map<String, dynamic>> getProductDetailById(String productId) async {
    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(getProductById),
        variables: {'productId': productId},
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data!['product'] as Map<String, dynamic>;
  }

  // Tìm sản phẩm theo ID
  Product? findById(String id) {
    try {
      return _productList.firstWhere(
        (product) => product.id == id,
      );
    } catch (e) {
      throw Exception('Không tìm thấy sản phẩm với ID: $id');
    }
  }

  // Lấy danh sách sản phẩm
  Future<void> fetchProducts() async {
    _productList = await getProducts();
    notifyListeners();
  }

  // Lọc sản phẩm theo danh mục và loại sản phẩm
  Future<void> filterProducts(String category, String productType) async {
    _productList = _productList // Lọc trên danh sách sản phẩm đã có
        .where((product) =>
            product.category == category && product.productType == productType)
        .toList();
    notifyListeners(); // Cập nhật lại trạng thái
  }
}
