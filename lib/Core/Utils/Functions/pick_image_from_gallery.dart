import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PickImage {
  Future<File> pickImageFromGalleryOrCamera(
      {required ImageSource source}) async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: source);

    late File? imageFile = File('');
    if (pickedImage != null) {
      // Handle the selected image
      imageFile = File(pickedImage.path);
      // Perform your desired operations with the image file
    }
    return imageFile;
  }
}
