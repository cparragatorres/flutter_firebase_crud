import 'package:flutter/material.dart';
import 'package:trueque_app/services/firebase_service.dart';

class CrudAgregarUsuariosPage extends StatefulWidget {
  @override
  State<CrudAgregarUsuariosPage> createState() => _CrudAgregarUsuariosPageState();
}

class _CrudAgregarUsuariosPageState extends State<CrudAgregarUsuariosPage> {
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
