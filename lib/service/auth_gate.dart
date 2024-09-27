import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:petshop/service/auth_service.dart';
import 'package:petshop/service/graphql_config.dart';
import 'package:petshop/service/login_or_register.dart';
import 'package:provider/provider.dart';

import '../screen/product/product_overview_screen.dart';

/*
  AUTH GATE

  This is to check if the user id logged in or not.

  --------------------------------------------------------

  if user is logged in     -> go to my home page
  if user is not logged in -> go to login or register page

*/

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final _loginStatusStreamController = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: _loginStatusStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!) {
            // login success
            final authService =
                Provider.of<AuthService>(context, listen: false);
            return ProductOverviewScreen(userData: authService.userData);
          } else {
            // login failed
            return const LoginOrRegister();
          }
        },
      ),
    );
  }

  void updateLoginStatus(bool isLoggedIn) {
    _loginStatusStreamController.add(isLoggedIn);
  }
}
