class Product {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String type; //thuc an, quan ao, phu kien
  final String typePet; // cho, meo, tho

  final List<Variant> variants;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.type,
    required this.typePet,
    required this.variants,
  });
  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? food,
    String? clothes,
    String? accessories,
    String? type,
    String? typePet,
    List<Variant>? variants,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      typePet: typePet ?? this.typePet,
      variants: variants ?? this.variants,
    );
  }
}

class Variant {
  final String id;
  final String name;

  Variant({
    required this.id,
    required this.name,
  });
}

//--------

// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final Pricing pricing;
//   final Thumbnail thumbnail;
//   final Category category;
//   final ProductType productType;
//   final List<Variant> variants;

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.pricing,
//     required this.thumbnail,
//     required this.category,
//     required this.productType,
//     required this.variants,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       pricing: Pricing.fromJson(json['pricing'] ?? {}),
//       thumbnail: Thumbnail.fromJson(json['thumbnail'] ?? {}),
//       category: Category.fromJson(json['category'] ?? {}),
//       productType: ProductType.fromJson(json['productType'] ?? {}),
//       variants: (json['variants'] as List<dynamic>?)
//               ?.map((variant) =>
//                   Variant.fromJson(variant as Map<String, dynamic>))
//               .toList() ??
//           [],
//     );
//   }
// }

// class Pricing {
//   final PriceRange priceRange;

//   Pricing({required this.priceRange});

//   factory Pricing.fromJson(Map<String, dynamic> json) {
//     return Pricing(
//       priceRange: PriceRange.fromJson(json['priceRange'] ?? {}),
//     );
//   }
// }

// class PriceRange {
//   final Price start;

//   PriceRange({required this.start});

//   factory PriceRange.fromJson(Map<String, dynamic> json) {
//     return PriceRange(
//       start: Price.fromJson(json['start'] ?? {}),
//     );
//   }
// }

// class Price {
//   final double amount;
//   final String currency;

//   Price({required this.amount, required this.currency});

//   factory Price.fromJson(Map<String, dynamic> json) {
//     return Price(
//       amount: (json['gross']?['amount'] as num?)?.toDouble() ?? 0.0,
//       currency: json['gross']?['currency'] ?? '',
//     );
//   }
// }

// class Thumbnail {
//   final String url;

//   Thumbnail({required this.url});

//   factory Thumbnail.fromJson(Map<String, dynamic> json) {
//     return Thumbnail(
//       url: json['url'] ?? '',
//     );
//   }
// }

// class Category {
//   final String id;
//   final String name;
//   final Parent? parent;

//   Category({required this.id, required this.name, this.parent});

//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       parent: json['parent'] != null
//           ? Parent.fromJson(json['parent'] as Map<String, dynamic>)
//           : null,
//     );
//   }
// }

// class Parent {
//   final String id;
//   final String name;
//   final String slug;

//   Parent({required this.id, required this.name, required this.slug});

//   factory Parent.fromJson(Map<String, dynamic> json) {
//     return Parent(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       slug: json['slug'] ?? '',
//     );
//   }
// }

// class ProductType {
//   final String id;
//   final String name;
//   final String slug;

//   ProductType({required this.id, required this.name, required this.slug});

//   factory ProductType.fromJson(Map<String, dynamic> json) {
//     return ProductType(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       slug: json['slug'] ?? '',
//     );
//   }
// }

// class Variant {
//   final String id;
//   final String name;

//   Variant({required this.id, required this.name});

//   factory Variant.fromJson(Map<String, dynamic> json) {
//     return Variant(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }
