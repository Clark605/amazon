import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Future<List<XFile>> pickImages() async {
  List<XFile> images = [];

  try {
    await ImagePicker().pickMultiImage(imageQuality: 80).then((
      List<XFile>? value,
    ) {
      if (value != null && value.isNotEmpty) {
        for (var element in value) {
          images.add(XFile(element.path));
        }
      }
    });
  } catch (e) {
    print(e);
  }
  return images;
}
