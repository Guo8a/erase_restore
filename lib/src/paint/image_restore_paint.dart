import 'package:flutter/material.dart';

import '../models.dart';
import '../painter/image_path_painter.dart';

class ImageRestorePaint extends StatelessWidget {
  final List<EraseRestoreLinePath> canvasPaths;

  const ImageRestorePaint({
    Key? key,
    required this.canvasPaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      isComplex: true,
      willChange: true,
      painter: ImagePathPainter(
        canvasPaths: canvasPaths,
        isRestore: true,
      ),
    );
  }
}
