import 'dart:io';

import 'package:flutter/material.dart';
import 'package:san_favourite_places/widgets/image_field.dart';

class ImageFormField extends StatelessWidget {
  const ImageFormField({this.onSaved, this.validator, this.initialValue, super.key});
  final void Function(File?)? onSaved;
  final String? Function(File?)? validator;
  final File? initialValue;
  @override
  Widget build(BuildContext context) {
    return FormField<File>(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      builder: (field) {
        return ImageFieldWidget(
          initialValue: initialValue,
          onImageSelection: (file) => field.didChange(file),
          hasError: field.hasError,
          errorMsg: field.errorText,
        );
      },
    );
  }
}
