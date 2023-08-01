import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'image_processor.dart';

enum EditType {
  erase,
  restore,
}

class EraseRestoreLinePath {
  final List<Offset> drawPoints;
  final EditType type;
  final double strokeWidth;

  EraseRestoreLinePath({
    required this.drawPoints,
    this.type = EditType.erase,
    this.strokeWidth = 20,
  });
}

class EraseRestoreModel {
  // 裁剪图
  final ui.Image clipImage;
  // 原图
  final ui.Image originalImage;
  // 背景图
  final ui.Image bgImage;
  // 遮罩图
  final ui.Image maskImage;

  EraseRestoreModel({
    // required this.clipImageBytes,
    required this.clipImage,
    // required this.origImageBytes,
    required this.originalImage,
    // required this.bgImageBytes,
    required this.bgImage,
    // required this.maskImageBytes,
    required this.maskImage,
  });

  static Future<ImageData?> getMaskImageData(Uint8List imageBytes) async {
    final maskImageData = await ImageProcessor.getImageProcessByRGBA(
      imageBytes: imageBytes,
      color: Colors.white,
    );
    return maskImageData;
  }
}

class ImageData {
  final ui.Image image;
  final Uint8List imageBytes;
  final double width;
  final double height;

  ImageData({
    required this.image,
    required this.imageBytes,
    required this.width,
    required this.height,
  });
}

extension ListNull<E> on List<E> {
  E? get lastOrNull => length > 0 ? last : null;
}
