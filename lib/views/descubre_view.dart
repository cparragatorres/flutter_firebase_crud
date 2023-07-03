import 'package:flutter/material.dart';
import 'package:trueque_app/crud/crud_mostrar_usuarios_page.dart';
import 'package:trueque_app/crud/crud_subir_imagenes_page.dart';
import 'package:trueque_app/views/descubre_views/destacado_view.dart';

class DescubreView extends StatefulWidget {
  const DescubreView({super.key});

  @override
  State<DescubreView> createState() => _DescubreViewState();
}

class _DescubreViewState extends State<DescubreView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(

          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Destacado'),
                  Tab(text: 'Cerca de ti'),
                  Tab(text: 'Hoy'),
                  Tab(text: 'Top'),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DestacadoView(),
            MostrarUsuariosPage(),
            SubirImagenesPage(),
          ],
        ),
      ),
    );
  }
}
