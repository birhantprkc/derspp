import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:crop_image/crop_image.dart';

class ImageCropperScreen extends StatefulWidget {
  final Uint8List image;

  const ImageCropperScreen({super.key, required this.image});

  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  final controller = CropController(
    aspectRatio: null,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kırp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final bitmap = await controller.croppedBitmap();
              final data = await bitmap.toByteData(format: ImageByteFormat.png);
              if (data != null) {
                Navigator.pop(context, data.buffer.asUint8List());
              }
            },
          ),
        ],
      ),
      body: Center(
        child: CropImage(
          controller: controller,
          image: Image.memory(widget.image),
          gridColor: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.aspect_ratio),
              onPressed: () => controller.aspectRatio = null,
              tooltip: 'Serbest',
            ),
            IconButton(
              icon: const Icon(Icons.crop_square),
              onPressed: () => controller.aspectRatio = 1.0,
              tooltip: 'Kare',
            ),
            IconButton(
              icon: const Icon(Icons.rotate_left),
              onPressed: () => controller.rotation = CropRotation.up,
            ),
          ],
        ),
      ),
    );
  }
}
