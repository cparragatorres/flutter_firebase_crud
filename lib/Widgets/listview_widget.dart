import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:trueque_app/ImageSilderScreen/image_slider_screen.dart';

import 'global_var.dart';

class ListViewWidget extends StatefulWidget {
  String docId, itemColor;
  String img1, img2, img3, img4, img5;
  String userImg, name, userId, itemModel, postId;
  String itemPrice, description, address, userNumber;
  DateTime date;
  double lat, lng;

  ListViewWidget({
    required this.docId,
    required this.itemColor,
    required this.img1,
    required this.img2,
    required this.img3,
    required this.img4,
    required this.img5,
    required this.userImg,
    required this.name,
    required this.userId,
    required this.itemModel,
    required this.postId,
    required this.itemPrice,
    required this.description,
    required this.address,
    required this.userNumber,
    required this.date,
    required this.lat,
    required this.lng,
  });

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  Future<Future> showDialogForUpdateData(
      selectedDoc, oldUserName, oldPhoneNumber, oldItemPrice, oldItemName, oldItemColor, oldItemDescription) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              'Update Data',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Bebas',
                letterSpacing: 2.0,
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: oldUserName,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldUserName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    initialValue: oldPhoneNumber,
                    decoration: InputDecoration(
                      hintText: 'Enter Your PhoneNumber',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldPhoneNumber = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    initialValue: oldItemPrice,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Item Price',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemPrice = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    initialValue: oldItemName,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    initialValue: oldItemColor,
                    decoration: InputDecoration(
                      hintText: 'Enter Item Color',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemColor = value;
                      });
                    },
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    initialValue: oldItemDescription,
                    decoration: InputDecoration(
                      hintText: 'Enter Item Color',
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemDescription = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  updateProfileNameOnExistingPost(oldUserName);
                  _updateUsername(oldUserName, oldPhoneNumber);

                  FirebaseFirestore.instance.collection("items").doc(selectedDoc).update({
                    "userName": oldUserName,
                    "userNumber": oldPhoneNumber,
                    "itemPrice": oldItemPrice,
                    "itemModel": oldItemName,
                    "itemColor": oldItemColor,
                    "description": oldItemDescription,
                  }).catchError((onError) {
                    print(onError);
                  });
                  Fluttertoast.showToast(msg: "la info de tu trueque ha sido cargada");
                },
                child: const Text("Update Now"),
              ),
            ],
          ),
        );
      },
    );
  }

  updateProfileNameOnExistingPost(oldUserName) async {
    await FirebaseFirestore.instance
        .collection("items")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (int index = 0; index < snapshot.docs.length; index++) {
        String userProfileNameInPost = snapshot.docs[index]["userName"];
        if (userProfileNameInPost != oldUserName) {
          FirebaseFirestore.instance.collection("items").doc(snapshot.docs[index].id).update({
            "userName": oldUserName,
          });
        }
      }
    });
  }

  Future _updateUsername(oldUserName, oldPhoneNumber) async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "userName": oldUserName,
      "userNumber": oldPhoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(1.2, 0.2),
              colors: <Color>[
                Color(0xFF330f0e),
                Color(0xFF000000),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 4,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageSliderScreen(
                          title: widget.itemModel,
                          itemColor: widget.itemColor,
                          userNumber: widget.userNumber,
                          description: widget.description,
                          lat: widget.lat,
                          lng: widget.lng,
                          address: widget.address,
                          itemPrice: widget.itemPrice,
                          urlImage1: widget.img1,
                          urlImage2: widget.img2,
                          urlImage3: widget.img3,
                          urlImage4: widget.img4,
                          urlImage5: widget.img5,
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    widget.img1,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.userImg),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            widget.itemModel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            DateFormat('dd MMM yyyy - hh:mm a').format(widget.date).toString(),
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                      widget.userId != uid
                          ? Container(
                              padding: const EdgeInsets.only(right: 50.0),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialogForUpdateData(
                                      widget.docId,
                                      widget.name,
                                      widget.userNumber,
                                      widget.itemPrice,
                                      widget.itemModel,
                                      widget.itemColor,
                                      widget.description,
                                    );
                                  },
                                  icon: Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.edit_note,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection("items").doc(widget.postId).delete();
                                    Fluttertoast.showToast(
                                      msg: "El Post ha sido eliminado",
                                      toastLength: Toast.LENGTH_LONG,
                                      backgroundColor: Colors.red,
                                      fontSize: 18.0,
                                    );
                                  },
                                  icon: Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.delete_forever,
                                      size: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
