class CheckoutModel {
  final String id;
  final String token;
  final String email;
  final DateTime created;
  final TotalPrice totalPrice;
  final List<CheckoutLine> lines;

  CheckoutModel({
    required this.id,
    required this.token,
    required this.email,
    required this.created,
    required this.totalPrice,
    required this.lines,
  });

  factory CheckoutModel.fromMap(Map<String, dynamic> map) {
    return CheckoutModel(
      id: map['id'] ?? '',
      token: map['token'] ?? '',
      email: map['email'] ?? '',
      created: DateTime.parse(map['created']),
      totalPrice: TotalPrice.fromMap(map['totalPrice']),
      lines: (map['lines'] as List<dynamic>)
          .map((line) => CheckoutLine.fromMap(line))
          .toList(),
    );
  }
}

class TotalPrice {
  final Money gross;

  TotalPrice({required this.gross});

  factory TotalPrice.fromMap(Map<String, dynamic> map) {
    return TotalPrice(
      gross: Money.fromMap(map['gross']),
    );
  }
}

class Money {
  final double amount;
  final String currency;

  Money({required this.amount, required this.currency});

  factory Money.fromMap(Map<String, dynamic> map) {
    return Money(
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] ?? '',
    );
  }
}

class CheckoutLine {
  final Variant variant;
  final int quantity;

  CheckoutLine({required this.variant, required this.quantity});

  factory CheckoutLine.fromMap(Map<String, dynamic> map) {
    return CheckoutLine(
      variant: Variant.fromMap(map['variant']),
      quantity: map['quantity'] ?? 0,
    );
  }
}

class Variant {
  final Product product;

  Variant({required this.product});

  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      product: Product.fromMap(map['product']),
    );
  }
}

class Product {
  final String name;

  Product({required this.name});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
    );
  }
}
