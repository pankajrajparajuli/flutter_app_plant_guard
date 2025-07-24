import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plant Guard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A healthy plant brings joy\nWe help you identify and cure plant diseases.', textAlign: TextAlign.center),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/scan'),
              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.camera_alt), Text('Scan Plant')]),
            ),
            Text('How to scan a plant?', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Step 1: Take a photo of the whole plant\nStep 2: Crop the image to focus on the diseased...\nStep 3: Get results in seconds'),
            Text('Quick Tips', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [Icon(Icons.water_drop), Text('Watering')]),
                Column(children: [Icon(Icons.lightbulb), Text('Lighting')]),
                Column(children: [Icon(Icons.opacity), Text('Humid')]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}