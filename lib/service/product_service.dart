import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/common/app_constants.dart';
import 'package:petshop/model/product_model.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService with ChangeNotifier {
  late ValueNotifier<GraphQLClient> client = GraphqlConfig.initializeClient();

  ProductService({bool? ignoreToken}) {
    _initializeClient(ignoreToken: ignoreToken);
  }

  Future<void> _initializeClient({bool? ignoreToken}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final token = sharedPreferences.getString(AppConstants.keyToken);
    client = GraphqlConfig.initializeClient(
        token: ignoreToken == true ? null : token);
    notifyListeners();
  }

  Future<List<ProductModel>?> fetchProductsForUser(
      String categoryId, String channel,
      {Map<String, dynamic>? filter}) async {
    const String getProductsForUserQuery = '''
  query GetProductsForUser(\$categoryId: ID!, \$first: Int, \$channel: String!, \$filter: ProductFilterInput) {
    category(id: \$categoryId) {
      products(first: \$first, channel: \$channel, filter: \$filter) {
        edges {
          node {
            id
            name
            description
            thumbnail {
              url
            }
            media {
              url
            }
            pricing {
              priceRange {
                start {
                  net {
                    amount
                    currency
                  }
                }
              }
            }
            variants {
              id
              name
              sku
            }
          }
        }
      }
    }
  }
  ''';

    final QueryOptions options = QueryOptions(
      document: gql(getProductsForUserQuery),
      variables: {
        'categoryId': categoryId,
        'first': 100,
        'channel': channel,
        'filter': filter,
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      return [];
    }

    return result.data?['category']['products']['edges']
        .map<ProductModel>((edge) => ProductModel.fromMap(edge['node']))
        .toList();
  }
}
