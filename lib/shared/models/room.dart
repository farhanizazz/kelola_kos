import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';

class Room {
  final String? id;
  final String? dormId;
  final String roomName;
  final double price;
  final String notes;
  final DateTime? createdAt;
  final List<Resident>? residents;
  final bool occupied;

  Room({
    this.id,
    this.dormId,
    required this.occupied,
    required this.roomName,
    required this.price,
    required this.notes,
    this.createdAt,
    this.residents,
  });

  /// Factory method to create a `Room` object from a Firestore document
  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String?,
      dormId: map['dormId'] as String?,
      roomName: map['roomName'] as String,
      price: double.parse(map['price'].toString()),
      notes: map['notes'] as String,
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'] ?? ''),
      residents: (map['residents'] as List<dynamic>?)
          ?.map((e) => Resident.fromMap(e as Map<String, dynamic>))
          .toList(),
      occupied: map['occupied'] as bool,
    );
  }

  /// Converts a `Room` object to a Firestore-friendly map
  Map<String, dynamic> toMap() {
    return {
      'dormId': dormId,
      'roomName': roomName,
      'price': price.toString(),
      'notes': notes,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (residents != null)
        'residents': residents!.map((resident) => resident.toMap()).toList(),
    };
  }

  /// Creates a new instance of `Room` with updated fields
  Room copyWith({
    String? id,
    String? dormId,
    String? roomName,
    double? price,
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
      residents: residents ?? this.residents,
      occupied: occupied ?? this.occupied,
    );
  }
}