import 'package:flutter/material.dart';
import 'package:petshop/screen/product/product_overview_screen.dart';
import 'package:petshop/screen/cart/cart_screen.dart';
import 'package:petshop/screen/order/order_screen.dart';
import 'package:petshop/screen/personal/personal_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  final ValueNotifier<GraphQLClient> client;
  final String title;

  const MyHomePage({super.key, required this.title, required this.client});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> screens = [
    const ProductOverviewScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileEdit(),
  ];
  late int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index], // Hiển thị màn hình tương ứng với tab hiện tại
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: index, // Chỉ số tab được chọn
          onDestinationSelected: (newIndex) =>
              setState(() => index = newIndex), // Cập nhật chỉ số tab khi chọn
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Trang chủ'),
            NavigationDestination(
                icon: Icon(Icons.shopping_cart), label: 'Giỏ hàng'),
            NavigationDestination(
                icon: Icon(Icons.shopping_bag), label: 'Đơn hàng'),
            NavigationDestination(
                icon: Icon(Icons.account_circle_outlined), label: 'Cá nhân'),
          ],
        ),
      ),
    );
  }
}
