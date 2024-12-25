class Subscription {
  final int packageId;
  final DateTime startDate;
  final DateTime endDate;

  Subscription({
    required this.packageId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'package_id': packageId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
