import 'package:shared_preferences/shared_preferences.dart';

class AppConstants {
  static const String trustURL = 'https://pet-store.saleor.cloud';
  static const String keyToken = 'keyToken';
  static const String keyRefreshToken = 'keyRefreshToken';
  static const String keyCheckoutId = 'keyCheckoutId';
  static const String keyAddress = 'keyAddress';
  // dog
  static const String keyDogFood = 'thuc-an-cho-cho';
  static const String keyDogClothes = 'quan-ao-cho-cho';
  static const String keyDogItem = 'phu-kien-cho-cho';
  // cat
  static const String keyCatFood = 'thuc-an-cho-meo';
  static const String keyCatClothes = 'quan-ao-cho-meo';
  static const String keyCatItem = 'phu-kien-cho-meo';
  // rabbit
  static const String keyRabbitFood = 'thuc-an-cho-tho';
  static const String keyRabbitClothes = 'quan-ao-cho-tho';
  static const String keyRabbitItem = 'phu-kien-cho-tho';

  // static const String channelDefault = 'default-channel';
  static const String channelDefault = 'channel-vnd';
  static const String subValuePrice = 'VND';

  // Set checkoutId
  static Future<void> setCheckoutId(String checkoutId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('keyCheckoutId', checkoutId);
  }

  // Get checkoutId
  static Future<String> getCheckoutId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('keyCheckoutId') ?? '';
  }

  static Future<dynamic> clearCheckoutId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('keyCheckoutId');
  }

  static const String keyExpiredToken = 'ExpiredSignatureError';
}
