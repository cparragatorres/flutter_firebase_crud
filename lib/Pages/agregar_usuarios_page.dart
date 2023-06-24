import 'package:flutter/material.dart';
import 'package:trueque_app/services/firebase_service.dart';

class AgregarUsuariosPage extends StatefulWidget {
  @override
  State<AgregarUsuariosPage> createState() => _AgregarUsuariosPageState();
}

class _AgregarUsuariosPageState extends State<AgregarUsuariosPage> {
  TextEditingController nameController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Ingrese el nuevo nombre'),
            ),
            ElevatedButton(
              onPressed: () async {
                print("Nuevo nombre: " + nameController.text);
                await addUsers(nameController.text).then((value) {
                  Navigator.pop(context);
                });
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
