import 'package:intl/intl.dart';

class FireAlert {
  final String message;
  final String? category;
  String? area;
  String? name;
  double? temperature;
  double? safeThreshold;
  bool isHandled;
  DateTime? handledTime;
  String? imageUrl;
  final bool isLatest;
  final DateTime timestamp;

  FireAlert({
    required this.message,
    this.category,
    this.area,
    this.name,
    this.temperature,
    this.safeThreshold,
    this.isHandled = false,
    this.handledTime,
    this.imageUrl,
    DateTime? timestamp,
    this.isLatest = false,
  }) : timestamp = timestamp ?? DateTime.now();

  
  factory FireAlert.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return FireAlert(
      message: json['message'] ?? '',
      area: data['area'],
      name: data['name'],
      temperature: (data['temperature'] as num?)?.toDouble(),
      safeThreshold: (data['safe_threshold'] as num?)?.toDouble(),
      timestamp: _parseTimestamp(data['timestamp']),
    );
  }

  static DateTime _parseTimestamp(String? ts) {
    if (ts == null) return DateTime.now();
    try {
      return DateFormat("dd/MM/yyyy HH:mm:ss").parse(ts);
    } catch (_) {
      return DateTime.now(); // sửa chỗ này
    }
  }


  FireAlert copyWith({bool? isLatest}) {
    return FireAlert(
      message: message,
      category: category,
      area: area,
      name: name,
      temperature: temperature,
      safeThreshold: safeThreshold,
      isHandled: isHandled,
      handledTime: handledTime,
      imageUrl: imageUrl,
      timestamp: timestamp,
      isLatest: isLatest ?? this.isLatest,
    );
  }
}

