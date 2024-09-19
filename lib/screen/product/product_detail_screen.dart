import 'package:flutter/material.dart';
import 'package:petshop/graphql/product/product_queries.dart';
// import 'package:petshop/service/graphql_config.dart';
// import '../../model/product.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PetDetailScreen extends StatelessWidget {
  static const routeName = '/pet-detail';
  const PetDetailScreen(
    this.productId, {
    super.key,
  });

  // final Product pet;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chi tiet dong vat"),
        ),
        body: Query(
            options: QueryOptions(
              document: gql(getProductById),
              variables: {
                'productId': productId,
              },
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.isLoading) {
                return Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (result.hasException) {
                return Center(
                  child: Text('Error: ${result.exception.toString()}'),
                );
              }

              final product = result.data?['product'];

              return SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      product['media'][0]['url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${product['name']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '\$${product['']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '\$${product['pricing']['priceRange']['start']['gross']['amount']} ${product['pricing']['priceRange']['start']['gross']['currency']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      product['description'],
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ]),
              );
            }));
  }
}
