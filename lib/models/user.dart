class User {
  final String id;
  final String name;
  final String email;
  final String address;
  final String mobile;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.address
    // Add more constructor parameters as needed
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '', // Ensure 'id' is not null
      name: json['name'] ?? '', // Ensure 'name' is not null
      email: json['email'] ?? '', // Ensure 'email' is not null
      mobile: json['mobile'] ?? '', // Ensure 'mobile' is not null
      address: json['address'] ?? '', // Ensure 'address' is not null
      // Initialize other properties from json
    );
  }
}
