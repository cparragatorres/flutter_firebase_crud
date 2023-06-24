import 'package:flutter/material.dart';
import 'package:trueque_app/services/firebase_service.dart';

class EditarUsuariosPage extends StatefulWidget {
  @override
  State<EditarUsuariosPage> createState() => _EditarUsuariosPageState();
}

class _EditarUsuariosPageState extends State<EditarUsuariosPage> {
  TextEditingController nameController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    // Guardando en un Map el argumento pasado de MostrarUsuarios para editar el
    // nombre deseado y sea actualizado en Firestore
    // snapshot.data?[index]['name'] es de tipo Mapa
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    nameController.text = arguments['name'];
    print("!!!ARGUMENTOS CAPTURADOS!!!: " + arguments.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Ingrese la modificación'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print("id de " + nameController.text + ": " + arguments["uid"]);
                  await updateUsers(arguments["uid"], nameController.text).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: const Text("Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
