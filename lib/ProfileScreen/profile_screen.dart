import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trueque_app/HomeScreen/home_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:trueque_app/Widgets/global_var.dart';
import 'package:trueque_app/Widgets/listview_widget.dart';

class ProfileScreen extends StatefulWidget {
  String sellerId;
  String link = "";

  ProfileScreen({
    required this.sellerId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _buildBackButton() {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      icon: const Icon(Icons.arrow_back, color: Colors.white),
    );
  }

  _buildUserImage() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(adUserImageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  getResult() {
    FirebaseFirestore.instance
        .collection("items")
        .where("id", isEqualTo: widget.sellerId)
        .where("status", isEqualTo: "aprobado")
        .get()
        .then((results) {
      setState(() {
        items = results;
        adUserName = items!.docs[0].get("userName");
        adUserImageUrl = items!.docs[0].get("imgPro");
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResult();
  }

  //call upon initState for get
  QuerySnapshot? items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            _buildBackButton(),
            _buildUserImage(),
            const SizedBox(width: 12.0),
            Text(adUserName),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment(1.3, -0.3),
              colors: <Color>[
                Color(0xFFe05d1e),
                Color(0xFF280F09),
              ],
              stops: [0.0, 0.9],
            ),
          ),
        ),
      ),
      body: WelcomeBackground2(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("items")
              .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy("time", descending: true)
              .snapshots(),
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
    );
  }
}
