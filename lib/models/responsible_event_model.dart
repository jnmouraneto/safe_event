class Responsible {
  final String name;
  final String phone;

  Responsible({required this.name, required this.phone});

  factory Responsible.fromJson(Map<String, dynamic> json) {
    return Responsible(
      name: json['name'],
      phone: json['phone'],
    );
  }
}