import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final void Function()? onTap;
  const AppButton({required this.onTap, super.key});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isRunning = false;

  void _onClicked() {
    setState(() => _isRunning = true);

    if (widget.onTap != null) {
      widget.onTap!();
    }

    setState(() => _isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: _isRunning ? null : _onClicked,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
