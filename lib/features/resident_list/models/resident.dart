import 'package:kelola_kos/utils/functions/normalize_phone_number.dart';

class Resident {
  final String id;
  final String ownerId;
  final String name;
  final String phone;
  final String roomId;
  final String dormId;
  final int paymentDay;
  final int paymentMonth;
  final bool paymentStatus;
  final Duration recurrenceInterval;
  final String? invoicePath;

  Resident({
    required this.paymentDay,
    required this.paymentMonth,
    required this.ownerId,
    required this.id,
    required this.name,
    required this.phone,
    required this.roomId,
    required this.dormId,
    required this.paymentStatus,
    required this.recurrenceInterval,
    this.invoicePath,
  });

  factory Resident.fromMap(Map<String, dynamic> data) {
    return Resident(
      ownerId: data['userId'],
      paymentDay: data['paymentDay'],
      paymentMonth: data['paymentMonth'],
      id: normalizePhoneNumber(data['phone']),
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      roomId: data['roomId'] ?? '',
      dormId: data['dormId'] ?? '',
      paymentStatus: data['paymentStatus'] ?? false,
      recurrenceInterval: Duration(milliseconds: data['recurrenceInterval']),
      invoicePath: data['invoicePath'],
    );
  }

  // Convert Resident object to JSON
  Map<String, dynamic> toMap({String? userId}) {
    return {
      if(userId != null) 'userId': userId,
      'name': name,
      'phone': phone,
      'roomId': roomId,
      'dormId': dormId,
      'paymentDay': paymentDay,
      'paymentMonth': paymentMonth,
      'paymentStatus': paymentStatus,
      'recurrenceInterval': recurrenceInterval.inMilliseconds,
      'invoicePath': invoicePath,
    };
  }

  Resident copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? phone,
    String? roomId,
    String? dormId,
    int? paymentDay,
    int? paymentMonth,
    bool? paymentStatus,
    Duration? recurrenceInterval,
    String? invoicePath,
  }) {
    return Resident(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      roomId: roomId ?? this.roomId,
      dormId: dormId ?? this.dormId,
      paymentDay: paymentDay ?? this.paymentDay,
      paymentMonth: paymentMonth ?? this.paymentMonth,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      invoicePath: invoicePath ?? this.invoicePath,
    );
  }


  /// Equality override
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Check if they are the same reference
    if (other.runtimeType != runtimeType) return false;

    return other is Resident &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.roomId == roomId &&
        other.dormId == dormId &&
        other.paymentDay == paymentDay &&
        other.paymentMonth == paymentMonth &&
        other.recurrenceInterval == recurrenceInterval &&
        other.invoicePath == invoicePath &&
        other.paymentStatus == paymentStatus;
  }

  /// HashCode override
  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    phone.hashCode ^
    roomId.hashCode ^
    paymentDay.hashCode ^
    paymentMonth.hashCode ^
    dormId.hashCode ^
    recurrenceInterval.hashCode ^
    invoicePath.hashCode ^
    paymentStatus.hashCode;
  }

  @override
  String toString() {
    return 'Resident{id: $id, name: $name, phone: $phone, roomId: $roomId, dormId: $dormId, paymentDay: $paymentDay, paymentMonth: $paymentMonth, paymentStatus: $paymentStatus, recurrenceInterval: $recurrenceInterval, invoicePath: $invoicePath}';
  }
}
