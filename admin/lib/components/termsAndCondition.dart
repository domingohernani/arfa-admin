import 'dart:typed_data';
import 'package:admin/components/cookiespolicy.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionUploader extends StatefulWidget {
  @override
  _TermsAndConditionUploaderState createState() =>
      _TermsAndConditionUploaderState();
}

class _TermsAndConditionUploaderState extends State<TermsAndConditionUploader> {
  bool _isUploading = false;
  String? _uploadStatus;

  Future<void> confirmAndUpload() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Upload',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Are you sure you want to update the terms and conditions? '
            'This action will replace the \n existing file and update the terms and conditions displayed on the website.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      uploadFile();
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
      );

      if (result != null) {
        String fileName = result.files.single.name;
        Uint8List? fileBytes = result.files.single.bytes;

        if (fileBytes != null) {
          setState(() {
            _isUploading = true;
            _uploadStatus = null;
          });

          final storageRef = FirebaseStorage.instance
              .ref()
              .child('platform/termsandconditions/$fileName');

          final uploadTask = storageRef.putData(fileBytes);

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            setState(() {
              _uploadStatus =
                  'Uploading: ${(progress * 100).toStringAsFixed(2)}%';
            });
          });

          await uploadTask;

          final downloadUrl = await storageRef.getDownloadURL();
          setState(() {
            _uploadStatus = 'Upload Complete!';
          });
        }
      } else {
        setState(() {
          _uploadStatus = 'File upload canceled.';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error during upload: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'This section allows you to upload and update the Terms and Conditions document for the platform. '
              'The uploaded file will replace the existing version currently displayed on the website. '
              'Please ensure the document is accurate and complete before uploading, as it will be visible to all users. '
              'Only .docx files are supported for upload due to compatibility with the text processing library used by the system.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () =>
                  _launchURL('https://arfaph.vercel.app/terms-and-conditions'),
              child: const Text(
                'View Terms and Conditions',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 10),
            if (_isUploading)
              CircularProgressIndicator()
            else
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: confirmAndUpload,
                  icon: Icon(Icons.upload),
                  label: Text('Upload File'),
                ),
              ),
            if (_uploadStatus != null)
              Text(
                _uploadStatus!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
