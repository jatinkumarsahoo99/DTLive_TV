import 'package:flutter/material.dart';

class FocusBase extends StatefulWidget {
  final Function()? onPressed;
  final Function(bool) onFocus;
  final Widget child;
  final Color? focusColor;
  final FocusNode? focusNodeNew;

  const FocusBase({
    Key? key,
    required this.onPressed,
    required this.onFocus,
    required this.focusColor,
    required this.child,
    this.focusNodeNew
  }) : super(key: key);

  @override
  State<FocusBase> createState() => _FocusBaseState();
}

class _FocusBaseState extends State<FocusBase> {
  FocusNode? focusNode ;

  @override
  void initState() {
    focusNode = widget.focusNodeNew??FocusNode();
    super.initState();
    focusNode?.addListener(() {
      setState(() {
        widget.onFocus.call(focusNode!.hasFocus);
      });
    });
  }

  @override
  void dispose() {
    focusNode?.removeListener(() {});
    focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: focusNode!.hasFocus ? 1.0 : 0.95,
      child: RawMaterialButton(
        constraints: const BoxConstraints(minHeight: 0),
        onPressed: widget.onPressed,
        focusNode: focusNode,
        padding: EdgeInsets.all(focusNode!.hasFocus ? 2.0 : 0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        focusColor: widget.focusColor,
        child: widget.child,
      ),
    );
  }
}
