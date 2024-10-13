import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:petshop/screen/cart/cart_screen.dart';
import 'package:petshop/screen/home_page.dart';
import 'package:petshop/screen/order/order_screen.dart';
import 'package:petshop/screen/personal/personal_screen.dart';
import 'package:petshop/screen/product/product_detail_screen.dart';
import 'package:petshop/screen/product/product_overview_screen.dart';
import 'package:petshop/service/auth_service.dart';
import 'package:petshop/service/cart_service.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:petshop/service/loading_service.dart';
import 'package:petshop/service/login_or_register.dart';
import 'package:petshop/service/order_service.dart';
import 'package:petshop/service/product_service.dart';
import 'package:petshop/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GraphQL Client to connect GraphQL Server
  await initHiveForFlutter();
  final ValueNotifier<GraphQLClient> client = GraphqlConfig.initializeClient();

  // Kiểm tra token khi khởi động
  final authService = AuthService();
  final token = await authService.getToken();
  final GetIt sl = GetIt.instance;

  sl.registerLazySingleton<LoadingService>(() => LoadingService());

  runApp(MyApp(client: client, token: token));
}

// Class Main App
class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  final String? token;

  const MyApp({super.key, required this.client, this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(
                create: (_) => ProductService(client: client.value)),
            ChangeNotifierProvider(create: (_) => CartService()),
            ChangeNotifierProvider(create: (_) => OrderService()),
          ],
          child: Builder(
            builder: (context) {
              return MaterialApp(
                title: 'PetShop',
                debugShowCheckedModeBanner: false,
                theme: Provider.of<ThemeProvider>(context).themeData,
                home: token != null
                    ? MyHomePage(
                        title: 'User',
                        client: client,
                      )
                    : const LoginOrRegister(),
                routes: {
                  ProductOverviewScreen.routeName: (context) =>
                      const ProductOverviewScreen(),
                  CartScreen.routeName: (context) => const CartScreen(),
                  OrdersScreen.routeName: (context) => const OrdersScreen(),
                  ProfileEdit.routeName: (context) => const ProfileEdit(),
                },
                onGenerateRoute: (settings) {
                  if (settings.name == ProductDetailScreen.routeName) {
                    final productID = settings.arguments as String;
                    return MaterialPageRoute(builder: (ctx) {
                      return Container();
                    });
                  }
                  return null;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
