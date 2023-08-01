import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'erase_restore_controller.dart';
import 'erase_restore_data_provider.dart';
import 'models.dart';
import 'paint/image_erase_paint.dart';
import 'paint/image_mask_paint.dart';
import 'paint/image_paint.dart';
import 'paint/image_restore_paint.dart';
import 'path_draw.dart';

class EraseRestoreView extends StatelessWidget {
  final EraseRestoreModel model;
  final EraseRestoreController controller;
  final Color maskColor;
  final void Function(bool enable)? previousStepEnable;
  final void Function(bool enable)? nextStepEnable;

  const EraseRestoreView({
    Key? key,
    required this.model,
    required this.controller,
    required this.maskColor,
    this.previousStepEnable,
    this.nextStepEnable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EraseRestoreDataProvider(
      previousStepEnable: previousStepEnable,
      nextStepEnable: nextStepEnable,
      child: EraseRestoreInheritedView(
        model: model,
        controller: controller,
        maskColor: maskColor,
      ),
    );
  }
}

class EraseRestoreInheritedView extends StatefulWidget {
  final EraseRestoreModel model;
  final EraseRestoreController controller;
  final Color maskColor;

  const EraseRestoreInheritedView({
    Key? key,
    required this.model,
    required this.controller,
    required this.maskColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => EraseRestoreInheritedViewState();
}

class EraseRestoreInheritedViewState extends State<EraseRestoreInheritedView> {
  EraseRestoreModel get model => widget.model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.eraseRestoreViewState = this;
  }

  void switchEditType(EditType editType) {
    final provider = _getProvider();
    provider?.updateEditType(editType);
  }

  void previousStep() {
    final provider = _getProvider();
    provider?.previousStep();
  }

  void nextStep() {
    final provider = _getProvider();
    provider?.nextStep();
  }

  void updateStokeWidth(double width) {
    final provider = _getProvider();
    provider?.updateStokeWidth(width);
  }

  Future<ui.Image> takeScreenShot() async {
    final eraseRestoreData = EraseRestoreData.of(context);
    List<EraseRestoreLinePath> pathList = eraseRestoreData.lineList;
    final recoder = ui.PictureRecorder();
    final canvas = Canvas(recoder);

    final width = model.originalImage.width;
    final height = model.originalImage.height;
    final pathRestoreImage = await _paintPath(
      pathList,
      width,
      height,
      isRestore: true,
    );
    final pathImage = await _paintPath(
      pathList,
      width,
      height,
      isRestore: false,
    );

    canvas.saveLayer(
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), Paint());
    canvas.drawImage(model.originalImage, Offset.zero, Paint());
    canvas.drawImage(
        pathRestoreImage, Offset.zero, Paint()..blendMode = BlendMode.dstIn);
    canvas.restore();

    canvas.saveLayer(
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), Paint());
    canvas.drawImage(model.clipImage, Offset.zero, Paint());
    canvas.drawImage(
        pathImage, Offset.zero, Paint()..blendMode = BlendMode.dstOut);
    canvas.restore();

    final picture = recoder.endRecording();
    return picture.toImage(width, height);
  }

  Future<ui.Image> _paintPath(
    List<EraseRestoreLinePath> pathList,
    int width,
    int height, {
    required bool isRestore,
  }) async {
    final recoder = ui.PictureRecorder();
    final canvas = Canvas(recoder);

    PathDraw.paint(
      canvasPaths: pathList,
      canvas: canvas,
      paintColor: Colors.black,
      isMask: false,
      isRestore: isRestore,
    );

    final picture = recoder.endRecording();
    return picture.toImage(width, height);
  }

  EraseRestoreDataProviderState? _getProvider() {
    final eraseRestoreProvider = EraseRestoreDataProvider.of(context);
    if (eraseRestoreProvider is EraseRestoreDataProviderState) {
      return eraseRestoreProvider;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final eraseRestoreData = EraseRestoreData.of(context);
    return FittedBox(
      child: SizedBox(
        width: model.originalImage.width.toDouble(),
        height: model.originalImage.height.toDouble(),
        child: GestureDetector(
          onPanStart: (details) {
            final provider = _getProvider();
            provider?.startEdit(details.localPosition);
          },
          onPanUpdate: (details) {
            final provider = _getProvider();
            provider?.updateEdit(details.localPosition);
          },
          onPanEnd: (details) {
            final provider = _getProvider();
            provider?.endEdit();
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ImagePaint(
                    image: model.bgImage,
                  ),
                ),
                BackdropFilter(
                  filter: ui.ImageFilter.blur(),
                  blendMode: BlendMode.srcATop,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned.fill(
                        child: ImagePaint(
                          image: model.originalImage,
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(),
                          blendMode: BlendMode.dstIn,
                          child: ImageRestorePaint(
                            canvasPaths: eraseRestoreData.lineList,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BackdropFilter(
                  filter: ui.ImageFilter.blur(),
                  blendMode: BlendMode.srcATop,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned.fill(
                        child: ImagePaint(
                          image: model.clipImage,
                        ),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(),
                          blendMode: BlendMode.dstOut,
                          child: ImageErasePaint(
                            canvasPaths: eraseRestoreData.lineList,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (eraseRestoreData.editType == EditType.restore)
                  Positioned.fill(
                    child: ImagePaint(
                      image: model.originalImage,
                    ),
                  ),
                if (eraseRestoreData.editType == EditType.restore)
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(),
                    blendMode: BlendMode.srcATop,
                    child: ImageMaskPaint(
                      backgroundColor: widget.maskColor,
                      canvasPaths: eraseRestoreData.lineList,
                      image: model.maskImage,
                      //blendMode: BlendMode.dstIn,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
