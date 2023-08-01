import 'package:erase_restore/erase_restore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EraseRestoreScreen(),
    );
  }
}

class EraseRestoreScreen extends StatefulWidget {
  const EraseRestoreScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EraseRestoreScreenState();
}

class _EraseRestoreScreenState extends State<EraseRestoreScreen> {
  final EraseRestoreController controller = EraseRestoreController();
  double stokeWidth = 20;

  bool _previousStepEnable = false;
  bool _nextStepEnable = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Container(
            height: 400,
            color: Colors.red,
            child: FutureBuilder<EraseRestoreModel?>(
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
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.switchEditType(EditType.erase);
            },
            child: const Text('Erase'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.switchEditType(EditType.restore);
            },
            child: const Text('Restore'),
          ),
          ElevatedButton(
            onPressed: _previousStepEnable
                ? () {
                    controller.previousStep();
                  }
                : null,
            child: const Text('Previous Step'),
          ),
          ElevatedButton(
            onPressed: _nextStepEnable
                ? () {
                    controller.nextStep();
                  }
                : null,
            child: const Text('Next Step'),
          ),
          ElevatedButton(
            onPressed: () {
              stokeWidth += 1;
              controller.updateStokeWidth(stokeWidth);
            },
            child: const Text('Stoke width +1'),
          ),
          ElevatedButton(
            onPressed: () {
              if (stokeWidth <= 0) return;
              stokeWidth -= 1;
              controller.updateStokeWidth(stokeWidth);
            },
            child: const Text('Stoke width -1'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigatorState = Navigator.of(context);
              final result = await controller.takeScreenShot();
              if (result == null) return;
              navigatorState.push(
                MaterialPageRoute<void>(
                  builder: (BuildContext ctx) => Container(
                    color: Colors.white,
                    child: Center(
                      child: RawImage(
                        image: result,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Take Screenshot'),
          ),
        ],
      ),
    );
  }
}
