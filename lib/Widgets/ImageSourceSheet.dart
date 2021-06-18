import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({this.onImageSelected, Key key}) : super(key: key);

  final Function(File) onImageSelected;

  _imageSelected(File f) async {
    if (f != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: f.path,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
      onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () async {
                  ImagePicker picker = ImagePicker();
                  PickedFile image =
                      await picker.getImage(source: ImageSource.camera);

                  File f = File.fromUri(Uri(path: image.path));
                  _imageSelected(f);
                },
                child: Text("Câmera")),
            TextButton(
                onPressed: () async {
                  ImagePicker picker = ImagePicker();
                  PickedFile image =
                      await picker.getImage(source: ImageSource.gallery);

                  File f = File.fromUri(Uri(path: image.path));
                  _imageSelected(f);
                },
                child: Text("Galeria")),
          ],
        );
      },
    );
  }
}
