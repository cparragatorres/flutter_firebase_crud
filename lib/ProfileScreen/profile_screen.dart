import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trueque_app/HomeScreen/home_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:trueque_app/Widgets/global_var.dart';

class ProfileScreen extends StatefulWidget {
  String sellerId;

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
      width: 50,
      height: 50,
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
    FirebaseFirestore.instance.collection("items")
        .where("id", isEqualTo: widget.sellerId)
        .where("status", isEqualTo: "aproved")
        .get().then((results) {
      setState(() {
        items = results;
        adUserName = items!.docs[0].get("userName");
        adUserImageUrl = items!.docs[0].get("imgPro");
      });
    });
  }

  //call upon initState for get
  QuerySnapshot? items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
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
        child: Column(),
      ),
    );
  }
}
