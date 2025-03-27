class Resident {
  final String id;
  final String name;
  final String phone;
  final String roomId;
  final String dormId;
  final bool paymentStatus;

  Resident({
    required this.id,
    required this.name,
    required this.phone,
    required this.roomId,
    required this.dormId,
    required this.paymentStatus
  });

  factory Resident.fromMap(Map<String, dynamic> data) {
    return Resident(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      roomId: data['roomId'] ?? '',
      dormId: data['dormId'] ?? '',
      paymentStatus: data['paymentStatus'] ?? false
    );
  }

  // Convert Resident object to JSON
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'roomId': roomId,
      'dormId': dormId,
      'paymentStatus': paymentStatus,
    };
  }
}
