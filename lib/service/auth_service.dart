// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/service/graphql_config.dart';

/*

  AUTHENTICATION SERVICE

  This handles everything to do with authentication

  -------------------------------------------

  - Login
  - Register
  - Logout
  - Delete account (required if you want to publish to app store)
*/

class AuthService with ChangeNotifier {
  final ValueNotifier<GraphQLClient> client;
  // final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  final bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // AuthService({required this.client});
  AuthService() : client = GraphqlConfig.initializeClient();

  // Check Login
  bool checkLoginStatus(Map<String, dynamic>? result) {
    //return true if result && result['tokenCreate'] not null
    return result != null && result['tokenCreate'] != null;
  }

  //
  Future<void> handleLogin(String email, String password) async {
    final result = await loginUser(email, password);

    if (checkLoginStatus(result)) {
      // Xử lý khi đăng nhập thành công
      _userData = result!['tokenCreate']['user'];
      notifyListeners();
      print('Đăng nhập thành công!');
      // Lưu token vào local storage hoặc sử dụng token để truy cập các chức năng khác
    } else {
      // Xử lý khi đăng nhập thất bại
      print('Đăng nhập thất bại!');
    }
  }

  // Login function
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    const String loginMutation = '''
    mutation TokenCreate(\$email: String!, \$password: String!) {
      tokenCreate(email: \$email, password: \$password) {
        token
        refreshToken
        csrfToken
        user {
          id
          email
        }   
        errors {
          field
          message
          code
        }   
      }
    }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(loginMutation),
      variables: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['tokenCreate'];
  }

  // Register function

  // Logout

  //---- User data ----
  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;
}
