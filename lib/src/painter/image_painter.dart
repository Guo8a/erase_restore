import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImagePainter extends CustomPainter {
  final ui.Image image;
  final BlendMode blendMode;

  ImagePainter({
    required this.image,
    this.blendMode = BlendMode.srcOver,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(
      image,
      Offset.zero,
      Paint()
        ..filterQuality = FilterQuality.high
        ..blendMode = blendMode,
    );
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) => true;
}

// class ColorPainter extends CustomPainter {
//   final Color color;
//   final BlendMode blendMode;

//   ColorPainter({
//     required this.color,
//     this.blendMode = BlendMode.srcOver,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawRect(
//       Offset.zero & size,
//       Paint()
//         ..color = color
//         ..blendMode = blendMode,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant ColorPainter oldDelegate) =>
//       color != oldDelegate.color || blendMode != oldDelegate.blendMode;
// }
