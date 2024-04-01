class Restaurant {
  final String id;
  final String name;
  final String address;
  final String image;
  final String phoneNumber;
  final String foodType;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.phoneNumber,
    required this.foodType
    // Add more constructor parameters as needed
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '', // Ensure 'id' is not null
      name: json['name'] ?? '', // Ensure 'name' is not null
      address: json['address'] ?? '', // Ensure 'address' is not null
      image: json['image'] ?? '', // Ensure 'image' is not null
      phoneNumber: json['phone_number'] ?? '',
      foodType: json['foodType'], // Ensure 'phone_number' is not null

      // Initialize other properties from json
    );
  }
}
