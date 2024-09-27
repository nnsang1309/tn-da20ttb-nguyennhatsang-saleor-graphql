import 'package:flutter/material.dart';
import 'package:petshop/screen/product/product_grid.dart';
import 'package:provider/provider.dart';
import '../../model/product.dart';
import '../../service/product_service.dart';

class ProductOverviewScreen extends StatelessWidget {
  static const routeName = '/overview';

  final Map<String, dynamic>? userData;
  const ProductOverviewScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    return const TabBarExample(); // Sử dụng TabBarExample làm trang chính
  }
}

class TabBarExample extends StatefulWidget {
  const TabBarExample({super.key});

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample> {
  late Future<void> _fetchProductsFuture;

  @override
  void initState() {
    super.initState();
    // Gọi fetchProducts khi khởi tạo widget chỉ một lần
    _fetchProductsFuture =
        Provider.of<ProductService>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pet Shop'),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(text: 'Chó'),
              Tab(text: 'Mèo'),
              Tab(text: 'Thỏ'),
            ],
          ),
        ),
        body: FutureBuilder<void>(
          future: _fetchProductsFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Có lỗi xảy ra!'));
            }

            return const TabBarView(
              children: <Widget>[
                NestedTabBar("1"), // Tab con cho loại vật nuôi là chó
                NestedTabBar("2"), // Tab con cho loại vật nuôi là mèo
                NestedTabBar("3"), // Tab con cho loại vật nuôi là thỏ
              ],
            );
          },
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar(this.category, {super.key});

  final String category;

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
    final productService = Provider.of<ProductService>(context);
    final category = widget.category;

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
          child: Consumer<ProductService>(
            builder: (context, productService, child) {
              // Lọc sản phẩm
              final products = productService.products.where((product) {
                return product.category == category;
              }).toList();

              // Kiểm tra nếu không có sản phẩm nào
              if (products.isEmpty) {
                return const Center(child: Text('Không có sản phẩm nào!'));
              }

              return TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ProductsGrid(category, 'a', products),
                  ProductsGrid(category, 'b', products),
                  ProductsGrid(category, 'c', products),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
