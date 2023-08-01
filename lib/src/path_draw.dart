import 'package:flutter/material.dart';

import 'models.dart';

class PathDraw {
  static void paint({
    required List<EraseRestoreLinePath> canvasPaths,
    required Canvas canvas,
    required Color paintColor,
    required bool isMask,
    required bool isRestore,
  }) {
    for (var canvasPath in canvasPaths) {
      if (canvasPath.drawPoints.isNotEmpty) {
        var paint = Paint()
          ..strokeWidth = canvasPath.strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..blendMode = BlendMode.src;
        if (isMask) {
          if (canvasPath.type == EditType.erase) {
            paint.color = Colors.transparent;
          } else {
            paint.color = paintColor;
          }
        } else {
          if ((canvasPath.type == EditType.restore && !isRestore) ||
              (canvasPath.type == EditType.erase && isRestore)) {
            paint.color = Colors.transparent;
          } else {
            paint.color = Colors.black;
          }
        }
        for (int i = 0; i < canvasPath.drawPoints.length; i++) {
          Offset drawPoint = canvasPath.drawPoints[i];
          if (canvasPath.drawPoints.length > 1) {
            if (i == 0) {
              canvas.drawLine(drawPoint, drawPoint, paint);
            } else {
              canvas.drawLine(canvasPath.drawPoints[i - 1], drawPoint, paint);
            }
          } else {
            canvas.drawLine(drawPoint, drawPoint, paint);
          }
        }
      }
    }
  }
}
