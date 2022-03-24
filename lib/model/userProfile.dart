class UserProfile {
  final int id;
  final String name;
  final int age;
  final String phone;
  final String email;
  final String password;
  final String address;
  final List<String> preferences;
  final List<String> searchHistory;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
    required this.password,
    this.address = "",
    required this.preferences,
    required this.searchHistory,
  });

  UserProfile.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        age = data['age'],
        phone = data['phone'],
        email = data['email'],
        password = data['password'],
        address = data['address'],
        preferences = List.castFrom<dynamic, String>(data['preferences']),
        searchHistory = List.castFrom<dynamic, String>(data['searchHistory']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'phone': phone,
        'email': email,
        'password': password,
        'address': address,
        'preferences': preferences,
        'searchHistory': searchHistory,
      };
}
