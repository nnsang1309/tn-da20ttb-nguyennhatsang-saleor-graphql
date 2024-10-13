import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/common/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphqlConfig {
  // Phương thức khởi tạo GraphQL client
  static ValueNotifier<GraphQLClient> initializeClient({String? token}) {
    // Tạo HttpLink với URL đến endpoint GraphQL của Saleor
    final HttpLink httpLink = HttpLink(
      // 'https://saleor-nguyen-nhat-sang.eu.saleor.cloud/graphql/',
      'https://pet-store.saleor.cloud/graphql/',
    );

    // Tạo AuthLink để thêm token xác thực vào mỗi request
    final AuthLink authLink = AuthLink(
      getToken: () async => token != null ? 'Bearer $token' : '',
    );

    // Tạo Link bằng cách kết hợp HttpLink và AuthLink
    final Link link = authLink.concat(httpLink);

    // Tạo GraphQLClient
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );

    // Trả về ValueNotifier chứa GraphQLClient
    return ValueNotifier(client);
  }
}
