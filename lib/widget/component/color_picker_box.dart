import 'package:flutter/material.dart';
import 'package:graffiti/builder/abstract_builder.dart';

class ColorPickerBoxGroup extends StatefulWidget {
  final AbstractBuilder abstractBuilder;

  const ColorPickerBoxGroup({Key? key, required this.abstractBuilder})
      : super(key: key);

  @override
  State<ColorPickerBoxGroup> createState() => _ColorPickerBoxGroupState();
}

class _ColorPickerBoxGroupState extends State<ColorPickerBoxGroup> {
  final _colorArray = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.black
  ];
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.abstractBuilder.getColor();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Row(
            children: [
              for (var value in _colorArray)
                InkWell(
                  onTap: () => _updateColor(value),
                  child: _ColorPickerBox(
                      color: value,
                      isSelected: value.value == _selectedColor!.value),
                )
            ],
          ),
        )),
        IconButton(
            onPressed: () => widget.abstractBuilder.undo(),
            icon: const Icon(Icons.undo_outlined, color: Colors.white))
      ],
    );
  }

  void _updateColor(Color color) {
    setState(() {
      _selectedColor = color;
      widget.abstractBuilder.setColor(color);
    });
  }
}

class _ColorPickerBox extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ColorPickerBox(
      {Key? key, required this.color, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 24,
        width: 24,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(
              width: isSelected ? 3 : 1,
              color: Colors.white,
            )));
  }
}
