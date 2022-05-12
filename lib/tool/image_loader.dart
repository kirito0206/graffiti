import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ImageLoader {
  ImageLoader._(); //私有化构造
  static final ImageLoader loader = ImageLoader._(); //单例模式

  ///通过文件路径读取Image
  Future<ui.Image> loadImageByFilePath(
    String path, {
    int? width,
    int? height,
  }) async {
    return await loadImageByFile(File(path), width: width, height: height);
  }

  ///通过文件读取Image
  Future<ui.Image> loadImageByFile(
    File file, {
    int? width,
    int? height,
  }) async {
    var list = await file.readAsBytes();
    return loadImageByUint8List(list, width: width, height: height);
  }

  ///通过[Uint8List]获取图片
  Future<ui.Image> loadImageByUint8List(
    Uint8List list, {
    int? width,
    int? height,
  }) async {
    ui.Codec codec = await ui.instantiateImageCodec(list,
        targetWidth: width, targetHeight: height);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  ///通过[ui.Image]获取图片
  Future<Uint8List?> loadUint8ListByImage(ui.Image image) async {
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
