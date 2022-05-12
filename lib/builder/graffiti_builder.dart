import 'dart:typed_data';
import 'dart:ui';

import 'package:graffiti/builder/abstract_builder.dart';
import 'package:graffiti/painter/graffiti_board_painter.dart';
import 'package:graffiti/tool/image_loader.dart';

class GraffitiBuilder extends AbstractBuilder {

  late GraffitiBoardPainter graffitiBoardPainter;

  GraffitiBuilder({required this.graffitiBoardPainter});

  @override
  void setColor(Color color) {
    graffitiBoardPainter.mPaint = Paint();
    graffitiBoardPainter.mPaint.color = color;
  }

  @override
  void setWidth(double value) {
    graffitiBoardPainter.mPaint.strokeWidth = value;
  }

  @override
  Color getColor() {
    return graffitiBoardPainter.mPaint.color;
  }

  @override
  double getWidth() {
    return graffitiBoardPainter.mPaint.strokeWidth;
  }

  @override
  void undo() {
    graffitiBoardPainter.undo();
  }

  @override
  Future<Uint8List?> getResult() async{
    var resultImage = await graffitiBoardPainter.rendered;
    return ImageLoader.loader.loadUint8ListByImage(resultImage);
  }
}
