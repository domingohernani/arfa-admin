import 'dart:io';

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
    final workbook = excel.Workbook();
    final worksheet = workbook.worksheets[0];
    worksheet.getRangeByName('A1').setText("Hey");
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
