import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(File image) async {
  //1ro obtener el nombre de la imagen y guardarlo con ese nombre
  print("!!IMAGE.PATH: " + image.path);

  final String namefile = image.path.split("/").last;
  Reference ref = storage.ref().child("images").child(namefile);

  final UploadTask uploadTask = ref.putFile(image);
  print("!!!!UPLOADTASK!!!!");
  print(uploadTask);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  print("!!SNAPSHOT: " + snapshot.toString());

  final String url = await snapshot.ref.getDownloadURL();
  print("!!URL: " + url);

  if(snapshot.state == TaskState.success){
    return true;
  } else{
    return false;
  }
}
