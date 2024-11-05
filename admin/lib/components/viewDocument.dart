import 'package:admin/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _openPdfInBrowser(String url) async {
    try {
      // Check if the URL can be launched
      if (await canLaunch(url)) {
        await launch(
          url,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("Error opening PDF: $e");
    }
  }

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
                  fontSize: 22,
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: primary,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Container(
                          height: 30,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                  color: primary,
                                ),
                                left: BorderSide(
                                  color: primary,
                                ),
                                bottom: BorderSide(
                                  color: primary,
                                )),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _openPdfInBrowser(widget.idurl.toString());
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.open_in_browser_rounded,
                                  size: 20,
                                  color: primary,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "Open in Browser",
                                  style: TextStyle(
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(),
                            ),
                          ),
                        ),
                      ],
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
                            canShowScrollHead: true,
                            canShowPageLoadingIndicator: true,
                            scrollDirection: PdfScrollDirection.vertical,
                            onDocumentLoaded: (details) {
                              setState(() =>
                                  _isLoading = false); // Hide loader on load
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
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Container(
                          height: 30,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                  color: primary,
                                ),
                                left: BorderSide(
                                  color: primary,
                                ),
                                bottom: BorderSide(
                                  color: primary,
                                )),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _openPdfInBrowser(widget.permiturl.toString());
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.open_in_browser_rounded,
                                  size: 20,
                                  color: primary,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "Open in Browser",
                                  style: TextStyle(
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(),
                            ),
                          ),
                        ),
                      ],
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
                            canShowScrollHead: true,
                            canShowPageLoadingIndicator: true,
                            scrollDirection: PdfScrollDirection.vertical,
                            onDocumentLoaded: (details) {
                              setState(() =>
                                  _isLoading = false); // Hide loader on load
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
