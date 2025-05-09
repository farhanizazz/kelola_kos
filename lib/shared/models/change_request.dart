import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelola_kos/shared/models/request_status_enum.dart';

class ChangeRequest {
  final String id;
  final String body;
  final ChangeSet changes;
  final DateTime createdAt;
  final String receiverUserId;
  final String senderUserId;
  final RequestStatus status;
  final String title;
  final String userType;

  ChangeRequest({
    required this.id,
    required this.body,
    required this.changes,
    required this.createdAt,
    required this.receiverUserId,
    required this.senderUserId,
    required this.status,
    required this.title,
    required this.userType,
  });

  factory ChangeRequest.fromMap(Map<String, dynamic> json) {
    return ChangeRequest(
      id: json['id'] ?? '',
      body: json['body'] ?? '',
      changes: ChangeSet.fromJson(json['changes'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      receiverUserId: json['receiverUserId'] ?? '',
      senderUserId: json['senderUserId'] ?? '',
      status: RequestStatus.fromString(json['status'] ?? ''),
      title: json['title'] ?? '',
      userType: json['userType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'changes': changes.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'receiverUserId': receiverUserId,
      'senderUserId': senderUserId,
      'status': status.value,
      'title': title,
      'userType': userType,
    };
  }

  @override
  String toString() {
    return 'ChangeRequest{id: $id, body: $body, changes: $changes, createdAt: $createdAt, receiverUserId: $receiverUserId, senderUserId: $senderUserId, status: $status, title: $title, userType: $userType}';
  }
}

class ChangeSet {
  final ChangeField paymentDay;
  final ChangeField paymentMonth;
  final ChangeField phone;
  final ChangeField recurrenceInterval;

  ChangeSet({
    required this.paymentDay,
    required this.paymentMonth,
    required this.phone,
    required this.recurrenceInterval,
  });

  factory ChangeSet.fromJson(Map<String, dynamic> json) {
    return ChangeSet(
      paymentDay: ChangeField.fromJson(json['paymentDay'] ?? {}),
      paymentMonth: ChangeField.fromJson(json['paymentMonth'] ?? {}),
      phone: ChangeField.fromJson(json['phone'] ?? {}),
      recurrenceInterval: ChangeField.fromJson(json['recurrenceInterval'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentDay': paymentDay.toJson(),
      'paymentMonth': paymentMonth.toJson(),
      'phone': phone.toJson(),
      'recurrenceInterval': recurrenceInterval.toJson(),
    };
  }

  @override
  String toString() {
    return 'ChangeSet{paymentDay: $paymentDay, paymentMonth: $paymentMonth, phone: $phone, recurrenceInterval: $recurrenceInterval}';
  }
}

class ChangeField {
  final String old;
  final String newValue;

  ChangeField({required this.old, required this.newValue});

  factory ChangeField.fromJson(Map<String, dynamic> json) {
    return ChangeField(
      old: json['old'] ?? '',
      newValue: json['new'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'old': old,
      'new': newValue,
    };
  }

  @override
  String toString() {
    return 'ChangeField{old: $old, newValue: $newValue}';
  }
}
