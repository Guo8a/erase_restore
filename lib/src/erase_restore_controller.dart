import 'dart:ui' as ui;

import 'erase_restore_view.dart';
import 'models.dart';

class EraseRestoreController {
  EraseRestoreInheritedViewState? eraseRestoreViewState;

  void _check() {
    if (eraseRestoreViewState == null) throw 'eraseRestoreViewState is empty';
  }

  void switchEditType(EditType editType) {
    _check();
    eraseRestoreViewState?.switchEditType(editType);
  }

  void previousStep() {
    _check();
    eraseRestoreViewState?.previousStep();
  }

  void nextStep() {
    _check();
    eraseRestoreViewState?.nextStep();
  }

  void updateStokeWidth(double width) {
    _check();
    eraseRestoreViewState?.updateStokeWidth(width);
  }

  Future<ui.Image?> takeScreenShot() async {
    _check();
    return eraseRestoreViewState?.takeScreenShot();
  }
}
