import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Guard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'A healthy plant brings joy\nWe help you identify and cure plant diseases.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/scan'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 8),
                    Text('Scan Plant'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'How to scan a plant?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Step 1: Take a photo of the whole plant\n'
                'Step 2: Crop the image to focus on the diseased part\n'
                'Step 3: Get results in seconds',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Tips',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Column(
                    children: [
                      Icon(Icons.water_drop, size: 32),
                      SizedBox(height: 4),
                      Text('Watering'),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.lightbulb, size: 32),
                      SizedBox(height: 4),
                      Text('Lighting'),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.opacity, size: 32),
                      SizedBox(height: 4),
                      Text('Humidity'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
