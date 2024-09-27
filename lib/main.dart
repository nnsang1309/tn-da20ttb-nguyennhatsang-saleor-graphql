import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:petshop/screen/cart/cart_manager.dart';
import 'package:petshop/screen/cart/cart_screen.dart';
import 'package:petshop/screen/order/order_screen.dart';
import 'package:petshop/screen/personal/personal_screen.dart';
import 'package:petshop/screen/product/product_detail_screen.dart';

import 'package:petshop/screen/product/product_overview_screen.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:petshop/service/login_or_register.dart';
import 'package:petshop/service/product_service.dart';
import 'package:petshop/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:petshop/screen/order/order_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GraphQL Client to connect GraphQL Server
  await initHiveForFlutter();
  final ValueNotifier<GraphQLClient> client = GraphqlConfig.initializeClient();

  runApp(
    ChangeNotifierProvider(
      create: (ctx) => ThemeProvider(),
      child: MyApp(client: client),
    ),
  );
}

// Class Main App
class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  const MyApp({super.key, required this.client});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Init GraphQL client
    final client = GraphqlConfig.initializeClient();
    // Provide GraphQL client for entire child widget tree
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MultiProvider(
          //Provider
          providers: [
            ChangeNotifierProvider(
              create: (_) =>
                  ProductService(client: client.value), // Quan ly san pham
            ),
            ChangeNotifierProvider(
              create: (_) => CartManager(), // Quan ly gio hang
            ),
            ChangeNotifierProvider(
              create: (_) => OrdersManager(), // Quan ly don hang
            ),
          ],
          //App
          child: MaterialApp(
            title: 'PetShop',
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).themeData,

            home: const LoginOrRegister(),
            // home: MyHomePage(
            //   title: 'User',
            //   client: client,
            // ),
            //static routes
            routes: {
              ProductOverviewScreen.routeName: (context) =>
                  const ProductOverviewScreen(), // route overview
              CartScreen.routeName: (context) =>
                  const CartScreen(), // route gio hang
              OrdersScreen.routeName: (context) =>
                  const OrdersScreen(), // route  don hang
              ProfileEdit.routeName: (context) =>
                  const ProfileEdit(), // route ca nhan
            },
            // dynamic route, when opening productdetails screen
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productID = settings.arguments as String;
                return MaterialPageRoute(builder: (ctx) {
                  return ProductDetailScreen(
                    ctx.read<ProductService>().findById(productID)!,
                  );
                });
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}

// Main Screen
class MyHomePage extends StatefulWidget {
  static const routeName = '/';
  final ValueNotifier<GraphQLClient> client;
  const MyHomePage({super.key, required this.title, required this.client});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//
class _MyHomePageState extends State<MyHomePage> {
  final screens = [
    const ProductOverviewScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileEdit(),
  ];
  late int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index], // hien thi man hinh tuong ung voi tab hien tai
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(),
        child: NavigationBar(
          selectedIndex: index, // chi so tab duoc chon
          onDestinationSelected: (index) => setState(
              () => (this.index = index)), // Cap nhat chi so tab khi chon
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

//--------

// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:petshop/screen/auth/login.dart';
// import 'package:petshop/service/graphql_config.dart';
// import 'package:petshop/service/login_or_register.dart';
// import 'package:petshop/themes/theme_provider.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   // await initHiveForFlutter();
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(ChangeNotifierProvider(
//     create: (context) => ThemeProvider(),
//     child: MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return GraphQLProvider(
//       client: GraphqlConfig.initializeClient(),
//       child: CacheProvider(
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'Flutter E-commerce',
//           home: const LoginOrRegister(),
//           theme: Provider.of<ThemeProvider>(context).themeData,
//         ),
//       ),
//     );
//   }
// }
