import 'package:flutter/material.dart';
import 'package:graffiti/builder/abstract_builder.dart';
import 'factory/toolbar_options_factory.dart';

class GraffitiToolbar extends StatefulWidget {
  final AbstractBuilder graffitiBuilder;

  const GraffitiToolbar({Key? key, required this.graffitiBuilder})
      : super(key: key);

  @override
  State<GraffitiToolbar> createState() => _GraffitiToolbarState();
}

class _GraffitiToolbarState extends State<GraffitiToolbar> {
  int _index = 0;

  final _iconArray = [
    Icons.color_lens_outlined,
    Icons.adjust_outlined,
    Icons.title
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
                child: ToolbarOptionsFactory.getToolbarOptionsView(
                    _index, widget.graffitiBuilder)),
            Expanded(
                child: Row(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Row(
                    children: [
                      for (var i = 0; i < _iconArray.length; i++)
                        IconButton(
                            onPressed: () => _updateIndex(i),
                            icon: Icon(
                              _iconArray[i],
                              color: _index == i ? Colors.blue : Colors.white,
                            )),
                    ],
                  ),
                )),
                TextButton(
                  child: const Text('完成'),
                  onPressed: () => {
                    widget.graffitiBuilder.getResult().then((value) => Navigator.pop(context, value))
                  },
                )
              ],
            ))
          ],
        ));
  }

  void _updateIndex(int index) {
    setState(() {
      _index = index;
    });
  }
}
