import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GraffitiBoardPainter extends CustomPainter {
  final ui.Image image;
  late Paint mPaint;
  final _pathList = <ui.Path>[];
  final _paintList = <ui.Paint>[];
  ui.Path curPath = ui.Path();
  late double scaleNum;
  late ValueNotifier<bool> paintState;

  GraffitiBoardPainter({required this.image, required this.paintState})
      : super(repaint: paintState) {
    _init();
  }

  void _init() {
    mPaint = Paint();
    mPaint.color = Colors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _canvasScale(canvas, size);
    _drawImage(canvas, size);
    _drawAllLine(canvas);
    _drawCurLine(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  /// 等比例缩放
  void _canvasScale(Canvas canvas, Size size) {
    scaleNum = _getScaleNum(size);
    _size = size;
    canvas.scale(scaleNum, scaleNum);
  }

  /// 绘制图片
  void _drawImage(Canvas canvas, Size size) {
    var xOffset = (size.width / scaleNum - image.width) / 2;
    var yOffset = (size.height / scaleNum - image.height) / 2;
    canvas.drawImage(image, Offset(xOffset, yOffset), mPaint);
  }

  /// 绘制记录线条
  void _drawAllLine(Canvas canvas) {
    mPaint.strokeWidth = 5 / scaleNum;
    mPaint.style = PaintingStyle.stroke;
    for (var i = 0; i < _pathList.length; i++) {
      canvas.drawPath(_pathList[i], _paintList[i]);
    }
  }

  /// 绘制当前线条
  void _drawCurLine(Canvas canvas) {
    mPaint.strokeWidth = 5 / scaleNum;
    mPaint.style = PaintingStyle.stroke;
    canvas.drawPath(curPath, mPaint);
  }

  /// 获取缩放比例
  double _getScaleNum(Size size) {
    var xScaleNum = size.width * 1.0 / image.width;
    var yScaleNum = size.height * 1.0 / image.height;
    return xScaleNum < yScaleNum ? xScaleNum : yScaleNum;
  }

  /// 滑动开始回调
  void downEventCallback(double x, double y) {
    x = x / scaleNum;
    y = y / scaleNum;
    curPath.moveTo(x, y);
    curPath.lineTo(x, y);
    paintState.value = !paintState.value;
  }

  /// 滑动中回调
  void moveEventCallback(double x, double y) {
    x = x / scaleNum;
    y = y / scaleNum;
    curPath.lineTo(x, y);
    paintState.value = !paintState.value;
  }

  /// 滑动结束回调
  void upEventCallback(double x, double y) {
    x = x / scaleNum;
    y = y / scaleNum;
    _pathList.add(curPath);
    _paintList.add(mPaint);
    curPath = ui.Path();
    paintState.value = !paintState.value;
  }

  /// 回滚
  void undo() {
    if (_pathList.isNotEmpty) {
      _pathList.removeLast();
      _paintList.removeLast();
      paintState.value = !paintState.value;
    }
  }

  /// 获取图片
  late ui.Size _size;

  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    _drawImage(canvas, _size);
    _drawAllLine(canvas);
    return recorder.endRecording().toImage(
        (_size.width / scaleNum).floor(), (_size.height / scaleNum).floor());
  }
}
