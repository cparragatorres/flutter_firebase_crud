import 'package:flutter/material.dart';
// Pages
import 'package:trueque_app/crud/crud_agregar_usuarios_page.dart';
import 'package:trueque_app/crud/crud_editar_usuarios_page.dart';
import 'package:trueque_app/crud/crud_mostrar_usuarios_page.dart';
import 'package:trueque_app/Pages/t_home_page.dart';
import 'package:trueque_app/crud/crud_subir_imagenes_page.dart';

class CrudHomePage extends StatefulWidget {
  @override
  State<CrudHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<CrudHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Flutter Firestore",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 160.0,
                child: Divider(
                  thickness: 0.45,
                ),
              ),
              ItemComponentWidget(
                title: "Mostrar datos de Firestore",
                toPage: MostrarUsuariosPage(),
              ),
              ItemComponentWidget(
                title: "Agregar datos en Firestore",
                toPage: CrudAgregarUsuariosPage(),
              ),
              ItemComponentWidget(
                title: "Editar datos en Firestore",
                toPage: CrudEditarUsuariosPage(),
              ),
              ItemComponentWidget(
                title: "Subir Imagenes a Firebase Storage",
                toPage: SubirImagenesPage(),
              ),
              ItemComponentWidget(
                title: "Trueque App",
                toPage: THomePage(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CrudAgregarUsuariosPage()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class ItemComponentWidget extends StatefulWidget {
  final String title;
  final Widget toPage;

  ItemComponentWidget({
    required this.title,
    required this.toPage,
  });

  @override
  State<ItemComponentWidget> createState() => _ItemComponentWidgetState();
}

class _ItemComponentWidgetState extends State<ItemComponentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: Offset(4, 4),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => widget.toPage));
        },
        leading: Icon(
          Icons.check_circle_outline,
          color: Color(0xff4a5467),
        ),
        title: Text(widget.title),
        trailing: Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}
