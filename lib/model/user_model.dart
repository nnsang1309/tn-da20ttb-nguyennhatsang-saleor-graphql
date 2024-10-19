class UserInfo {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isStaff;
  final String dateJoined;
  final String lastLogin;
  final String languageCode;
  final Address? defaultShippingAddress;
  final Address? defaultBillingAddress;
  final List<Address>? addresses;
  final Checkout? checkout;
  final List<Order>? orders;

  UserInfo({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isStaff,
    required this.dateJoined,
    required this.lastLogin,
    required this.languageCode,
    this.defaultShippingAddress,
    this.defaultBillingAddress,
    this.addresses,
    this.checkout,
    this.orders,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      isActive: map['isActive'] ?? false,
      isStaff: map['isStaff'] ?? false,
      dateJoined: map['dateJoined'] ?? '',
      lastLogin: map['lastLogin'] ?? '',
      languageCode: map['languageCode'] ?? '',
      defaultShippingAddress: map['defaultShippingAddress'] != null
          ? Address.fromMap(map['defaultShippingAddress'])
          : null,
      defaultBillingAddress: map['defaultBillingAddress'] != null
          ? Address.fromMap(map['defaultBillingAddress'])
          : null,
      addresses: map['addresses'] != null
          ? List<Address>.from(
              map['addresses'].map((address) => Address.fromMap(address)))
          : null,
      checkout: map['checkout'] != null
          ? Checkout.fromMap(map['checkout'])
          : null,
      orders: map['orders'] != null
          ? List<Order>.from(
              map['orders']['edges'].map((order) => Order.fromMap(order['node'])))
          : null,
    );
  }
}

class Address {
  final String streetAddress1;
  final String city;
  final String postalCode;

  Address({
    required this.streetAddress1,
    required this.city,
    required this.postalCode,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      streetAddress1: map['streetAddress1'] ?? '',
      city: map['city'] ?? '',
      postalCode: map['postalCode'] ?? '',
    );
  }
}

class Checkout {
  final String id;
  final Money totalPrice;
  final List<CheckoutLine> lines;

  Checkout({
    required this.id,
    required this.totalPrice,
    required this.lines,
  });

  factory Checkout.fromMap(Map<String, dynamic> map) {
    return Checkout(
      id: map['id'] ?? '',
      totalPrice: Money.fromMap(map['totalPrice']['gross']),
      lines: map['lines'] != null
          ? List<CheckoutLine>.from(
              map['lines'].map((line) => CheckoutLine.fromMap(line)))
          : [],
    );
  }
}

class CheckoutLine {
  final int quantity;
  final ProductVariant variant;

  CheckoutLine({
    required this.quantity,
    required this.variant,
  });

  factory CheckoutLine.fromMap(Map<String, dynamic> map) {
    return CheckoutLine(
      quantity: map['quantity'] ?? 0,
      variant: ProductVariant.fromMap(map['variant']),
    );
  }
}

class ProductVariant {
  final String id;
  final String name;
  final Product product;

  ProductVariant({
    required this.id,
    required this.name,
    required this.product,
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      product: Product.fromMap(map['product']),
    );
  }
}

class Product {
  final String name;
  final ImageProduct? thumbnail;
  final PricingInfo? pricing;

  Product({
    required this.name,
    this.thumbnail,
    this.pricing,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      thumbnail: map['thumbnail'] != null
          ? ImageProduct.fromMap(map['thumbnail'])
          : null,
      pricing: map['pricing'] != null
          ? PricingInfo.fromMap(map['pricing'])
          : null,
    );
  }
}

class ImageProduct {
  final String url;

  ImageProduct({required this.url});

  factory ImageProduct.fromMap(Map<String, dynamic> map) {
    return ImageProduct(
      url: map['url'] ?? '',
    );
  }
}

class PricingInfo {
  final PriceRange priceRange;

  PricingInfo({required this.priceRange});

  factory PricingInfo.fromMap(Map<String, dynamic> map) {
    return PricingInfo(
      priceRange: PriceRange.fromMap(map['priceRange']),
    );
  }
}

class PriceRange {
  final Money start;

  PriceRange({required this.start});

  factory PriceRange.fromMap(Map<String, dynamic> map) {
    return PriceRange(
      start: Money.fromMap(map['start']['net']),
    );
  }
}

class Money {
  final double amount;
  final String currency;

  Money({
    required this.amount,
    required this.currency,
  });

  factory Money.fromMap(Map<String, dynamic> map) {
    return Money(
      amount: map['amount']?.toDouble() ?? 0.0,
      currency: map['currency'] ?? '',
    );
  }
}

class Order {
  final String id;
  final String number;
  final String created;
  final String status;
  final Money total;
  final List<OrderLine> lines;

  Order({
    required this.id,
    required this.number,
    required this.created,
    required this.status,
    required this.total,
    required this.lines,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      number: map['number'] ?? '',
      created: map['created'] ?? '',
      status: map['status'] ?? '',
      total: Money.fromMap(map['total']['gross']),
      lines: map['lines'] != null
          ? List<OrderLine>.from(
              map['lines'].map((line) => OrderLine.fromMap(line)))
          : [],
    );
  }
}

class OrderLine {
  final int quantity;
  final ProductVariant? variant;

  OrderLine({
    required this.quantity,
    required this.variant,
  });

  factory OrderLine.fromMap(Map<String, dynamic>? map) {
    return OrderLine(
      quantity: map?['quantity'] ?? 0,
      variant: map?['variant'] != null ? ProductVariant.fromMap(map?['variant']) : null,
    );
  }
}
