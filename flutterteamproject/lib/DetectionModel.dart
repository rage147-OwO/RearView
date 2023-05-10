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
      String labelPath,
      ModelType modelType, {
        int? nc, // nc 파라미터 추가
      }) async {
    _modelType = modelType;
    switch (modelType) {
      case ModelType.objectDetection:
        _objectDetectionModel = await FlutterPytorch.loadObjectDetectionModel(
          modelPath,
          nc ?? 80,
          inputSize1,
          inputSize2,
          labelPath: labelPath,
        );
        break;
      case ModelType.imageClassification:
        _imageClassificationModel = await FlutterPytorch.loadClassificationModel(
          modelPath,
          inputSize1,
          inputSize2,
          labelPath: labelPath,
        );
        break;
    }
  }

  Future<List<ResultObjectDetection?>> detectObjects(List<int> imageBytes) async {
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
    final prediction = await _imageClassificationModel.getImagePrediction(imageBytes);
    return prediction;
  }
}
