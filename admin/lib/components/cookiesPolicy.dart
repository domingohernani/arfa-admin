import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class CookiesPoliciesUploader extends StatefulWidget {
  @override
  _CookiesPoliciesUploaderState createState() =>
      _CookiesPoliciesUploaderState();
}

class _CookiesPoliciesUploaderState extends State<CookiesPoliciesUploader> {
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
            'Are you sure you want to update the cookies policies? '
            'This action will replace the \n existing file and update the cookies policies displayed on the website.',
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
              .child('platform/cookiepolicy/$fileName');

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cookies Policies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'You can upload and update the Cookies Poliies for the platform here. '
              'Once uploaded, this document will replace the current version displayed on the website. '
              'Please ensure the content is accurate and finalized, as it will be accessible to all users. '
              'Currently, only .docx files are supported due to the platform’s compatibility with the text processing system.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () =>
                  _launchURL('https://arfaph.vercel.app/cookies-policy'),
              child: const Text(
                'View Cookies Policies',
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
