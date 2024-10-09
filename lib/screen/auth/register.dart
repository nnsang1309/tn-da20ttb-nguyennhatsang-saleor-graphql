// import 'package:app/components/my_button.dart';
// import 'package:app/components/my_loading_circle.dart';
// import 'package:app/services/auth/auth_service.dart';
// import 'package:app/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:petshop/Utils/utils.dart';
import 'package:petshop/common/app_constants.dart';
import 'package:petshop/components/button_custom_content.dart';
import 'package:petshop/components/loading.dart';
import 'package:petshop/service/auth_service.dart';
import 'package:petshop/service/loading_service.dart';
import 'package:petshop/themes/colors.dart';

import '../../components/button_base.dart';
import '../../components/input_base.dart';

/*
  REGISTER PAGE

  On this page, a new user can fill out the form and create an account.
  The data we want from the user is:

  - name
  - email
  - password
  - confirm password

  ------------------------------------ 
  Once the user successfully creates an account -> they will be redirected to home page.

  Also, if user already has an account, they can go to login page from here.

*/

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final _auth = AuthService();
  final LoadingService loadingService = GetIt.I<LoadingService>();
  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return regex.hasMatch(email);
  }

  // register button tapped
  void register() async {
    if (!isValidEmail(email)) {
      Utils().showToast('Email không hợp lệ', ToastType.failed);
      return;
    }
    int id = loadingService.showLoading();
    if (password == rePassword) {
      // attempt to register new user
      try {
        // trying to register...
        final response = await _auth.register(
          email: email,
          password: password,
          firstName: userName,
          lastName: '',
          redirectUrl: AppConstants.trustURL,
        );
        loadingService.hideLoading(id);
        if ((response?['accountRegister']?['accountErrors']) is List &&
            (response?['accountRegister']?['accountErrors'] as List).isEmpty) {
          Utils().showToast('Đăng ký tài khoản thành công', ToastType.success);
          Navigator.of(context).pop();
          return;
        }
        if ((response?['accountRegister']?['accountErrors']) is List &&
            (response?['accountRegister']?['accountErrors'] as List)
                .isNotEmpty) {
          List<String> errs = [];
          (response?['accountRegister']?['accountErrors'] as List)
              .forEach((err) {
            errs.add(err['message'] ?? '');
          });
          Utils().showToast(errs.toString(), ToastType.failed);

          return;
        }

        Utils().showToast('Đăng ký tài khoản thất bại', ToastType.failed);
      }
      // catch any errors...
      catch (e) {
        loadingService.hideLoading(id);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
    } else {
      loadingService.hideLoading(id);
      Utils().showToast(
          'Mật khẩu và Nhập lại mật khẩu không trùng khớp', ToastType.failed);
    }
  }

  String userName = '';
  String email = '';
  String password = '';
  String rePassword = '';

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        // BODY
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/pet_shop_logo.jpg'),

                  const SizedBox(height: 25),

                  // name textfield
                  InputBase(
                    hintText: "Nhập tên",
                    obscureText: false,
                    onChanged: (text) {
                      setState(() {
                        userName = text.trim();
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // email textfield
                  InputBase(
                    hintText: "Nhập email",
                    obscureText: false,
                    onChanged: (text) {
                      setState(() {
                        email = text.trim();
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  InputBase(
                    onChanged: (text) {
                      setState(() {
                        password = text.trim();
                      });
                    },
                    hintText: "Nhập mật khẩu",
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // confirm password textfield
                  InputBase(
                    onChanged: (text) {
                      setState(() {
                        rePassword = text.trim();
                      });
                    },
                    hintText: "Nhập lại mật khẩu",
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  //sign up button
                  ButtonBase(
                    text: "Đăng ký",
                    onTap: (userName.isNotEmpty &&
                            password.isNotEmpty &&
                            password.isNotEmpty &&
                            rePassword.isNotEmpty)
                        ? register
                        : null,
                  ),

                  const SizedBox(height: 50),

                  // already a member? login here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Đã có tài khoản?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // User can tap this to go to login page
                      ButtonCustomContent(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(
                            color: AppColors.primary_700,
                            fontWeight: FontWeight.bold,
                            decorationStyle: TextDecorationStyle.solid,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary_700,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
