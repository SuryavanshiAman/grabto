import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelection {
  final picker = ImagePicker();
  File? _imageFile;

  File? get imageFile => _imageFile;

  set imageFile(File? value) {
    _imageFile = value;
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _setImageFile(File(pickedFile.path), context);
    }
  }

  Future<void> _takePhotoWithCamera(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _setImageFile(File(pickedFile.path), context);
    }
  }

  void _setImageFile(File file, BuildContext context) {
    _imageFile = file;
    // Notify the widget to rebuild with the new image
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image selected!'),
        ),
      );
    }
  }

  void openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from gallery'),
              onTap: () {
                _pickImageFromGallery(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a photo'),
              onTap: () {
                _takePhotoWithCamera(context);
              },
            ),
          ],
        );
      },
    );
  }
}
