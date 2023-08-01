import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'models.dart';

class ImageProcessor {
  static Future<ImageData?> getImageProcessByRGBA({
    required Uint8List imageBytes,
    required Color color,
  }) async {
    final decodedImage = await decodeImageFromList(imageBytes);
    final decodedImageByteData = await decodedImage.toByteData();
    if (decodedImageByteData == null) return null;
    final decodedBytes = decodedImageByteData.buffer.asUint8List();
    for (var i = 0; i < decodedBytes.length; i += 4) {
      var R = decodedBytes[i];
      var G = decodedBytes[i + 1];
      var B = decodedBytes[i + 2];
      var A = decodedBytes[i + 3];
      if (R == G && R == B && R == A && R == 0) {
        continue;
      }
      decodedBytes[i] = color.red;
      decodedBytes[i + 1] = color.green;
      decodedBytes[i + 2] = color.blue;
      decodedBytes[i + 3] = color.alpha;
    }
    return createImage(
      imageBytes: decodedBytes,
      width: decodedImage.width,
      height: decodedImage.height,
    );
  }

  static Future<ImageData> createImage({
    required Uint8List imageBytes,
    required int width,
    required int height,
  }) {
    final completer = Completer<ImageData>();
    ui.decodeImageFromPixels(
      imageBytes,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (result) async {
        final pngBytes =
            await result.toByteData(format: ui.ImageByteFormat.png);
        Uint8List? imageResultDataList =
            pngBytes == null ? null : Uint8List.view(pngBytes.buffer);
        if (imageResultDataList == null) return;
        completer.complete(
          ImageData(
            image: result,
            imageBytes: imageResultDataList,
            width: width.toDouble(),
            height: height.toDouble(),
          ),
        );
      },
    );
    return completer.future;
  }
}
