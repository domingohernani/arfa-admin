import 'dart:io';

import 'package:admin/services/firestoreService.dart';
import 'package:admin/utilities/dateconvertion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:universal_html/html.dart' as AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

Future<void> exportReportCSV(BuildContext context) async {
  try {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final workbook = excel.Workbook();
    final worksheet = workbook.worksheets[0];
    worksheet.getRangeByName('A1').setText("Title:");
    worksheet.getRangeByName('B1').setText(
        "Data Report in month of ${monthToText(int.parse(toMonth(Timestamp.fromDate(DateTime.now()))))}");
    worksheet.getRangeByName('A2').setText("Date:");
    worksheet.getRangeByName('B2').setText("${date}");

    //DATA FOR REPORT COLLECTION
    var fsReport = await FirestoreService().getMonthlyReport();

    worksheet
        .getRangeByName('A4')
        .setText("Revenue: ${fsReport.monthlyrevenue}");
    worksheet.getRangeByName('B4').setText("Orders: ${fsReport.monthlyorders}");
    worksheet.getRangeByName('C4').setText("New Users: ${fsReport.newusers}");
    worksheet
        .getRangeByName('D4')
        .setText("Total Users: ${fsReport.currentusers}");
    //END OF DATA FOR REPORT COLLECTION

    //DATA FOR SELLER IN USERS COLLECTION
    var fsSellers = await FirestoreService().getSellersData();

    worksheet.getRangeByName('A6').setText("SELLER ID");
    worksheet.getRangeByName('B6').setText("NAME");
    worksheet.getRangeByName('C6').setText("SHOP NAME");
    worksheet.getRangeByName('D6').setText("EMAIL");

    int rowIndex = 7;
    for (var seller in fsSellers) {
      worksheet.getRangeByName('A$rowIndex').setText(seller.id);
      worksheet
          .getRangeByName('B$rowIndex')
          .setText("${seller.firstname} ${seller.lastname}");
      worksheet.getRangeByName('C$rowIndex').setText("${seller.shopname}");
      worksheet.getRangeByName('D$rowIndex').setText("${seller.email}");
      rowIndex++;
    }
    //END OF DATA FOR USERS COLLECTION

    for (int i = 1; i <= 9; i++) {
      worksheet.autoFitColumn(i);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement.AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Report-${date}.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = "${path}/report.xlsx";
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Report Downloaded',
      width: 300,
    );
  } catch (error) {
    print("Error: ${error}");
  }
}
