class CheckoutResponse {
  final String id;
  final List<CheckoutLineCheckoutResponse> lines;
  final Price totalPrice;

  CheckoutResponse({
    required this.id,
    required this.lines,
    required this.totalPrice,
  });

  factory CheckoutResponse.fromMap(Map<String, dynamic> map) {
    final checkout = map['checkout'];
    return CheckoutResponse(
      id: checkout['id'] ?? '',
      lines: List<CheckoutLineCheckoutResponse>.from(
        checkout['lines']
                ?.map((line) => CheckoutLineCheckoutResponse.fromMap(line)) ??
            [],
      ),
      totalPrice: Price.fromMap(checkout['totalPrice']?['gross']),
    );
  }
}

class CheckoutLineCheckoutResponse {
  final int quantity;
  final Variant variant;

  CheckoutLineCheckoutResponse({
    required this.quantity,
    required this.variant,
  });

  factory CheckoutLineCheckoutResponse.fromMap(Map<String, dynamic> map) {
    return CheckoutLineCheckoutResponse(
      quantity: map['quantity'] ?? 0,
      variant: Variant.fromMap(map['variant']),
    );
  }
}

class Variant {
  final String id;
  final String name;
  final Product product;

  Variant({
    required this.id,
    required this.name,
    required this.product,
  });

  factory Variant.fromMap(Map<String, dynamic> map) {
    return Variant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      product: Product.fromMap(map['product']),
    );
  }
}

class Product {
  final String name;
  final String thumbnailUrl;
  final PriceRange pricing;

  Product({
    required this.name,
    required this.thumbnailUrl,
    required this.pricing,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      thumbnailUrl:
          map['thumbnail']?['url'] ?? '', // Kiểm tra null cho thumbnail
      pricing: PriceRange.fromMap(map['pricing'] ?? {}),
    );
  }
}

class PriceRange {
  final Price start;

  PriceRange({
    required this.start,
  });

  factory PriceRange.fromMap(Map<String, dynamic> map) {
    return PriceRange(
      start: Price.fromMap(map['priceRange']?['start']?['net'] ?? {}),
    );
  }
}

class Price {
  final double amount;
  final String currency;

  Price({
    required this.amount,
    required this.currency,
  });

  factory Price.fromMap(Map<String, dynamic> map) {
    print('object------------------------$map');
    return Price(
      amount: map?['amount'] ?? 0.0, // Kiểm tra null và loại số
      currency: map?['currency'] ?? '', // Kiểm tra null cho currency
    );
  }
}
