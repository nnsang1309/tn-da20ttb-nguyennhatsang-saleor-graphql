import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:petshop/Utils/utils.dart';
import 'package:petshop/components/button_custom_content.dart';
import 'package:petshop/model/user_model.dart';
import 'package:petshop/service/auth_service.dart';
import 'package:petshop/service/loading_service.dart';
import 'package:petshop/themes/colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = '/order';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final AuthService _authService = AuthService();
  final LoadingService loadingService = GetIt.I<LoadingService>();
  UserInfo? userInfo;
  @override
  void initState() {
    super.initState();
    handleGetUserInfo();
  }

  handleGetUserInfo() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      int id = loadingService.showLoading();
      final response = await _authService.fetchUserInfo();
      loadingService.hideLoading(id);
      if (response == null) {
        Utils().showToast(
            'Đã có lỗi xảy ra trong quá trình xử lý', ToastType.failed);
        return;
      }
      setState(() {
        userInfo = UserInfo.fromMap(response);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Đơn hàng",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary_700,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: userInfo?.orders?.length ?? 0,
          itemBuilder: (context, index) {
            double total = 0;
            return Container(
              width: MediaQuery.of(context).size.width - 32,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.primary_700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...userInfo!.orders![index].lines.map((line) {
                    total = total +
                        (line.variant.product.pricing?.priceRange.start
                                    .amount ??
                                0) *
                            line.quantity;
                    return Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: (ButtonCustomContent(
                        radius: BorderRadius.circular(8),
                        color: AppColors.primary_400,
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                    line.variant.product.thumbnail?.url ?? ''),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    maxLines: 2,
                                    line.variant.product.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'x${line.quantity}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Thành tiền: ${formatCurrency((line.variant.product.pricing?.priceRange.start.amount ?? 0) * line.quantity)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      )),
                    );
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Tổng tiền: ${formatCurrency(total)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String formatCurrency(double amount) {
    final format =
        NumberFormat.currency(locale: 'vi_VN', decimalDigits: 0, symbol: '\$');
    return format.format(amount);
  }
}
