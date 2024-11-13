import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextInputType? keyBoredType;
  final double? fontSize;
  final String? fontFamily;
  final bool? obscureText;
  final TextEditingController? textFieldController;
  final String? errorText;
  final void Function(String)? onChanged;
  const CustomTextField(
      {super.key,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.maxLength,
      this.keyBoredType,
      this.fontSize,
      this.fontFamily,
      this.obscureText,
      this.textFieldController,
      this.errorText,
      this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 10),
      child: SizedBox(
          width: double.infinity,
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              errorText: errorText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              hintText: hintText,
              hintStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              labelText: labelText,
              labelStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
            obscureText: obscureText ?? false,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
            ),
            keyboardType: keyBoredType,
            maxLength: maxLength,
            controller: textFieldController,
          )),
    );
  }
}
