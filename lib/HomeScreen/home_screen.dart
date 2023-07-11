import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trueque_app/LoginScreen/login_screen.dart';
import 'package:trueque_app/ProfileScreen/profile_screen.dart';
import 'package:trueque_app/SearchProduct/SearchProduct.dart';
import 'package:trueque_app/UploadAdScreen/upload_ad_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:trueque_app/Widgets/global_var.dart';
import 'package:trueque_app/Widgets/listview_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  getMyData() {
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((result) {
      setState(() {
        userImageUrl = result.data()!["userImage"]; //foto del usuario registrado en Firestore Database
        getUserName = result.data()!["userName"]; //nombre de usuario registrado en Firestore Database
      });
    });
  }

  getUserAddress() async {
    Position newPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    position = newPosition;
    placemarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark placemark = placemarks![0];
    String newCompleteAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare},' // <Número de edificio> <Nombre de la calle>,
        '${placemark.subThoroughfare} ${placemark.locality},' // <Número de edificio> <Nombre de la calle>,
        '${placemark.subAdministrativeArea},' // <Área administrativa secundaria>,
        '${placemark.administrativeArea} ${placemark.postalCode},' // <Área administrativa principal> <Código postal>,
        '${placemark.country},'; // <País>

    completeAddress = newCompleteAddress;
    print("Direccion Completa: " + completeAddress);
    return completeAddress;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAddress();
    uid = FirebaseAuth.instance.currentUser!.uid;
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Truequemos!"),
          centerTitle: false,
          flexibleSpace: Container(
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
          ),
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        sellerId: uid,
                      ),
                    ));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchProduct(),
                    ));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                });
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: WelcomeBackground1(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("items").orderBy("time", descending: true).snapshots(),
            //Este builder se reutilizará en ProfileScreen y SearchProduct
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListViewWidget(
                            docId: snapshot.data!.docs[index].id,
                            itemColor: snapshot.data!.docs[index]["itemColor"],
                            img1: snapshot.data!.docs[index]["urlImage1"],
                            img2: snapshot.data!.docs[index]["urlImage2"],
                            img3: snapshot.data!.docs[index]["urlImage3"],
                            img4: snapshot.data!.docs[index]["urlImage4"],
                            img5: snapshot.data!.docs[index]["urlImage5"],
                            userImg: snapshot.data!.docs[index]["imgPro"],
                            name: snapshot.data!.docs[index]["userName"],
                            date: snapshot.data!.docs[index]["time"].toDate(),
                            userId: snapshot.data!.docs[index]["id"],
                            itemModel: snapshot.data!.docs[index]["itemModel"],
                            postId: snapshot.data!.docs[index]["postId"],
                            itemPrice: snapshot.data!.docs[index]["itemPrice"],
                            description: snapshot.data!.docs[index]["description"],
                            lat: snapshot.data!.docs[index]["lat"],
                            lng: snapshot.data!.docs[index]["lng"],
                            address: snapshot.data!.docs[index]["address"],
                            userNumber: snapshot.data!.docs[index]["userNumber"],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Text(
                    "Sé el primero en truequear",
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ));
                }
              }
              return Center(child: Text("Algo salió mal"));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Agregar Trueque",
          backgroundColor: Colors.brown.withOpacity(0.8),
          child: const Icon(Icons.cloud_upload),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadAdScreen(),
                ));
          },
        ),
      ),
    );
  }
}
