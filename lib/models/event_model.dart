import 'package:safe_event/models/guest_model.dart';
import 'package:safe_event/models/responsible_event_model.dart';



class Event {
  int? id;
  bool isStarted;
  String name;
  String description;
  String? coverImage;
  DateTime eventAt;
  DateTime? finishedAt;
  DateTime createdAt;
  DateTime updatedAt;
  Responsible? responsible;

  Event({
    required this.id,
    required this.isStarted,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.eventAt,
    required this.finishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.responsible
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
    
      description: json['description'],
      coverImage: json['cover_image'] ?? null,
      eventAt: DateTime.parse(json['event_at']),
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']), isStarted: true,
      responsible: json['responsible'] != null
      ?Responsible.fromJson(json['responsible'])
      :null
      
    );
  }
}

  // int calculateConfirmations() {
  //   int confirmations = 0;

  //   guests.forEach((guest) {
  //     if (guest.confirmation != null) {
  //       confirmations++;
  //     }
  //   });

  //   return confirmations;
  // }

