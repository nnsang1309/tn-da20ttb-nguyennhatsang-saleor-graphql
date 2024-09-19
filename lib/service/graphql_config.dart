import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlConfig {
  static ValueNotifier<GraphQLClient> initializeClient() {
    final HttpLink httpLink = HttpLink(
      'https://pet-store.saleor.cloud/graphql/',
    );

    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer YOUR_AUTH_TOKEN',
    );

    final Link link = authLink.concat(httpLink);

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );

    return ValueNotifier(client);
  }
}
