// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//Funcion para LEER la informacion de Cloud Firestore
//---------------------------------------------------
Future<List> getUsers() async {
  List users = [];
  CollectionReference collectionReferencePerson = db.collection('users'); // db.collection('nombre de la coleccion');
  QuerySnapshot queryUsers = await collectionReferencePerson.get();

  queryUsers.docs.forEach((element) {
    final Map<String,dynamic> data = element.data() as Map<String,dynamic>;
    final person = {
      "name": data['name'],
      "uid" : element.id,
    };
    users.add(person);
  });

  // await Future.delayed(Duration(seconds: 3)); //Delay intencionado para hacer pruebas de carga
  return users;
}

//Funcion para GUARDAR la informacion en Cloud Firestore
//------------------------------------------------------
Future<void> addUsers(String name) async{
  await db.collection("users").add(
    {
      "name": name
    }
  );
}

//Funcion para ACTUALIZAR la informacion en Cloud Firestore
//---------------------------------------------------------
Future<void> updateUsers(String uid, String newName) async{
  await db.collection("users").doc(uid).set(
    {
      "name":newName
    }
  );
}
//Funcion para ELIMINAR la informacion en Cloud Firestore
//Se elimina por ID
//---------------------------------------------------------
Future<void> deleteUsers(String uid) async{
  await db.collection("users").doc(uid).delete();
}