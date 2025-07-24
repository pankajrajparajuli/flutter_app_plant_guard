class User {
  final String firstName;
  final String lastName;
  final String username;

  User({required this.firstName, required this.lastName, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
    );
  }
}