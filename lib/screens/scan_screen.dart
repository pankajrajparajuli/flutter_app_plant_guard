import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      Navigator.pushNamed(context, '/diagnosis', arguments: image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analyzing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Analyzing your plant\'s health. This may take a few seconds...'),
            LinearProgressIndicator(value: 0.75),
            Text('Process: 3/4'),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.camera_alt), Text('Take Photo')]),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.photo), Text('Choose from Gallery')]),
            ),
          ],
        ),
      ),
    );
  }
}