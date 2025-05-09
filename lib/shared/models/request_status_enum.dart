enum RequestStatus {
  pending,
  accepted,
  declined;

  String get value {
    switch (this) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.declined:
        return 'declined';
    }
  }

  static RequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'accepted':
        return RequestStatus.accepted;
      case 'declined':
        return RequestStatus.declined;
      default:
        throw ArgumentError('Unknown status: $status');
    }
  }
}