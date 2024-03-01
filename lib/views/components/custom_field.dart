import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.controller,
    this.iconData,
    required this.hint,
    required this.validator,
    required this.onChanged,
    this.keyboard,
    this.lines,
  });

  final TextEditingController controller;
  final IconData? iconData;
  final String hint;
  final String? Function(String?) validator;
  final void Function(String?) onChanged;
  final TextInputType? keyboard;
  final int? lines;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: keyboard ?? TextInputType.name,
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            size: 30,
            color: cs.primary,
          ),
          hintText: hint,
          hintStyle: tt.titleLarge!.copyWith(color: cs.onBackground.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: tt.titleLarge!.copyWith(color: cs.onBackground),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
