class ScheduledNotification {
  final int id;
  final String residentName;
  final DateTime scheduledTime;
  final Duration recurrenceInterval;

  ScheduledNotification({
    required this.id,
    required this.residentName,
    required this.scheduledTime,
    required this.recurrenceInterval,
  });

  ScheduledNotification copyWith({
    int? id,
    String? residentName,
    DateTime? scheduledTime,
    Duration? recurrenceInterval,
  }) {
    return ScheduledNotification(
      id: id ?? this.id,
      residentName: residentName ?? this.residentName,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'residentName': residentName,
      'scheduledTime': scheduledTime.toIso8601String(),
      'recurrenceInterval': recurrenceInterval.inMilliseconds,
    };
  }

  factory ScheduledNotification.fromMap(Map<String, dynamic> map) {
    return ScheduledNotification(
      id: map['id'],
      residentName: map['residentName'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      recurrenceInterval: Duration(milliseconds: map['recurrenceInterval']),
    );
  }

  @override
  String toString() {
    return 'ScheduledNotification(id: $id, residentName: $residentName, scheduledTime: $scheduledTime, recurrenceInterval: $recurrenceInterval)';
  }
}
