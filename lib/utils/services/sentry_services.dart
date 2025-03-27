import 'package:sentry_flutter/sentry_flutter.dart';

/// Filter error sentry before send to sentry server
///
/// if [event.throwable.toString]
/// contains "RenderFlex" || "overflowed" || BottomSheet.enableDrag
/// return null (dont send anything)
Future<SentryEvent?> filterSentryErrorBeforeSend(
  SentryEvent event, {
  Hint? hint,
}) async {
  if (event.throwable.toString().contains("RenderFlex")) {
    return null;
  }

  if (event.throwable.toString().contains("overflowed")) {
    return null;
  }

  if (event.throwable.toString().contains("BottomSheet.enableDrag")) {
    return null;
  }

  return event;
}
