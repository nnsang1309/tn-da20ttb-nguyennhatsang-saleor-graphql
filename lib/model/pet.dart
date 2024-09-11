class Pet {
  final String? id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;
  final String type;
  final int typePet;

  Pet({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.type,
    required this.typePet,
  });
  Pet copyWith({
    String? id,
    String? tille,
    String? description,
    int? price,
    String? imageUrl,
    String? food,
    String? clothes,
    String? accessories,
    String? type,
    int? typePet,
  }) {
    return Pet(
      id: id ?? this.id,
      title: title ?? title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      typePet: typePet ?? this.typePet,
    );
  }
}
