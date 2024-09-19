import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/graphql/product/product_queries.dart';
import 'package:petshop/model/product.dart';
import 'package:petshop/service/graphql_config.dart';

class ProductsManager with ChangeNotifier {
  List<Product> _products = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    //// Sử dụng SchedulerBinding để trì hoãn việc gọi notifyListeners
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void setError(String? errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  void setSelectedProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  Future<void> fetchProducts(String typePet, String type) async {
    setLoading(true);
    try {
      final client = GraphqlConfig.initializeClient().value;
      final result = await client.query(QueryOptions(
        document: gql(getProductsList),
      ));

      if (result.hasException) {
        setError(result.exception.toString());
      } else {
        setProducts(parseProductsList(result.data!, typePet, type));
      }
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  Future<void> fetchProductById(String productId) async {
    setLoading(true);
    try {
      final client = GraphqlConfig.initializeClient().value;
      final result = await client.query(QueryOptions(
        document: gql(getProductById),
        variables: {'productId': productId},
      ));

      if (result.hasException) {
        setError(result.exception.toString());
      } else {
        setSelectedProduct(parseProduct(result.data!));
      }
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  List<Product> parseProductsList(
      Map<String, dynamic> data, String typePet, String type) {
    final List<Product> products = [];
    final edges = data['products']['edges'] as List<dynamic>;
    for (var edge in edges) {
      final node = edge['node'];
      if (node['category']['parent']['slug'] == typePet &&
          node['productType']['slug'] == type) {
        products.add(Product(
          id: node['id'],
          title: node['name'],
          description: node['description'],
          price: node['pricing']['priceRange']['start']['gross']['amount'],
          imageUrl: node['thumbnail']['url'],
          type: node['productType']['slug'],
          typePet: node['category']['parent']['slug'],
          variants: (node['variants'] as List<dynamic>)
              .map((variant) => Variant(
                    id: variant['id'],
                    name: variant['name'],
                  ))
              .toList(),
        ));
      }
    }
    return products;
  }

  Product parseProduct(Map<String, dynamic> data) {
    final node = data['product'];
    return Product(
      id: node['id'],
      title: node['name'],
      description: node['description'],
      price: node['pricing']['priceRange']['start']['gross']['amount'],
      imageUrl: node['media'][0]['url'],
      type: node['productType']['slug'],
      typePet: node['category']['parent']['slug'],
      variants: (node['variants'] as List<dynamic>)
          .map((variant) => Variant(
                id: variant['id'],
                name: variant['name'],
              ))
          .toList(),
    );
  }
}
