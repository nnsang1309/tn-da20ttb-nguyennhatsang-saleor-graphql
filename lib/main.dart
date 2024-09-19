import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/screen/cart/cart_manager.dart';
import 'package:petshop/screen/cart/cart_screen.dart';
import 'package:petshop/screen/order/order_screen.dart';
import 'package:petshop/screen/personal/personal_screen.dart';
import 'package:petshop/screen/product/product_detail_screen.dart';
import 'package:petshop/screen/product/product_manager.dart';
import 'package:petshop/screen/product/product_overview_screen.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:provider/provider.dart';
import 'package:petshop/screen/order/order_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = GraphqlConfig.initializeClient();

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  const MyApp({super.key, required this.client});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Khởi tạo một client GraphQL
    final client = GraphqlConfig.initializeClient();
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ProductsManager(),
            ),
            ChangeNotifierProvider(
              create: (_) => CartManager(),
            ),
            ChangeNotifierProvider(
              create: (_) => OrdersManager(),
            ),
          ],
          child: MaterialApp(
            title: 'PetShop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.purple,
                ).copyWith(
                  secondary: Colors.deepOrange,
                )),
            home: const MyHomePage(
              title: 'User',
            ),
            routes: {
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              ProfileEdit.routeName: (context) => const ProfileEdit(),
            },
            //xử lý các route động, khi mở chi tiet sản phẩm
            onGenerateRoute: (settings) {
              // if (settings.name == PetDetailScreen.routeName) {
              //   final productID = settings.arguments as String;
              //   return MaterialPageRoute(builder: (ctx) {
              //     return PetDetailScreen(
              //         // ctx.read<ProductsManager>().findById(productID)!,
              //         );
              //   });
              // }
              // return null;
            },
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/';
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // danh danh screen
  final screens = [
    const ProductOverviewScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileEdit(),
  ];
  // trang thai cua tab hiện tại
  late int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) =>
              setState(() => (this.index = index)),
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

//------


