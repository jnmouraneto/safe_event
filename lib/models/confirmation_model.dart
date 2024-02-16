class Confirmation {
  int? id;
  int? guestId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? detailsConfirm;

  Confirmation({
    this.id,
    this.guestId,
    this.createdAt,
    this.updatedAt,
    this.detailsConfirm
  });

  factory Confirmation.fromJson(Map<String, dynamic> json) {
    return Confirmation(
      id: json['id'],
      guestId: json['guest_id'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      detailsConfirm: json['details']
    );
  }



  @override
  String toString() {
    return 'Confirmation{id: $id, guestId: $guestId,  createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
