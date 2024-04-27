import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerr {
  Future uploadImage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickerImage = await picker.pickImage(
      source:
          inputSource == 'cammera' ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickerImage == null) {
      return;
    } else {
      File imageFile = File(pickerImage.path);
      return imageFile;
    }
  }
}
