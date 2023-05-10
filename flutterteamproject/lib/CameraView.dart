import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _controller = null; // _controller를 null로 초기화합니다.

    // 권한 요청
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final PermissionStatus permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      // 카메라 목록을 불러와서 사용 가능한 카메라를 찾습니다.
      final List<CameraDescription> cameras = await availableCameras();
      print('Available cameras: ${cameras.length}');
      setState(() {
        _cameras = cameras;
        _controller = CameraController(_cameras![0], ResolutionPreset.medium);
        _controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      });
    } else {
      // 권한이 거부된 경우 처리
      print('Camera permission is not granted.');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: _buildCameraPreview(),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return FutureBuilder<void>(
        future: _controller?.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }
    return CameraPreview(_controller!);
  }

}
