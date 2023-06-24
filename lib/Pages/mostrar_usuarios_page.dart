import 'package:flutter/material.dart';
import 'package:trueque_app/Pages/agregar_usuarios_page.dart';
import 'package:trueque_app/Pages/editar_usuarios_page.dart';
// Servicios
import 'package:trueque_app/services/firebase_service.dart';

class MostrarUsuariosPage extends StatefulWidget {
  const MostrarUsuariosPage({
    super.key,
  });

  @override
  State<MostrarUsuariosPage> createState() => _MostrarUsuariosPageState();
}

class _MostrarUsuariosPageState extends State<MostrarUsuariosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mostrar Usuarios'),
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      //El Widget DISMISSIBLE es un widget deslizable para eliminar otro widget de la pantalla
                      //⚠️que lo borre de la pantalla no significa que lo borra de Firebase Firestore
                      //Para borrar de la BD
                      key: Key(snapshot.data?[index]['uid']), // ID único NOT NULL que identifica el objeto a eliminar
                      //⚠️onDismissed --> se ejecuta despues de ser eliminado
                      //⚠️onDismissed se usará para ELIMINAR DE LA BD
                      onDismissed: (direction) async{
                        await deleteUsers(snapshot.data?[index]['uid']); //Esto elimina el id
                        snapshot.data?.removeAt(index); //esto actualiza el index para el itemCount de ListView.builder()
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 18.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                      ),
                      direction: DismissDirection.endToStart,
                      //⚠️confirmDismiss -->  decide si se va eliminar o no
                      confirmDismiss: (direction) async {
                        bool result = false;
                        result = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "¿Estás seguro de eliminar a ${snapshot.data?[index]['name']}?",
                                ),
                                actions: [
                                  ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          iconSize: 32.0,
                                          highlightColor: Colors.green.withOpacity(0.1),
                                          icon: Icon(Icons.check, color: Colors.green),
                                          splashRadius: 20.0,
                                          onPressed: () {
                                            return Navigator.pop(context, true);
                                          }),
                                      SizedBox(width: 24.0),
                                      IconButton(
                                          iconSize: 32.0,
                                          highlightColor: Colors.red.withOpacity(0.1),
                                          icon: Icon(Icons.close, color: Colors.red),
                                          splashRadius: 20.0,
                                          onPressed: () {
                                            return Navigator.pop(context, false);
                                          }),
                                    ],
                                  )
                                ],
                              );
                            });

                        return result;
                      },
                      child: ListTile(
                        title: Text(snapshot.data?[index]['name']),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditarUsuariosPage(),
                                  settings: RouteSettings(
                                    arguments: {
                                      "name": snapshot.data?[index]['name'],
                                      "uid": snapshot.data?[index]['uid'],
                                    },
                                  )));
                          setState(() {}); //este setState actualiza los datos modificados en tiempo real
                        },
                      ),
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AgregarUsuariosPage()));
          setState(() {}); //este setState actualiza el nuevo nombre agregado en tiempo real
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
