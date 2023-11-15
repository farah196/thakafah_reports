import 'package:flutter/material.dart';


class SharedButton extends StatelessWidget {
  final String buttonLabel;
  final Function onClick;
  const SharedButton({
    super.key,
    required this.buttonLabel,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        onClick();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Adjust the value as needed
        ),
       // padding: const EdgeInsets.symmetric(horizontal: 24.0),
        elevation: 3,
        primary: theme.primaryColorLight, // Background color of the button
      ),
      child: Text(
        buttonLabel,
        style: const TextStyle(
          fontSize: 15.0,
          fontFamily: "Tajawal",
          color: Colors.white,
        ),
      ),
    );
  }
}
