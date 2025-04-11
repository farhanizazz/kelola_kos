import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';

class Room {
  final String? id;
  final String? dormId;
  final String roomName;
  final int price;
  final String notes;
  final DateTime? createdAt;

  Room({
    this.id,
    this.dormId,
    required this.roomName,
    required this.price,
    required this.notes,
    this.createdAt,
  });

  /// Factory method to create a `Room` object from a Firestore document
  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String?,
      dormId: map['dormId'] as String?,
      roomName: map['roomName'] as String,
      price: map['price'],
      notes: map['notes'] as String,
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'] ?? ''),

    );
  }

  /// Converts a `Room` object to a Firestore-friendly map
  Map<String, dynamic> toMap({String? userId}) {
    return {
      if(userId != null) 'userId': userId,
      'dormId': dormId,
      'roomName': roomName,
      'price': price,
      'notes': notes,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  /// Creates a new instance of `Room` with updated fields
  Room copyWith({
    String? id,
    String? dormId,
    String? roomName,
    int? price,
    String? notes,
    int? capacity,
    DateTime? createdAt,
    List<Resident>? residents,
    bool? occupied
  }) {
    return Room(
      id: id ?? this.id,
      dormId: dormId ?? this.dormId,
      roomName: roomName ?? this.roomName,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Room) return false;

    return other.id == id &&
        other.dormId == dormId &&
        other.roomName == roomName &&
        other.price == price &&
        other.notes == notes &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    dormId.hashCode ^
    roomName.hashCode ^
    price.hashCode ^
    notes.hashCode ^
    createdAt.hashCode;
  }
}