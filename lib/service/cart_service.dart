import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/common/app_constants.dart';
import 'package:petshop/model/checkout_response_modal.dart';
import 'package:petshop/service/auth_service.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService with ChangeNotifier {
  late ValueNotifier<GraphQLClient> client = GraphqlConfig.initializeClient();

  CartService({bool? ignoreToken}) {
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

  Future<CheckoutResponse?> fetchDataCart(String checkoutId) async {
    const String getCheckoutQuery = '''
    query GetCheckout(\$checkoutId: ID!) {
      checkout(id: \$checkoutId) {
        id
        lines {
          quantity
          variant {
            id
            name
            product {
              name
              thumbnail {
                url
              }
              pricing {
                priceRange {
                  start {
                    net {
                      currency
                      amount
                    }
                  }
                }
              }
            }
          }
        }
        totalPrice {
          gross {
            amount
            currency
          }
        }
      }
    }
  ''';

    final QueryOptions options = QueryOptions(
      document: gql(getCheckoutQuery),
      variables: {
        'checkoutId': checkoutId,
      },
    );

    try {
      final QueryResult result = await client.value.query(options);

      if (result.hasException) {
        if (result.exception?.graphqlErrors.first.extensions?['exception']
                ?['code'] ==
            AppConstants.keyExpiredToken) {
          final response = await AuthService(ignoreToken: true).refreshToken();
          if (response == null) {
            return null;
          }
          return fetchDataCart(checkoutId);
        }
        return null;
      }

      final checkoutData = result.data?['checkout'];
      if (checkoutData != null) {
        return CheckoutResponse.fromMap({'checkout': checkoutData});
      } else {
        print('No checkout found for ID: $checkoutId');
        return null;
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null;
    }
  }
}
