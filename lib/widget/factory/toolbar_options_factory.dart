import 'package:flutter/cupertino.dart';
import 'package:graffiti/builder/abstract_builder.dart';
import 'package:graffiti/widget/component/color_picker_box.dart';

/// 工具栏子view 简单工厂
class ToolbarOptionsFactory {
  /// index 说明
  /// 0 颜色
  /// 1 粗细
  /// 2 文字
  static Widget getToolbarOptionsView(
      int index, AbstractBuilder abstractBuilder) {
    switch (index) {
      case 0:
        return ColorPickerBoxGroup(abstractBuilder: abstractBuilder);
      case 1:
        return Row();
      case 2:
        return Row();
      default:
        return const SizedBox();
    }
  }
}
