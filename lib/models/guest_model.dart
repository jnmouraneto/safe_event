import 'package:safe_event/models/confirmation_model.dart';

class Guest {
  final int id;
  final String name;
  final String phone;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Confirmation? confirmation;

  Guest({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.confirmation,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      confirmation: json['confirmation'] != null
          ? Confirmation.fromJson(json['confirmation'])
          : null,
    );
  }
}
