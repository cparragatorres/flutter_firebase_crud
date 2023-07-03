import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trueque_app/services/select_image_service.dart';
import 'package:trueque_app/services/upload_image.dart';

class SubirImagenesPage extends StatefulWidget {
  const SubirImagenesPage({super.key});

  @override
  State<SubirImagenesPage> createState() => _SubirImagenesPageState();
}

class _SubirImagenesPageState extends State<SubirImagenesPage> {
  File? imagen_to_upload;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 12.0,
              ),
              imagen_to_upload != null
                  ? Image.file(imagen_to_upload!)
                  : Container(
                      margin: EdgeInsets.all(10),
                      height: 200,
                      width: double.infinity,
                      color: Colors.red,
                    ),
              ElevatedButton(
                onPressed: () async {
                  final imagen = await getImage();
                  setState(() {
                    imagen_to_upload = File(imagen!.path);
                  });
                },
                child: Text("Seleccionar imagen"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (imagen_to_upload == null) {
                    return;
                  }
                  final uploaded = await uploadImage(imagen_to_upload!);
                  if (uploaded) {
                    const SnackBar(content: Text("Imagen subida Correctamente"));
                  } else{
                    const SnackBar(content: Text("Error al subir la imagen"));
                  }
                },
                child: Text("Subir a Firebase"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
