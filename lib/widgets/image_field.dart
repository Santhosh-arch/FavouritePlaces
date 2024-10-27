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

  Future<void> takePic(ImageSource src) async {
    final XFile? pickedImage;
    if (src == ImageSource.gallery) {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
    } else {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
    }

    if (pickedImage == null) return;

    setState(() {
      selectedFile = File(pickedImage!.path);
    });

    widget.onImageSelection(selectedFile!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: () {},
      label: Text(
        "No Image is Selected",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
      icon: const Icon(Icons.camera),
    );

    if (selectedFile != null) {
      content = Image.file(
        selectedFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1))),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                takePic(ImageSource.gallery);
              },
              label: const Text("Open Gallery"),
              icon: const Icon(Icons.photo_camera_back),
            ),
            TextButton.icon(
              onPressed: () {
                takePic(ImageSource.camera);
              },
              label: const Text("Open Camera"),
              icon: const Icon(Icons.camera_alt),
            )
          ],
        )
      ],
    );
  }
}
