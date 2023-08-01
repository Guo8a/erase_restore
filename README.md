# Erase Restore

erase_restore is a Flutter package that provides a simple and customizable way to implement eraser and undo/redo functionality for images. With this package, you can easily add an image eraser tool to your Flutter app, allowing users to erase parts of an image with their finger or a stylus. In addition, the package also provides undo and redo functionality, allowing users to undo or redo their eraser strokes as needed.

[![pub package](https://img.shields.io/pub/v/erase_restore?logo=dart&label=stable&style=flat-square)](https://pub.dev/packages/erase_restore)
[![GitHub stars](https://img.shields.io/github/stars/Apach3Q/erase_restore?logo=github&style=flat-square)](https://github.com/Apach3Q/erase_restore/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Apach3Q/erase_restore?logo=github&style=flat-square)](https://github.com/Apach3Q/erase_restore/network/members)

---
For a more throughout example see the example.

[video](https://github.com/Apach3Q/erase_restore/assets/21135761/7b20ccaa-a549-4e0c-972e-f20a44e4e84d)

---
## How to Use

### Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  erase_restore: <latest_version>
```

In your library add the following import:

```dart
import 'package:erase_restore/erase_restore.dart';
```

For help getting started with Flutter, view the online [documentation](https://docs.flutter.dev/).


### Initialize a `EraseRestoreView`

```dart
import 'package:erase_restore/erase_restore.dart';

final EraseRestoreController controller = EraseRestoreController();

Future<EraseRestoreModel?> _getModel() async {
    final bgBuffer = await rootBundle.load('assets/bg.png');
    final bgImage = await decodeImageFromList(bgBuffer.buffer.asUint8List());

    final originalBuffer = await rootBundle.load('assets/original.png');
    final originalImage =
        await decodeImageFromList(originalBuffer.buffer.asUint8List());

    final clipBuffer = await rootBundle.load('assets/clip.png');
    final clipImage =
        await decodeImageFromList(clipBuffer.buffer.asUint8List());

    final maskImageData = await EraseRestoreModel.getMaskImageData(
        clipBuffer.buffer.asUint8List());
    if (maskImageData == null) return null;
    return EraseRestoreModel(
      clipImage: clipImage,
      originalImage: originalImage,
      bgImage: bgImage,
      maskImage: maskImageData.image,
    );
}

FutureBuilder<EraseRestoreModel?>(
    future: _getModel(),
    builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final data = snapshot.data;
        if (data == null) return const SizedBox.shrink();
        return EraseRestoreView(
            model: data,
            controller: controller,
            maskColor: const Color.fromARGB(74, 248, 13, 35),
            previousStepEnable: (enable) {
                setState(() {
                    _previousStepEnable = enable;
                });
            },
            nextStepEnable: (enable) {
                setState(() {
                    _nextStepEnable = enable;
                });
            },
        );
    },
)
```

### All operations


```dart
void switchEditType(EditType editType)
```

```dart
void previousStep()
```
```dart
void nextStep()
```
```dart
void updateStokeWidth(double width)
```
```dart
Future<ui.Image?> takeScreenShot()
```

---

## Sponsoring

I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.

---
## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/Apach3Q/erase_restore/issues).  
If you fixed a bug or implemented a feature, please send a [pull request](https://github.com/Apach3Q/erase_restore/pulls).
