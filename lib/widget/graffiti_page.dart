import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:graffiti/builder/graffiti_builder.dart';
import 'package:graffiti/painter/graffiti_board_painter.dart';
import 'package:graffiti/tool/image_loader.dart';

import 'graffiti_toolbar.dart';

class GraffitiPage extends StatefulWidget {
  final String? filePath;
  final File? file;
  final Uint8List? list;
  final int? width;
  final int? height;

  const GraffitiPage(
      {Key? key, this.filePath, this.file, this.list, this.width, this.height})
      : super(key: key);

  @override
  State<GraffitiPage> createState() => _GraffitiPageState();
}

class _GraffitiPageState extends State<GraffitiPage> {
  GraffitiBoardPainter? _graffitiBoardPainter;
  GraffitiBuilder? _graffitiBuilder;
  Future<ui.Image>? image;

  @override
  void initState() {
    super.initState();
    if (widget.filePath != null) {
      image = ImageLoader.loader.loadImageByFilePath(widget.filePath!,
          width: widget.width, height: widget.height);
    } else if (widget.file != null) {
      image = ImageLoader.loader.loadImageByFile(widget.file!,
          width: widget.width, height: widget.height);
    } else if (widget.list != null) {
      image = ImageLoader.loader.loadImageByUint8List(widget.list!,
          width: widget.width, height: widget.height);
    } else {
      return;
    }

    image?.then((value) => setState(() {
          _graffitiBoardPainter = GraffitiBoardPainter(image: value, paintState: ValueNotifier(false));
          _graffitiBuilder =
              GraffitiBuilder(graffitiBoardPainter: _graffitiBoardPainter!);
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (_graffitiBuilder == null) {
      return const Center(
        child: Text('图片加载中...'),
      );
    }
    var winH = MediaQuery.of(context).size.height;
    var winW = MediaQuery.of(context).size.width;
    var paddingTop = MediaQuery.of(context).padding.top + kToolbarHeight;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            /// 画板
            Expanded(
              child: Listener(
                onPointerDown: (downEvent) {
                  _graffitiBoardPainter?.downEventCallback(
                      downEvent.position.dx, downEvent.position.dy - paddingTop);
                },
                onPointerUp: (upEvent) {
                  _graffitiBoardPainter?.upEventCallback(
                      upEvent.position.dx, upEvent.position.dy - paddingTop);
                },
                onPointerMove: (moveEvent) {
                  _graffitiBoardPainter?.moveEventCallback(
                      moveEvent.position.dx, moveEvent.position.dy - paddingTop);
                },
                child: CustomPaint(
                  size: Size(winW, winH),
                  painter: _graffitiBoardPainter,
                ),
              ),
            ),

            /// 底部工具栏
            GraffitiToolbar(graffitiBuilder: _graffitiBuilder!),
          ],
        ));
  }
}
