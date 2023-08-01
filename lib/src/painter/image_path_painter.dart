import 'package:flutter/material.dart';

import '../models.dart';
import '../path_draw.dart';

class ImagePathPainter extends CustomPainter {
  final List<EraseRestoreLinePath> canvasPaths;
  final bool isRestore;

  ImagePathPainter({
    required this.canvasPaths,
    required this.isRestore,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    if (isRestore) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = Colors.transparent);
    }
    PathDraw.paint(
      canvasPaths: canvasPaths,
      canvas: canvas,
      paintColor: Colors.black,
      isMask: false,
      isRestore: isRestore,
      // drawLineCallback: (p1, p2, paint) {
      //   canvas.drawLine(p1, p2, paint);
      // },
    );
    // if (canvasPaths.isNotEmpty) {
    //   for (var canvasPath in canvasPaths) {
    //     if (canvasPath.drawPoints.isNotEmpty) {
    //       var paint = Paint()
    //         ..strokeWidth = canvasPath.strokeWidth
    //         ..style = PaintingStyle.stroke
    //         ..strokeCap = StrokeCap.round
    //         ..strokeJoin = StrokeJoin.round
    //         ..blendMode = BlendMode.src;

    //       if ((canvasPath.type == EditType.restore && !isRestore) ||
    //           (canvasPath.type == EditType.erase && isRestore)) {
    //         paint.color = Colors.transparent;
    //       } else {
    //         paint.color = Colors.black;
    //       }
    //       for (int i = 0; i < canvasPath.drawPoints.length; i++) {
    //         Offset drawPoint = canvasPath.drawPoints[i];
    //         if (canvasPath.drawPoints.length > 1) {
    //           if (i == 0) {
    //             canvas.drawLine(drawPoint, drawPoint, paint);
    //           } else {
    //             canvas.drawLine(canvasPath.drawPoints[i - 1], drawPoint, paint);
    //           }
    //         } else {
    //           canvas.drawLine(drawPoint, drawPoint, paint);
    //         }
    //       }
    //     }
    //   }
    // }
    //canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ImagePathPainter oldDelegate) =>
      isRestore != oldDelegate.isRestore ||
      canvasPaths.length != oldDelegate.canvasPaths.length ||
      canvasPaths.lastOrNull?.drawPoints.length !=
          oldDelegate.canvasPaths.lastOrNull?.drawPoints.length;
}
