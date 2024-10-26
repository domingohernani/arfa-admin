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
}
