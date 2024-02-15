class Guest {
  final int id;
  final String name;
  final String phone;
  final String email;
  final bool active;
  final int eventId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String confirmation;

  Guest({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.active,
    required this.eventId,
    required this.createdAt,
    required this.updatedAt,
    required this.confirmation
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      active: json['active'] as bool,
      eventId: json['event_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      confirmation: "em 23/12/2023"
    );
  }
}
