import 'package:intl/intl.dart';
import 'package:kelola_kos/features/resident_list/models/resident.dart';

extension ResidentDateExtension on Resident {
  String getNextPaymentDateString() {
    // Create the base date from paymentMonth and paymentDay
    final now = DateTime.now();
    final baseDate = DateTime(now.year, paymentMonth, paymentDay);

    // If baseDate is in the past, assume it's for the next cycle
    final adjustedBase = baseDate.isBefore(now) ?
    DateTime(now.year + 1, paymentMonth, paymentDay) :
    baseDate;

    // Add recurrenceInterval to base date
    final nextDate = adjustedBase.add(recurrenceInterval);

    // Format to string: e.g., "23 April 2025"
    return DateFormat('d MMMM yyyy').format(nextDate);
  }
}