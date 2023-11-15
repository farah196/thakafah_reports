import 'package:flutter/material.dart';

class SharedEditText extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final Icon? icon;
  final double? fontSize;
  final bool? isObscureText;
  final Function? onChange;
  final Function? onSubmit;
  final FocusNode? focus;

  final int? line;

  final TextInputType? keyboardType;


  const SharedEditText({
    super.key,
    required this.textEditingController,
    required this.label,
    this.icon,
    this.fontSize,
    this.focus,
    this.isObscureText,
    this.onChange,
    this.onSubmit,
    this.line,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: TextField(
        controller: textEditingController,
        textAlign: TextAlign.right,
        cursorColor: theme.primaryColorLight,
        focusNode: focus,
        obscureText: isObscureText ?? false,
        style: theme.textTheme.titleMedium,
        maxLines: line == null ? 1 : line,
        keyboardType: keyboardType == null ? TextInputType.text : keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          icon: icon,
          iconColor: theme.primaryColorLight,
          hintStyle: theme.textTheme.bodyMedium,
        ),
        onChanged: (value) {
          if (onChange != null) {
            onChange!(value);
          }
        },
        onSubmitted: (value) {
          if (onSubmit != null) {
            onSubmit!(value);
          }
        },
      ),
    );
  }
}
