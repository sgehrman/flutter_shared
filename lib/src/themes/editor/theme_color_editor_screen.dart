import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shared/src/themes/editor/theme_set.dart';
import 'package:flutter_shared/src/themes/editor/theme_set_manager.dart';
import 'package:flutter_shared/src/widgets/headers/browser_header.dart';
import 'package:flutter_shared/src/widgets/list_row.dart';
import 'package:flutter_shared/src/widgets/theme_button.dart';

class ThemeColorEditorScreen extends StatefulWidget {
  const ThemeColorEditorScreen({required this.themeSet, required this.field});

  final ThemeSet? themeSet;
  final ThemeSetColor field;

  @override
  _ThemeColorEditorScreenState createState() => _ThemeColorEditorScreenState();
}

class _ThemeColorEditorScreenState extends State<ThemeColorEditorScreen> {
  late HSVColor currentColor;
  ThemeSet? themeSet;

  @override
  void initState() {
    super.initState();

    themeSet = widget.themeSet;

    // color picker crashes if you send nil.  An invalid themeset might have null colors from bad scan etc.
    final Color color = themeSet!.colorForField(widget.field) ?? Colors.black;
    currentColor = HSVColor.fromColor(color);
  }

  void changeColorHsv(HSVColor hsvColor) {
    setState(() {
      currentColor = hsvColor;

      final Color color = hsvColor.toColor();
      themeSet = themeSet!.copyWithColor(widget.field, color);

      ThemeSetManager().currentTheme = themeSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(themeSet!.nameForField(widget.field))),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              HsvColorPicker(
                showLabel: false,
                pickerAreaBorderRadius:
                    const BorderRadius.all(Radius.circular(8)),
                enableAlpha: false,
                pickerColor: currentColor,
                onColorChanged: changeColorHsv,
              ),
              const SizedBox(height: 20),
              const BrowserHeader(
                'Example Header',
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListRow(
                  title: 'Example List item',
                  leading: Icon(Feather.folder),
                  subtitle: 'Subtitle example',
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListRow(
                  title: 'Example List item',
                  leading: Icon(Feather.folder),
                  subtitle: 'Subtitle example',
                ),
              ),
              const SizedBox(height: 10),
              ThemeButton(
                title: 'Sample Button',
                onPressed: () {
                  changeColorHsv(HSVColor.fromColor(themeSet!.primaryColor!));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
