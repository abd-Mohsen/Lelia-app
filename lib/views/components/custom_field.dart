import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
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
          hintStyle: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 0.1, color: cs.onBackground.withOpacity(0.1)), // not changing
          ),
        ),
        style: tt.titleMedium!.copyWith(color: cs.onBackground),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

String? validateInput(String val, int min, int max, String type,
    {String pass = "", String rePass = "", bool canBeEmpty = false}) {
  if (val.trim().isEmpty && !canBeEmpty) return "لا يمكن أن يكون فارغ";

  if (type == "username") {
    if (!GetUtils.isUsername(val)) return "اسم المستخدم غير صالح";
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) return "ادخل بريد الكتروني صالح";
  }
  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) return "رقم الهاتف غير صالح";
  }
  if (val.length < min) return "الطول لا يمكن ان يكون أقصر من $min";

  if (val.length > max) return "الطول لا يمكن ان يكون أكبر من $max";

  if (pass != rePass) return "كلمتا المرور غير متطابقتان";

  return null;
}
