import 'package:admin/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewDocumentModal extends StatefulWidget {
  final String? idurl, permiturl;
  const ViewDocumentModal({super.key, this.idurl, this.permiturl});

  @override
  State<ViewDocumentModal> createState() => _ViewDocumentModalState();
}

class _ViewDocumentModalState extends State<ViewDocumentModal> {
  final GlobalKey<SfPdfViewerState> _idpdfViewerKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _permitpdfViewerKey = GlobalKey();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _idpdfViewerKey.currentContext;
    _permitpdfViewerKey.currentContext;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.7;
    var height = MediaQuery.of(context).size.height * 0.9;
    return Center(
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade200,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "UPLOADED DOCUMENTS",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primary,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Valid ID",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textWhite,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 500, // Set a fixed height for the container
                      child: Stack(
                        children: [
                          SfPdfViewer.network(
                            widget.idurl.toString(),
                            key: _idpdfViewerKey,
                            initialZoomLevel: 2,
                            canShowScrollHead: true,
                            canShowPageLoadingIndicator: true,
                            scrollDirection: PdfScrollDirection.vertical,
                            onDocumentLoaded: (details) {
                              setState(() =>
                                  _isLoading = false); // Hide loader on load
                            },
                            onDocumentLoadFailed: (details) {
                              print(
                                  "PDF failed to load: ${details.description}");
                            },
                          ),
                          if (_isLoading)
                            Center(
                                child:
                                    CircularProgressIndicator()), // Show loader
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primary,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Business Permit",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textWhite,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 500, // Set a fixed height for the container
                      child: Stack(
                        children: [
                          SfPdfViewer.network(
                            widget.permiturl.toString(),
                            key: _permitpdfViewerKey,
                            initialZoomLevel: 2,
                            canShowScrollHead: true,
                            canShowPageLoadingIndicator: true,
                            scrollDirection: PdfScrollDirection.vertical,
                            onDocumentLoaded: (details) {
                              setState(() =>
                                  _isLoading = false); // Hide loader on load
                            },
                            onDocumentLoadFailed: (details) {
                              print(
                                  "PDF failed to load: ${details.description}");
                            },
                          ),
                          if (_isLoading)
                            Center(
                                child:
                                    CircularProgressIndicator()), // Show loader
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                ),
                shape: CircleBorder(),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
