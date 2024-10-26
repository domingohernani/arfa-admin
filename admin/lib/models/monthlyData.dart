class MonthlyReport {
  final String id;
  final int newusers;
  final int currentusers;
  final double monthlyrevenue;
  final int monthlyorders;
  final int month;
  final int year;

  MonthlyReport({
    required this.id,
    required this.newusers,
    required this.currentusers,
    required this.monthlyrevenue,
    required this.monthlyorders,
    required this.month,
    required this.year,
  });

  factory MonthlyReport.fromFirestore(Map<String, dynamic> data) {
    return MonthlyReport(
      id: data['id'] ?? '',
      newusers: data['newUsers'] ?? '',
      currentusers: data['currentusers'] ?? '',
      monthlyrevenue: data['monthlyRevenue'] ?? 0,
      monthlyorders: data['monthlyOrders'],
      month: data['month'] ?? [],
      year: data['year'] ?? [],
    );
  }
}
