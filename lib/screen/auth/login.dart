import 'package:flutter/material.dart';
import 'package:petshop/components/my_button.dart';
import 'package:petshop/service/auth_service.dart';
import '../../components/my_text_field.dart';

/*
  LOGIN SCREEN

  On this page, an existing user can login in with their:
  - Email
  - Password  

  --------------------------------------------
  Once the user successfully logs in, they wil be redirected to the home page.

  If the user doesn't have an account yet, they can go to the register page from here.
*/

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;

  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Access auth service

  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  // Login method
  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await _authService.loginUser(email, password);

    if (response != null && response['token'] != null) {
      print('Login successful');
      // Save tokens and navigate to the main screen
      Navigator.pushNamed(context, '/overview');
    } else {
      print('Login failed');
    }
  }

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Logo
              Icon(
                Icons.lock_open_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 50),

              // Welcome back message
              Text(
                "Hello",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 25),

              // email textfield
              MyTextField(
                controller: _emailController,
                hintText: "Nhập email",
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: _passwordController,
                hintText: "Nhập mật khẩu",
                obscureText: true,
              ),

              const SizedBox(height: 10),

              //forgot password?
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              MyButton(
                text: "Đăng nhập",
                onTap: _login,
              ),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // User can tap this to go to register
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
