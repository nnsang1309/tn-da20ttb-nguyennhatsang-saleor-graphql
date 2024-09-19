import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/graphql/product/product_queries.dart';
import 'package:petshop/model/product.dart';
import 'package:petshop/screen/cart/cart_manager.dart';
import 'package:petshop/screen/product/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  final String? type;
  final String? typePet;

  const ProductGridTile(
    this.product,
    this.type,
    this.typePet, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getProductsList),
        variables: {
          'type': type,
          'typePet': typePet,
        },
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.hasException) {
          return Center(
            child: Text('Error: ${result.exception.toString()}'),
          );
        }

        final products = result.data?['products'] as List<dynamic>;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTile(
                footer: buildGridFooterBar(context, product),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => PetDetailScreen(product['id']),
                      ),
                    );
                  },
                  child: Image.network(
                    product['media'][0]['url'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildGridFooterBar(BuildContext context, dynamic product) {
    return GridTileBar(
      backgroundColor: const Color.fromARGB(221, 157, 152, 152),
      title: Text(
        product['name'],
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.shopping_cart,
        ),
        //add item to card
        onPressed: () {
          // print('Add item to cart');
          // final cart = context.read<CartManager>();
          // cart.addItem(Product(
          //   id: product['id'],
          //   title: product['name'],
          //   imageUrl: product['media'][0]['url'],
          //   price: product['pricing']['priceRange']['start']['gross']['amount'],
          // ));
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(
          //       content: const Text(
          //         'Item added to cart',
          //       ),
          //       duration: const Duration(seconds: 2),
          //       action: SnackBarAction(
          //         label: 'UNDO',
          //         onPressed: () {
          //           cart.removeSingleItem(product.id!);
          //         },
          //       ),
          //     ),
          //   );
        },
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
