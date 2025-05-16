import 'package:kelola_kos/features/resident_list/models/resident.dart';
import 'package:kelola_kos/shared/models/room.dart';

class Dorm {
  final String? id;
  final String name;
  final String location;
  final int residentCount;
  final int roomCount;
  final List<Room> rooms;
  final List<Resident> residents;
  final String? note;
  final String? image;

  Dorm({
    this.id,
    this.image,
    required this.name,
    required this.note,
    required this.location,
    required this.residentCount,
    required this.roomCount,
    required this.rooms,
    required this.residents,
  });

  factory Dorm.fromMap(Map<String, dynamic> map) {
    return Dorm(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      image: map['image'],
      note: map['note'],
      location: map['location'] ?? '',
      residentCount: map['residentCount'] ?? 0,
      roomCount: map['roomCount'] ?? 0,
      rooms: (map['rooms'] as List?)?.map((room) => Room.fromMap(room)).toList() ?? [],
      residents: (map['residents'] as List?)?.map((res) => Resident.fromMap(res)).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'location': location,
      'image': image,
      'residentCount': residentCount,
      'roomCount': roomCount,
      'rooms': rooms.map((room) => room.toMap()).toList(),
      'residents': residents.map((res) => res.toMap()).toList(),
    };

    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  Dorm copyWith({
    String? id,
    String? name,
    String? location,
    int? roomCount,
    int? residentCount,
    List<Room>? rooms,
    List<Resident>? residents,
    String? note,
    String? image,
  }) {
    return Dorm(
      image: image ?? this.image,
      id: id ?? this.id,
      note: note ?? this.note,
      name: name ?? this.name,
      location: location ?? this.location,
      roomCount: roomCount ?? this.roomCount,
      residentCount: residentCount ?? this.residentCount,
      rooms: rooms ?? this.rooms,
      residents: residents ?? this.residents,
    );
  }

  @override
  String toString() {
    return 'Dorm{id: $id, name: $name, location: $location, residentCount: $residentCount, roomCount: $roomCount, rooms: $rooms, residents: $residents, note: $note, image: $image}';
  }
}
