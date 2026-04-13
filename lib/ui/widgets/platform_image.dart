import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart' as io;

class PlatformImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final double? width;
  final double? height;

  const PlatformImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (path.startsWith('data:image')) {
        final base64String = path.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          fit: fit,
          errorBuilder: errorBuilder,
          width: width,
          height: height,
        );
      }
      if (path.startsWith('http')) {
        return Image.network(
          path,
          fit: fit,
          errorBuilder: errorBuilder,
          width: width,
          height: height,
        );
      }
      return Container(
        width: width,
        height: height,
        color: Colors.grey,
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Image.file(
      io.File(path),
      fit: fit,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
    );
  }
}
