import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// Pages
import 'package:trueque_app/Pages/agregar_usuarios_page.dart';
import 'package:trueque_app/Pages/editar_usuarios_page.dart';
import 'package:trueque_app/Pages/mostrar_usuarios_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                style: GoogleFonts.oregano(
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
                toPage: AgregarUsuariosPage(),
              ),
              ItemComponentWidget(
                title: "Editar datos en Firestore",
                toPage: EditarUsuariosPage(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AgregarUsuariosPage()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class ItemComponentWidget extends StatelessWidget {
  String title;
  Widget toPage;

  ItemComponentWidget({
    required this.title,
    required this.toPage,
  });

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
          Navigator.push(context, MaterialPageRoute(builder: (context) => toPage));
        },
        leading: Icon(
          Icons.check_circle_outline,
          color: Color(0xff4a5467),
        ),
        title: Text(title),
        trailing: Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}
