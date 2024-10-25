import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String toMonth(Timestamp date) {
  Timestamp timestamp = date;
  DateTime datetime = timestamp.toDate();
  String formatteddate = DateFormat('MM').format(datetime);
  return formatteddate;
}

String monthToText(int month) {
  const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  return monthNames[month - 1];
}
