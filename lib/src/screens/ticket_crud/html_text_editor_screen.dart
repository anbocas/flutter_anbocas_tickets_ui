import 'package:anbocas_tickets_ui/src/anbocas_flutter_ticket_booking.dart';
import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class HtmlTextEditorScreen extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;
  const HtmlTextEditorScreen(
      {super.key, required this.initialText, required this.onSave});

  @override
  State<HtmlTextEditorScreen> createState() => _HtmlTextEditorScreenState();
}

class _HtmlTextEditorScreenState extends State<HtmlTextEditorScreen> {
  ///[controller] create a QuillEditorController to access the editor methods
  late QuillEditorController controller;

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = theme.backgroundColor?.withOpacity(0.5);
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = theme.iconColor;
  final _editorTextStyle = const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);

  bool _hasFocus = false;

  @override
  void initState() {
    setInitialControllerState();
    super.initState();
  }

  void setInitialControllerState() {
    controller = QuillEditorController();
    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            ToolBar(
              toolBarColor: _toolbarColor,
              padding: const EdgeInsets.all(8),
              iconSize: 25,
              iconColor: _toolbarIconColor,
              activeIconColor: Colors.greenAccent.shade400,
              controller: controller,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              customButtons: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: _hasFocus ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(15)),
                ),
                InkWell(
                    onTap: () => unFocusEditor(),
                    child: Icon(Icons.favorite, color: theme.iconColor)),
              ],
            ),
            Expanded(
              child: QuillHtmlEditor(
                hintText: 'Type Here...',
                controller: controller,
                isEnabled: true,
                ensureVisible: false,
                minHeight: 500,
                autoFocus: false,
                textStyle: _editorTextStyle,
                hintTextStyle: _hintTextStyle,
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 10, top: 10),
                hintTextPadding: const EdgeInsets.only(left: 20),
                backgroundColor: _backgroundColor,
                inputAction: InputAction.newline,
                onEditingComplete: (s) => debugPrint('Editing completed $s'),
                loadingBuilder: (context) {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.red,
                  ));
                },
                onFocusChanged: (focus) {
                  debugPrint('has focus $focus');
                  setState(() {
                    _hasFocus = focus;
                  });
                },
                onTextChanged: (text) => debugPrint('widget text change $text'),
                onEditorCreated: () {
                  setHtmlText(widget.initialText);
                },
                onEditorResized: (height) =>
                    debugPrint('Editor resized $height'),
                onSelectionChanged: (sel) =>
                    debugPrint('index ${sel.index}, range ${sel.length}'),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          width: double.maxFinite,
          color: _toolbarColor,
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              textButton(
                  text: 'Go Back',
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  icon: Icons.arrow_back),
              textButton(
                  text: 'Undo',
                  onPressed: () {
                    controller.undo();
                  },
                  icon: Icons.undo),
              textButton(
                  text: 'Redo',
                  onPressed: () {
                    controller.redo();
                  },
                  icon: Icons.redo),
              textButton(
                  text: 'Clear Editor',
                  onPressed: () async {
                    controller.clear();
                  },
                  icon: Icons.clear_all),
              textButton(
                  text: 'Save Data',
                  onPressed: () async {
                    final text = await controller.getText();
                    widget.onSave(text);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  icon: Icons.save),
            ],
          ),
        ),
      ),
    );
  }

  Widget textButton(
      {required String text,
      required IconData icon,
      required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: theme.secondaryIconColor,
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _toolbarIconColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                text,
                style: theme.bodyStyle?.copyWith(color: theme.primaryTextColor),
              ),
            ],
          )),
    );
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText);
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => controller.unFocus();
}
