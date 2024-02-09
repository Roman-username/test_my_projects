import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../styles.dart';

class StepHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const StepHeader({required this.title, this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: kSignInStepTitleStyle),
        const SizedBox(height: 24),
        if (subtitle != null)
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: kSignInStepSubTitleStyle,
          )
      ],
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String label;
  final void Function(String) onChanged;
  final bool? showCursor;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;

  const LabeledTextField({
    required this.label,
    required this.onChanged,
    this.showCursor,
    this.inputFormatters,
    this.keyboardType,
    this.controller,
    this.focusNode,
    this.decoration,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kMainTextColor),
          ),
        ),
        const SizedBox(height: 2),
        TextFormField(
          validator: validator,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 17, color: kMainTextColor),
          showCursor: showCursor,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) => focusNode?.unfocus(),
          textAlignVertical: TextAlignVertical.bottom,
          decoration: decoration,
        ),
      ],
    );
  }
}
