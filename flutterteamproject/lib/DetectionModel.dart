import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:flutter_pytorch/pigeon.dart';

enum ModelType {
  objectDetection,
  imageClassification,
}

class DetectionModel {
  late ModelObjectDetection _objectDetectionModel;
  late ClassificationModel _imageClassificationModel;
  late ModelType _modelType;

  Future<void> loadModel(
      String modelPath,
      int inputSize1,
      int inputSize2,
      String labelPath, {
        int? nc, //옵셔널 타입으로 객체감지인지 이미지 분류인지 구분
      }) async {
    if (nc != null) {
      _modelType = ModelType.objectDetection;
      _objectDetectionModel =
      await FlutterPytorch.loadObjectDetectionModel(
        modelPath,
        nc,
        inputSize1,
        inputSize2,
        labelPath: labelPath,
      );
    } else {
      _modelType = ModelType.imageClassification;
      _imageClassificationModel =
      await FlutterPytorch.loadClassificationModel(
        modelPath,
        inputSize1,
        inputSize2,
        labelPath: labelPath,
      );
    }
  }

  Future<List<ResultObjectDetection?>> detectObjects(
      List<int> imageBytes) async {
    if (_modelType != ModelType.objectDetection) {
      throw Exception("This model type is not for object detection.");
    }
    final objDetect = await _objectDetectionModel.getImagePrediction(
      imageBytes,
      minimumScore: 0.1,
      IOUThershold: 0.3,
    );
    return objDetect;
  }

  Future<String> classifyImage(List<int> imageBytes) async {
    if (_modelType != ModelType.imageClassification) {
      throw Exception("This model type is not for image classification.");
    }
    final prediction =
    await _imageClassificationModel.getImagePrediction(imageBytes);
    return prediction;
  }
}
