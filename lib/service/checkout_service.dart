/*
CHECKOUT SERVICE

- checkoutCreate
- checkoutLinesAdd
- checkoutPaymentCreate
- checkoutComplete
 */

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/service/auth_service.dart';

class CheckoutService with ChangeNotifier {
  final ValueNotifier<GraphQLClient> client;
  final AuthService authService;

  CheckoutService(this.client, this.authService);

  Future<String?> createCheckout(String channel) async {
    const String createCheckoutMutation = r'''

''';
  }
}
