import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../models.dart';
import '../path_draw.dart';

class ImageMaskPainter extends CustomPainter {
  final List<EraseRestoreLinePath>? canvasPaths;
  final ui.Image? image;

  ImageMaskPainter({
    this.canvasPaths,
    this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final hasPath = canvasPaths?.isNotEmpty ?? false;

    //canvas.save();
    if (image != null) {
      canvas.drawImage(
        image!,
        Offset.zero,
        Paint()..filterQuality = FilterQuality.high,
      );
    }
    if (hasPath) {
      PathDraw.paint(
        canvasPaths: canvasPaths!,
        canvas: canvas,
        paintColor: Colors.white,
        isMask: true,
        isRestore: true,
        //   drawLineCallback: (p1, p2, paint) {
        //     canvas.drawLine(p1, p2, paint);
        //   },
      );
      // for (var canvasPath in canvasPaths!) {
      //   if (canvasPath.drawPoints.isNotEmpty) {
      //     var paint = Paint()
      //       ..strokeWidth = canvasPath.strokeWidth
      //       ..style = PaintingStyle.stroke
      //       ..strokeCap = StrokeCap.round
      //       ..blendMode = BlendMode.src
      //       ..strokeJoin = StrokeJoin.round;
      //     if (canvasPath.type == EditType.erase) {
      //       paint.color = Colors.transparent;
      //     } else {
      //       paint.color = Colors.white;
      //     }
      //     for (int i = 0; i < canvasPath.drawPoints.length; i++) {
      //       Offset drawPoint = canvasPath.drawPoints[i];
      //       if (canvasPath.drawPoints.length > 1) {
      //         if (i == 0) {
      //           canvas.drawLine(drawPoint, drawPoint, paint);
      //         } else {
      //           canvas.drawLine(canvasPath.drawPoints[i - 1], drawPoint, paint);
      //         }
      //       } else {
      //         canvas.drawLine(drawPoint, drawPoint, paint);
      //       }
      //     }
      //   }
      // }
    }
    // canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ImageMaskPainter oldDelegate) =>
      image != oldDelegate.image ||
      canvasPaths?.length != oldDelegate.canvasPaths?.length ||
      canvasPaths?.lastOrNull?.drawPoints.length !=
          oldDelegate.canvasPaths?.lastOrNull?.drawPoints.length;
}
