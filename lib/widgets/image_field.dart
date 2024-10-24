import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFieldWidget extends StatefulWidget {
  const ImageFieldWidget({required this.onImageSelection, super.key});
  final void Function(File file) onImageSelection;
  @override
  State<ImageFieldWidget> createState() => _ImageFieldWidgetState();
}

class _ImageFieldWidgetState extends State<ImageFieldWidget> {
  File? selectedFile;
  Future<void> takePic() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedImage == null) return;

    setState(() {
      selectedFile = File(pickedImage.path);
    });

    widget.onImageSelection(selectedFile!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: takePic,
      label: Text(
        "Select Image",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
      icon: const Icon(Icons.camera),
    );

    if (selectedFile != null) {
      content = InkWell(
          onTap: takePic,
          child: Image.file(
            selectedFile!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ));
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1))),
      child: content,
    );
  }
}
