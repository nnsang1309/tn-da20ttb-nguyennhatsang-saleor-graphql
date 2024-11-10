import 'dart:convert';

class Product {
  final String id;
  final String name;
  final String description;
  final double pricing;
  final String thumbnail;
  final String category; // cho, meo, tho
  final String productType;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.pricing,
    required this.thumbnail,
    required this.category,
    required this.productType,
    required this.variants,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? pricing,
    String? thumbnail,
    String? category,
    String? productType,
    List<Variant>? variants,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pricing: pricing ?? this.pricing,
      thumbnail: thumbnail ?? this.thumbnail,
      category: category ?? this.category,
      productType: productType ?? this.productType,
      variants: variants ?? List.unmodifiable(this.variants),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    double pricingAmount = 0.0;
    if (json['pricing'] != null &&
        json['pricing']['priceRange'] != null &&
        json['pricing']['priceRange']['start'] != null &&
        json['pricing']['priceRange']['start']['gross'] != null &&
        json['pricing']['priceRange']['start']['gross']['amount'] != null) {
      pricingAmount =
          json['pricing']['priceRange']['start']['gross']['amount'].toDouble();
    }

    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricing: pricingAmount,
      thumbnail: json['thumbnail']['url'] ?? '',
      category: json['category']['parent']?['slug'] ?? '',
      productType: json['productType']['name'] ?? '',
      variants:
          (json['variants'] as List).map((v) => Variant.fromJson(v)).toList(),
    );
  }

  // Hàm giải mã mô tả
  String getDecodedDescription() {
    try {
      Map<String, dynamic> decodedJson = jsonDecode(description);
      return decodedJson['blocks'][0]['data']['text'];
    } catch (e) {
      // Xử lý lỗi nếu có
      return 'Mô tả không khả dụng';
    }
  }
}

// class PriceRange {
//   final Start start;

//   PriceRange({required this.start});

//   factory PriceRange.fromJson(Map<String, dynamic> json) {
//     return PriceRange(start: Start.fromJson(json['start']));
//   }
// }

// class Start {
//   final Gross gross;

//   Start({required this.gross});

//   factory Start.fromJson(Map<String, dynamic> json) {
//     return Start(gross: Gross.fromJson(json['gross']));
//   }
// }

class Gross {
  final String amount;
  final String currency;

  Gross({required this.amount, required this.currency});

  factory Gross.fromJson(Map<String, dynamic> json) {
    return Gross(amount: json['amount'], currency: json['currency']);
  }
}

class Variant {
  final String id;
  final String name;

  Variant({required this.id, required this.name});

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(id: json['id'], name: json['name']);
  }
}
