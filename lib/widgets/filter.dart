// lib/utils/alert_filter.dart

import '../models/fire_alert.dart';

enum AlertFilterType {
  all,
  handled,
  unhandled
}

final Map<AlertFilterType, String> filterOptions = {
  AlertFilterType.all: 'Tất cả',
  AlertFilterType.handled: 'Đã xử lý',
  AlertFilterType.unhandled: 'Chưa xử lý'
};

List<FireAlert> getFilteredAlerts(List<FireAlert> alerts, AlertFilterType filter) {
  switch (filter) {
    case AlertFilterType.handled:
      return alerts.where((a) => a.isHandled).toList();
    case AlertFilterType.unhandled:
      return alerts.where((a) => !a.isHandled).toList();
    default:
      return alerts;
  }
}
