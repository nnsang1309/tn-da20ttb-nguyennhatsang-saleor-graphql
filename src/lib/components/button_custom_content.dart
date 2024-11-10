import 'package:flutter/material.dart';

class ButtonCustomContent extends StatefulWidget {
  const ButtonCustomContent({
    super.key,
    this.onTap,
    required this.child,
    this.color,
    this.radius,
  });
  final void Function()? onTap;
  final Widget child;
  final Color? color;
  final BorderRadius? radius;
  @override
  State<ButtonCustomContent> createState() => _ButtonCustomContentState();
}

class _ButtonCustomContentState extends State<ButtonCustomContent> {
  @override
  void didUpdateWidget(covariant ButtonCustomContent oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: widget.radius ?? BorderRadius.circular(12),
      color: widget.color ?? Colors.transparent,
      child: InkWell(
        borderRadius: widget.radius ?? BorderRadius.circular(12),
        onTap: widget.onTap,
        child: widget.child,
      ),
    );
  }
}
