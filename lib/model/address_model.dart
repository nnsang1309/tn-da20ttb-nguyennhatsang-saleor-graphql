class AddressFull {
  final String firstName;
  final String lastName;
  final String companyName;
  final String streetAddress1;
  final String? streetAddress2; // Có thể không có
  final String city;
  final String cityArea;
  final String postalCode;
  final String country;
  final String countryArea;
  final String phone;
  final bool isDefaultBillingAddress;
  final bool isDefaultShippingAddress;

  AddressFull({
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.streetAddress1,
    this.streetAddress2,
    required this.city,
    required this.cityArea,
    required this.postalCode,
    required this.country,
    required this.countryArea,
    required this.phone,
    required this.isDefaultBillingAddress,
    required this.isDefaultShippingAddress,
  });

  factory AddressFull.fromMap(Map<String, dynamic> map) {
    return AddressFull(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      companyName: map['companyName'] ?? '',
      streetAddress1: map['streetAddress1'] ?? '',
      streetAddress2: map['streetAddress2'],
      city: map['city'] ?? '',
      cityArea: map['cityArea'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
      countryArea: map['countryArea'] ?? '',
      phone: map['phone'] ?? '',
      isDefaultBillingAddress: map['isDefaultBillingAddress'] ?? false,
      isDefaultShippingAddress: map['isDefaultShippingAddress'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'companyName': companyName,
      'streetAddress1': streetAddress1,
      'streetAddress2': streetAddress2,
      'city': city,
      'cityArea': cityArea,
      'postalCode': postalCode,
      'country': country,
      'countryArea': countryArea,
      'phone': phone,
      'isDefaultBillingAddress': isDefaultBillingAddress,
      'isDefaultShippingAddress': isDefaultShippingAddress,
    };
  }
}
