import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser {
  final String uid;
  final String email;
  final String name;
  final String fullName;
  final String phoneNumber;
  final Timestamp? createdAt;
  final Timestamp? lastLoggedInAt;

  FirestoreUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.fullName,
    required this.phoneNumber,
    this.createdAt,
    this.lastLoggedInAt,
  });

  /// Convert Firestore document to UserModel
  factory FirestoreUser.fromMap(String id, Map<String, dynamic> map) {
    return FirestoreUser(
      uid: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      lastLoggedInAt: map['lastLoggedInAt'] != null ? map['lastLoggedInAt'] as Timestamp : null,
    );
  }

  /// Convert UserModel to Firestore-friendly map
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };

    if (createdAt != null) data['createdAt'] = createdAt;
    if (lastLoggedInAt != null) data['lastLoggedInAt'] = lastLoggedInAt;

    return data;
  }

  FirestoreUser copyWith({
    String? uid,
    String? email,
    String? name,
    String? fullName,
    String? phoneNumber,
    Timestamp? createdAt,
    Timestamp? lastLoggedInAt,
  }) {
    return FirestoreUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLoggedInAt: lastLoggedInAt ?? this.lastLoggedInAt,
    );
  }
}
