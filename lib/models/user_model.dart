// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bankAccount;
  final String? carNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bankAccount,
    this.carNumber,
  });

  // Create from JSON (for when we connect to API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      bankAccount: json['bankAccount'],
      carNumber: json['carNumber'],
    );
  }

  // Convert to JSON (for when we connect to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bankAccount': bankAccount,
      'carNumber': carNumber,
    };
  }

  // Copy with for updating user data
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? bankAccount,
    String? carNumber,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bankAccount: bankAccount ?? this.bankAccount,
      carNumber: carNumber ?? this.carNumber,
    );
  }
}
