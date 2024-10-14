// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:petshop/Utils/utils.dart';
import 'package:petshop/common/app_constants.dart';
import 'package:petshop/model/address_model.dart';
import 'package:petshop/model/checkout_model.dart';
import 'package:petshop/model/checkout_response_modal.dart';
import 'package:petshop/model/product_model.dart';
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
@injectable
class AuthService with ChangeNotifier {
  late ValueNotifier<GraphQLClient> client = GraphqlConfig.initializeClient();

  AuthService({bool? ignoreToken}) {
    _initializeClient(ignoreToken: ignoreToken);
  }

  Future<void> _initializeClient({bool? ignoreToken}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final token = sharedPreferences.getString(AppConstants.keyToken);
    print('LIIII--- $token');
    client = GraphqlConfig.initializeClient(
        token: ignoreToken == true ? null : token);
    notifyListeners();
  }

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

  Future<Map<String, dynamic>?> fetchUserInfo() async {
    const String getUserQuery = '''
  query {
    me {
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
        id
        firstName
        lastName
        streetAddress1
        city
        postalCode
      }
      avatar {
        url
      }
      checkout {
        id
        totalPrice {
          gross {
            amount
            currency
          }
        }
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
            }
          }
        }
      }
      orders(first: 100) {
        edges {
          node {
            id
            number
            created
            status
            total {
              gross {
                amount
                currency
              }
            }
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
          }
        }
      }
    }
  }
  ''';

    final QueryOptions options = QueryOptions(
      document: gql(getUserQuery),
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await client.value.query(options);
    notifyListeners();
    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['me'];
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
          checkoutIds
          defaultBillingAddress {
            firstName
            lastName
            companyName
            streetAddress1
            streetAddress2
            city
            cityArea
            postalCode
            country {
              code
              country
            }
            countryArea
            phone
            isDefaultBillingAddress
            isDefaultShippingAddress
          }
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

  Future<Map<String, dynamic>?> updateAccount({
    required String firstName,
    required String lastName,
  }) async {
    const String updateAccountMutation = '''
    mutation accountUpdate(\$firstName: String!, \$lastName: String!) {
      accountUpdate(input: { firstName: \$firstName, lastName: \$lastName }) {
        user {
          id
          email
          firstName
          lastName
        }
        accountErrors {
          field
          message
          code
        }
      }
    }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(updateAccountMutation),
      variables: {
        'firstName': firstName,
        'lastName': lastName, // Truyền lastName vào biến
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      print('Update Account error: ${result.exception.toString()}');
      return null;
    }

    return result.data?['accountUpdate']?['user'];
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
      print('Error fetching products for user: ${result.exception.toString()}');
      return [];
    }

    return result.data?['category']['products']['edges']
        .map<ProductModel>((edge) => ProductModel.fromMap(edge['node']))
        .toList();
  }

  Future<List<dynamic>?> fetchCategories() async {
    const String getCategoriesQuery = '''
    query {
      categories(first: 100) {
        edges {
          node {
            id
            name
            slug
          }
        }
      }
    }
  ''';

    final QueryOptions options = QueryOptions(
      document: gql(getCategoriesQuery),
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      return null;
    }

    return result.data?['categories']['edges']
        .map((edge) => edge['node'])
        .toList();
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

  Future<List<CheckoutModel>?> fetchCheckouts(String channel) async {
    const String getCheckoutsQuery = '''
  query GetCheckouts(\$channel: String) {
    checkouts(channel: \$channel, first: 5) {
      edges {
        node {
          id
          token
          email
          created
          totalPrice {
            gross {
              amount
              currency
            }
          }
          lines {
            variant {
              product {
                name
              }
            }
            quantity
          }
        }
      }
    }
  }
  ''';

    final QueryOptions options = QueryOptions(
      document: gql(getCheckoutsQuery),
      variables: {
        'channel': channel,
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      print('Error fetching checkouts: ${result.exception.toString()}');
      return null; // Hoặc xử lý lỗi theo cách khác
    }

    return result.data?['checkouts']['edges']
        .map<CheckoutModel>((edge) => CheckoutModel.fromMap(edge['node']))
        .toList();
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
      print(result.exception.toString());
      return false;
    } else {
      return true;
    }
  }

  Future<CheckoutResponse?> fetchCheckoutItems(String checkoutId) async {
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
        print('Error fetching checkout items: ${result.exception.toString()}');
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

  Future<dynamic> placeOrder(String checkoutId) async {
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

  Future<void> updateBillingAddress(
      String checkoutId, Map<String, dynamic> billingAddress) async {
    const String updateBillingAddressMutation = '''
  mutation UpdateCheckoutBillingAddress(\$checkoutId: ID!, \$billingAddress: AddressInput!) {
    checkoutBillingAddressUpdate(checkoutId: \$checkoutId, billingAddress: \$billingAddress) {
      checkout {
        id
      }
      errors {
        field
        message
      }
    }
  }
  ''';

    final MutationOptions options = MutationOptions(
      document: gql(updateBillingAddressMutation),
      variables: {
        'checkoutId': checkoutId,
        'billingAddress': billingAddress,
      },
    );

    try {
      final QueryResult result = await client.value.mutate(options);

      if (result.hasException) {
        print('Error updating billing address: ${result.exception.toString()}');
        return;
      }

      final errors = result.data?['checkoutBillingAddressUpdate']['errors'];
      if (errors != null && errors.isNotEmpty) {
        errors.forEach((error) {
          print('Error in field ${error['field']}: ${error['message']}');
        });
      } else {
        print('Billing address updated successfully.');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  Future<dynamic> createAddress({
    required String firstName,
    required String streetAddress1,
    required String city,
    required String phone,
  }) async {
    const String mutation = '''
    mutation AddAddress(\$input: AddressInput!) {
      accountAddressCreate(input: \$input) {
        address {
          id
          firstName
          lastName
          streetAddress1
          city
          postalCode
        }
        errors {
          field
          message
        }
      }
    }
  ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'input': {
          'firstName': firstName,
          'lastName': '',
          'streetAddress1': streetAddress1,
          'city': city,
          'postalCode': '90213',
          'country': 'US',
          'countryArea': 'CA',
        },
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      return null;
    } else {
      final address = result.data?['accountAddressCreate']['address'];
      return address;
    }
  }

  Future<dynamic> setDefaultBillingAddress(
    String addressId,
  ) async {
    const String mutation = '''
    mutation SetDefaultAddress(\$addressId: ID!) {
      accountSetDefaultAddress(id: \$addressId, type: BILLING) {
        user {
          id
          email
          defaultBillingAddress {
            id
            streetAddress1
            city
            postalCode
          }
        }
        accountErrors {
          field
          message
        }
      }
    }
  ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'addressId': addressId,
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      return null;
    } else {
      final address = result.data?['accountSetDefaultAddress']['user']
          ['defaultBillingAddress'];
      return address;
    }
  }

  Future<dynamic> setDefaultShippingAddress(
    String addressId,
  ) async {
    const String mutation = '''
    mutation SetDefaultAddress(\$addressId: ID!) {
      accountSetDefaultAddress(id: \$addressId, type: SHIPPING) {
        user {
          id
          email
          defaultBillingAddress {
            id
            streetAddress1
            city
            postalCode
          }
        }
        accountErrors {
          field
          message
        }
      }
    }
  ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'addressId': addressId,
      },
    );

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      return null;
    } else {
      final address = result.data?['accountSetDefaultAddress']['user']
          ['defaultBillingAddress'];
      return address;
    }
  }

  Future<dynamic> updateCheckoutAddresses(
      String checkoutId, Map<String, dynamic> address) async {
    // Mutation cho cập nhật địa chỉ giao hàng
    const String updateShippingAddressMutation = '''
    mutation UpdateCheckoutShippingAddress(\$checkoutId: ID!, \$shippingAddress: AddressInput!) {
      checkoutShippingAddressUpdate(checkoutId: \$checkoutId, shippingAddress: \$shippingAddress) {
        checkout {
          id
          shippingAddress {
            firstName
            lastName
            streetAddress1
            city
            postalCode
            country {
              code
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

    // Mutation cho cập nhật địa chỉ thanh toán
    const String updateBillingAddressMutation = '''
    mutation UpdateCheckoutBillingAddress(\$checkoutId: ID!, \$billingAddress: AddressInput!) {
      checkoutBillingAddressUpdate(checkoutId: \$checkoutId, billingAddress: \$billingAddress) {
        checkout {
          id
          billingAddress {
            firstName
            lastName
            streetAddress1
            city
            postalCode
            country {
              code
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

    // Cập nhật địa chỉ giao hàng
    final MutationOptions shippingOptions = MutationOptions(
      document: gql(updateShippingAddressMutation),
      variables: {
        'checkoutId': checkoutId,
        'shippingAddress': address,
      },
    );

    final QueryResult shippingResult =
        await client.value.mutate(shippingOptions);

    if (shippingResult.hasException) {
      return null;
    } else {
      // Cập nhật địa chỉ thanh toán
      final MutationOptions billingOptions = MutationOptions(
        document: gql(updateBillingAddressMutation),
        variables: {
          'checkoutId': checkoutId,
          'billingAddress': address,
        },
      );

      final QueryResult billingResult =
          await client.value.mutate(billingOptions);

      if (billingResult.hasException) {
        return null;
      } else {
        final billingAddress = billingResult;
        return billingAddress;
      }
    }
  }
}
