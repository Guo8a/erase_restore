import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../models.dart';
import '../painter/image_mask_painter.dart';

class ImageMaskPaint extends StatelessWidget {
  final List<EraseRestoreLinePath> canvasPaths;
  final ui.Image image;
  final Color backgroundColor;
  final Widget? child;

  const ImageMaskPaint({
    Key? key,
    required this.backgroundColor,
    required this.canvasPaths,
    required this.image,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: backgroundColor,
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(),
          blendMode: BlendMode.dstIn,
          child: CustomPaint(
            // isComplex: true,
            // willChange: true,
            painter: ImageMaskPainter(
              image: image,
              canvasPaths: canvasPaths,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
