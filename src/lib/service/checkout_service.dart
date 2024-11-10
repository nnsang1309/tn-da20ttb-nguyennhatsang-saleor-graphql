/*
CHECKOUT SERVICE

- checkoutCreate
- checkoutLinesAdd
- checkoutPaymentCreate
- checkoutComplete
 */

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/common/app_constants.dart';
import 'package:petshop/service/auth_service.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutService with ChangeNotifier {
  late ValueNotifier<GraphQLClient> client = GraphqlConfig.initializeClient();

  CheckoutService({bool? ignoreToken}) {
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

  Future<Map<String, dynamic>?> createCheckout(
      String email, List<Map<String, dynamic>> lines, String channel) async {
    const String createCheckoutMutation = '''
  mutation CreateCheckout(\$email: String!, \$lines: [CheckoutLineInput!]!, \$channel: String!) {
    checkoutCreate(
      input: {
        email: \$email
        lines: \$lines
        channel: \$channel
      }
    ) {
      checkout {
        id
        token
        email
        lines {
          id
          quantity
          variant {
            id
            name
          }
        }
      }
      errors {
        field
        message
      }
    }
  }
  ''';

    final MutationOptions options = MutationOptions(
      document: gql(createCheckoutMutation),
      variables: {
        'email': email,
        'lines': lines, // Danh sách sản phẩm với variantId và quantity
        'channel': channel,
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      return null;
    }

    return result.data?['checkoutCreate'];
  }

  Future<bool> addToCart(
      String checkoutId, String variantId, int quantity) async {
    const String addToCartMutation = '''
    mutation CheckoutLinesAdd(\$checkoutId: ID!, \$lines: [CheckoutLineInput!]!) {
      checkoutLinesAdd(checkoutId: \$checkoutId, lines: \$lines) {
        checkout {
          id
          lines {
            quantity
            variant {
              id
              name
            }
          }
        }
        errors {
          field
          message
        }
      }
    }
  ''';

    final MutationOptions options = MutationOptions(
      document: gql(addToCartMutation),
      variables: {
        'checkoutId': checkoutId,
        'lines': [
          {
            'variantId': variantId,
            'quantity': quantity,
          },
        ],
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      if (result.exception?.graphqlErrors.first.extensions?['exception']
              ?['code'] ==
          AppConstants.keyExpiredToken) {
        final response = await AuthService(ignoreToken: true).refreshToken();
        if (response == null) {
          return false;
        }
        return addToCart(checkoutId, variantId, quantity);
      }
      return false;
    } else {
      return true;
    }
  }
}
