import 'package:cinemabooking/config/theme.dart';
import 'package:flutter/material.dart';

class ReusablePasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool initiallyObscured;
  final Color? fillColor;
  final double borderRadius;

  const ReusablePasswordField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.initiallyObscured = true,
    this.fillColor,
    this.borderRadius = 12.0,
  });

  @override
  State<ReusablePasswordField> createState() => _ReusablePasswordFieldState();
}

class _ReusablePasswordFieldState extends State<ReusablePasswordField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initiallyObscured;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(color: AppTheme.textPrimary),
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: AppTheme.textGrey),
        prefixIcon: widget.prefixIcon,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.primary,
          ),
          onPressed: _toggleVisibility,
        ),
        filled: true,
        fillColor: widget.fillColor ?? AppTheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
    );
  }
}
