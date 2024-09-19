import 'package:flutter/material.dart';
import 'package:petshop/screen/product/product_grid.dart';
import 'package:petshop/screen/product/product_manager.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsManager(),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: const TabBarExample(), // Sử dụng TabBarExample làm trang chính
      ),
    );
  }
}

class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // Đặt tab ban đầu là tab đầu tiên
      length: 3, // Số lượng tab chính
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pet Shop"),
          bottom: const TabBar(tabs: <Widget>[
            Tab(text: 'Chó'), // Tab cho loại vật nuôi là chó
            Tab(text: 'Mèo'),
            Tab(text: 'Thỏ'),
          ]),
        ),
        body: const TabBarView(
          children: <Widget>[
            NestedTabBar(typePet: 'Chó'), // Tab con cho loại vật nuôi là chó
            NestedTabBar(typePet: 'Mèo'), // Tab con cho loại vật nuôi là mèo
            NestedTabBar(typePet: 'Thỏ'), // Tab con cho loại vật nuôi là thỏ
          ],
        ),
      ),
    );
  }
}

// Lớp cho các tab con trong mỗi tab chính
class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key, required this.typePet});

  final String typePet; // Tham số để xác định loại vật nuôi

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late Future<void> _fetchProductsFuture;

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController cho tab con
    _tabController = TabController(length: 3, vsync: this);

    // Fetch products when the widget is initialized
    _fetchProductsFuture = _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final productsManager = context.read<ProductsManager>();
    await productsManager.fetchProducts(widget.typePet, 'Thức ăn');
    await productsManager.fetchProducts(widget.typePet, 'Quần áo');
    await productsManager.fetchProducts(widget.typePet, 'Phụ kiện');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            children: <Widget>[
              TabBar(
                controller: _tabController,
                tabs: const <Widget>[
                  Tab(text: 'Thức ăn'), // Tab cho loại sản phẩm là thức ăn
                  Tab(text: 'Quần áo'),
                  Tab(text: 'Phụ kiện'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ProductsGrid(widget.typePet,
                        'Thức ăn'), // Hiển thị lưới sản phẩm thức ăn
                    ProductsGrid(widget.typePet,
                        'Quần áo'), // Hiển thị lưới sản phẩm quần áo
                    ProductsGrid(widget.typePet,
                        'Phụ kiện'), // Hiển thị lưới sản phẩm phụ kiện
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}





// enum FilterOptions { favorites, all }

// class PetOverviewScreen extends StatefulWidget {
//   const PetOverviewScreen({super.key});

//   @override
//   State<PetOverviewScreen> createState() => _PetOverviewScreenState();
// }

// class _PetOverviewScreenState extends State<PetOverviewScreen> {
//   var _showOnlyFavorites = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Shop'),
//         actions: <Widget>[
//           buildShoppingCartIcon(),
//         ],
//       ),
//       body: ProductsGrid(_showOnlyFavorites),
//     );
//   }

//   //shopping cart icon
//   Widget buildShoppingCartIcon() {
//     return Consumer<CartManager>(
//       builder: (ctx, cartManager, child) {
//         return TopRightBadge(
//           data:
//               cartManager.totalProductCount, // Hiển thị tổng số lượng sản phẩm
//           // data: CartManager().productCount,
//           child: IconButton(
//             onPressed: () {
//               Navigator.of(context).pushNamed(CartScreen.routeName);
//             },
//             icon: const Icon(Icons.shopping_cart),
//           ),
//         );
//       },
//     );
//   }
// }
