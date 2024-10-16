import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/common/app_constants.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService with ChangeNotifier {
  late ValueNotifier<GraphQLClient> client = GraphqlConfig.initializeClient();

  OrderService({bool? ignoreToken}) {
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

  Future<dynamic> orderCheckoutById(String checkoutId) async {
    const String completeCheckoutMutation = '''
  mutation CompleteCheckout(\$checkoutId: ID!) {
    checkoutComplete(checkoutId: \$checkoutId) {
      order {
        id
        number
        total {
          gross {
            amount
            currency
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
      document: gql(completeCheckoutMutation),
      variables: {
        'checkoutId': checkoutId,
      },
    );

    try {
      final QueryResult result = await client.value.mutate(options);

      if (result.hasException) {
        return null;
      }

      final orderData = result.data?['checkoutComplete']['order'];
      if (orderData != null) {
        return orderData;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
