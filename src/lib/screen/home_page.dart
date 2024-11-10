import 'package:flutter/material.dart';
import 'package:petshop/components/loading.dart';
import 'package:petshop/screen/product/product_overview_screen.dart';
import 'package:petshop/screen/cart/cart_screen.dart';
import 'package:petshop/screen/order/order_screen.dart';
import 'package:petshop/screen/personal/personal_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/themes/colors.dart';

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
    return LoadingOverlay(
      child: Scaffold(
        body: screens[index], // Hiển thị màn hình tương ứng với tab hiện tại
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.primary_700,
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: index, // Chỉ số tab được chọn
            onDestinationSelected: (newIndex) => setState(
                () => index = newIndex), // Cập nhật chỉ số tab khi chọn
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: AppColors.primary_300,
                ),
                label: 'Trang chủ',
                selectedIcon: Icon(
                  Icons.home,
                  color: AppColors.primary_700,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_cart,
                  color: AppColors.primary_300,
                ),
                label: 'Giỏ hàng',
                selectedIcon: Icon(
                  Icons.shopping_cart,
                  color: AppColors.primary_700,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  color: AppColors.primary_300,
                  Icons.shopping_bag,
                ),
                selectedIcon: Icon(
                  color: AppColors.primary_700,
                  Icons.shopping_bag,
                ),
                label: 'Đơn hàng',
              ),
              NavigationDestination(
                icon: Icon(
                  color: AppColors.primary_300,
                  Icons.account_circle_outlined,
                ),
                selectedIcon: Icon(
                  color: AppColors.primary_700,
                  Icons.account_circle_outlined,
                ),
                label: 'Cá nhân',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
