import 'package:flutter/material.dart';

import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class App3DViewer extends StatefulWidget {
  const App3DViewer({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.backgroundColor = Colors.black,
    this.autoPlay = true,
    this.loop = true,
    this.cameraControls = true,
    this.enablePan = true,
    this.enableZoom = true,
    this.enableRotate = true,
    this.onLoad,
  });

  /// 3D model path or URL. /// /// Example: /// assets/models/watch.glb /// https://example.com/model.glb
  final String src;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final bool autoPlay;
  final bool loop;
  final bool cameraControls;
  final bool enablePan;
  final bool enableZoom;
  final bool enableRotate;
  final VoidCallback? onLoad;

  @override
  State<App3DViewer> createState() => _App3DViewerState();
}

class _App3DViewerState extends State<App3DViewer> {
  final Flutter3DController controller = Flutter3DController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('=====================================================================');
  }

  void reset(){
    controller.resetAnimation();
    controller.resetCameraOrbit();
    controller.resetCameraTarget();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Flutter3DViewer(
              controller: controller,
              src: widget.src,
              onProgress: (value){
                print('========================> PROGRESS : $value');
              },
              activeGestureInterceptor: true,
              progressBarColor: Colors.red,
              onError: (value){
                print('ERROR AT 3D View Screen : $value');
              },
              onLoad: (_) {
                widget.onLoad?.call();
              },
            ),
          ),
        ),
        ElevatedButton(onPressed: reset, child: Icon(Icons.refresh)),
        SizedBox(height: 30,)
      ],
    );
  }
}
