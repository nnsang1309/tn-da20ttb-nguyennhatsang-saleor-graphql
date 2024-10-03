// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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

  // Logout function
  Future<void> logout() async {
    await removeToken(); // Xóa token khi đăng xuất
    _userData = null; // Xóa dữ liệu người dùng
    notifyListeners(); // Thông báo cho các listener
    print('Đăng xuất thành công!');
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
}
