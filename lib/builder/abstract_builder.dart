
import 'dart:typed_data';

import 'package:flutter/rendering.dart';

abstract class AbstractBuilder {

  CustomPainter? customPainter;

  /// 设置画笔颜色
  void setColor(Color color);

  /// 设置画笔粗细
  void setWidth(double value);

  /// 获取画笔颜色
  Color getColor();

  /// 获取画笔粗细
  double getWidth();

  /// 操作回滚
  void undo();

  /// 获取涂鸦后的图片
  Future<Uint8List?> getResult();
}
