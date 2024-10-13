class ProductModel {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final Pricing pricing;
  final List<ProductMedia>? media; // Thêm danh sách media
  final List<ProductVariant>? variants; // Thêm danh sách variants

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.pricing,
    required this.media, // Khởi tạo media
    required this.variants, // Khởi tạo media
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      thumbnailUrl: map['thumbnail']?['url'] ?? '',
      pricing: Pricing.fromMap(map['pricing']),
      media: (map['media'] as List<dynamic>)
          .map((mediaItem) => ProductMedia.fromMap(mediaItem))
          .toList(), // Map mảng media
      variants: (map['variants'] as List<dynamic>)
          .map((variantItem) => ProductVariant.fromMap(variantItem))
          .toList(), // Map mảng variants
    );
  }
}

class Pricing {
  final PriceRange priceRange;

  Pricing({required this.priceRange});

  factory Pricing.fromMap(Map<String, dynamic> map) {
    return Pricing(
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

  Money({required this.amount, required this.currency});

  factory Money.fromMap(Map<String, dynamic> map) {
    return Money(
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] ?? '',
    );
  }
}

// Model cho media
class ProductMedia {
  final String url;
  final String alt;

  ProductMedia({required this.url, required this.alt});

  factory ProductMedia.fromMap(Map<String, dynamic> map) {
    return ProductMedia(
      url: map['url'] ?? '',
      alt: map['alt'] ?? '',
    );
  }
}

class ProductVariant {
  final String id;
  final String name;
  final String sku;

  ProductVariant({required this.id, required this.name, required this.sku});

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      sku: map['sku'] ?? '',
    );
  }
}
