// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:petshop/model/product.dart';

// class ProductProvider with ChangeNotifier {
//   final GraphQLClient client;

//   ProductProvider({required this.client});

//   //getProductById
//   Future<Map<String, dynamic>?> getProductById(String productId) async {
//     final QueryOptions options = QueryOptions(
//       document: gql(r'''
//         query GetProductById($productId: ID!, $channel: String = "channel-vnd") {
//     product(id: $productId, channel: $channel) {
//       id
//       name
//       description
//       pricing {
//         priceRange {
//           start {
//             gross {
//               amount
//               currency
//             }
//           }
//         }
//       }
//       category {
//         id
//         name
//         slug
//         parent {
//           id
//           name
//         }
//       }
//       productType {
//         id
//         name
//       }
//       media {
//         url
//       }
//     } 
// }
//       '''),
//       variables: {
//         'productId': productId,
//       },
//     );

//     final QueryResult result = await client.query(options);

//     if (result.hasException) {
//       throw Exception(result.exception.toString());
//     }

//     return result.data?['product'];
//   }
// }
