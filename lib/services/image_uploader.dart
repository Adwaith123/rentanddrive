import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class GetImage {
  FirebaseStorage storage = FirebaseStorage.instance;

   File? _image; // Used only if you need a single picture

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);


    //
    // setState(() {
    if (image != null) {
      _image = File(image.path); // Use if you only need a single picture
    } else {
      print('No image selected.');
    }

    return _image;
    // });
  }



Future<void> uploadmage(File? _image,String uid) async
{
  if(_image==null){

print("image is not found null");
  }

else{

  try {

    print("called#@#@#@#@#@#@##@");
    // Uploading the selected image with some custom meta data
   final path= await storage.ref(uid).putFile(
        _image,
      ).then((p0) => print("uploaded@@@&&@&@&&@&&)")).catchError((e){print("ERRRORRRRR");});





  } on FirebaseException catch (error) {

    print(error);
} catch(err) {

  print(err);

  }}

}}