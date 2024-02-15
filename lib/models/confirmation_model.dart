class Confirmation {
  int? id;
  int? guestId;
  String? note;
  String? createdAt;
  String? updatedAt;
  String? detailsConfirm;

  Confirmation({
    this.id,
    this.guestId,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.detailsConfirm
  });

  factory Confirmation.fromJson(Map<String, dynamic> json) {
    return Confirmation(
      id: json['id'],
      guestId: json['guest_id'],
      note: json['note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      detailsConfirm: json['details_confirm']
    );
  }



  @override
  String toString() {
    return 'Confirmation{id: $id, guestId: $guestId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
