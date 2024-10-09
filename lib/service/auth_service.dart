// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/Utils/utils.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  AuthService() : client = GraphqlConfig.initializeClient();

  // User data
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  // Token management
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }

  // Check Login
  bool checkLoginStatus(Map<String, dynamic>? result) {
    return result != null && result['token'] != null;
  }

  // Method to fetch user information after login
  Future<void> fetchUserInfo() async {
    const String fetchUserQuery = '''
    query {
      me {
        id
        email
        firstName
        lastName
        
      }
    }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(fetchUserQuery),
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      return;
    }

    _userData = result.data?['me'];
    notifyListeners(); // Thông báo cho các listener
  }

  //
  Future<void> handleLogin(String email, String password) async {
    final result = await loginUser(email, password);

    if (checkLoginStatus(result)) {
      // Xử lý khi đăng nhập thành công
      _userData = result!['user'];
      await saveToken(result['token']); // Lưu token
      notifyListeners();
      print('Đăng nhập thành công!');
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
          firstName
          lastName
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

  Future<void> logout(String pluginId) async {
    const String logoutMutation = '''
  mutation externalLogout(\$input: JSONString!, \$pluginId: String!) {
    externalLogout(input: \$input, pluginId: \$pluginId) {
      accountErrors {
        field
        message
      }
    }
  }
  ''';

    final String inputJson = '{}';

    final MutationOptions options = MutationOptions(
      document: gql(logoutMutation),
      variables: {
        'input': inputJson,
        'pluginId': pluginId,
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      print('Logout error: ${result.exception.toString()}');
    } else {
      final List<dynamic> accountErrors =
          result.data?['externalLogout']['accountErrors'];

      if (accountErrors.isNotEmpty) {
        List<String> messages = [];
        // Nếu có lỗi, in ra lỗi
        accountErrors.forEach((error) {
          messages.add(error?['message']);
          Utils().showToast(messages.toString(), ToastType.failed);
        });
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
      }
    }
  }

  // Register function (thêm sau nếu cần)
  // Future<Map<String, dynamic>?> registerUser(String email, String password) async {
  //   // Xử lý đăng ký
  // }

  // Function to check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<Map<String, dynamic>?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String redirectUrl,
  }) async {
    const String registerMutation = '''
  mutation accountRegister(\$email: String!, \$password: String!, \$firstName: String!, \$lastName: String!, \$redirectUrl: String!) {
    accountRegister(input: { email: \$email, password: \$password, firstName: \$firstName, lastName: \$lastName, redirectUrl: \$redirectUrl }) {
      accountErrors {
        field
        message
      }
      user {
        id
        email
        firstName
        lastName
        isActive
        isStaff
        dateJoined
        lastLogin
        languageCode
        defaultShippingAddress {
          streetAddress1
          city
          postalCode
        }
        defaultBillingAddress {
          streetAddress1
          city
          postalCode
        }
        addresses {
          streetAddress1
          city
          postalCode
        }
        avatar {
          url
        }
      }
    }
  }
  ''';

    final MutationOptions options = MutationOptions(
      document: gql(registerMutation),
      variables: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'redirectUrl': redirectUrl,
        'channelSlug': 'default'
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data;
  }
}
