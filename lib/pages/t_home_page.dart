import 'package:flutter/material.dart';
import 'package:trueque_app/views/descubre_view.dart';
import 'package:trueque_app/views/navega_view.dart';
import 'package:trueque_app/views/pergil_view.dart';
import 'package:trueque_app/views/preguntas_view.dart';
import 'package:trueque_app/views/tus_ofertas_view.dart';

class THomePage extends StatefulWidget {
  const THomePage({super.key});

  @override
  State<THomePage> createState() => _THomePageState();
}

class _THomePageState extends State<THomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      DescubreView(),
      NavegaView(),
      TusOfertasView(),
      PreguntasView(),
      PerfilView(),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.2),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(1.2, 0.2),
              colors: <Color>[
                Color(0xFF330f0e),
                Color(0xFF000000),
              ],
            ),
          ),
          child: IndexedStack(
            index: selectedIndex,
            children: pantallas,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          fixedColor: Colors.green,
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: "Descubre",
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: "Navega",
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cached),
              activeIcon: Icon(Icons.cached),
              label: "Tus Ofertas",
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger),
              activeIcon: Icon(Icons.messenger),
              label: "Preguntas",
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              label: "Perfil",
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
