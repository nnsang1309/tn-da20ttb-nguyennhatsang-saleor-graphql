import 'package:flutter/material.dart';
import 'package:petshop/screen/pet/pet_grid.dart';

class PetOverviewScreen extends StatelessWidget {
  const PetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const TabBarExample(),
    );
  }
}

class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pet Shop"),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              text: 'Chó',
            ),
            Tab(
              text: 'Mèo',
            ),
            Tab(
              text: 'Thỏ',
            ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            NestedTabBar(1),
            NestedTabBar(2),
            NestedTabBar(3),
          ],
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  NestedTabBar(this.outerTab, {super.key});

  final int outerTab;
  String a = "a";
  String b = "b";
  String c = "c";

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Thức ăn'),
            Tab(text: 'Quần áo'),
            Tab(text: 'Phụ kiện'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              ProductsGrid(widget.outerTab, widget.a),
              ProductsGrid(widget.outerTab, widget.b),
              ProductsGrid(widget.outerTab, widget.c),
            ],
          ),
        ),
      ],
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
