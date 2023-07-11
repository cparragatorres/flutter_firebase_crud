import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trueque_app/HomeScreen/home_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:trueque_app/Widgets/listview_widget.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "";
  bool _isSearching = false;
  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      style: TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: "busque aquí...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white, fontSize: 16.0),

      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: _startSearch,
      )
    ];
  }

  _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _buildTitle(context) {
    return const Text("Buscar producto");
  }

  _buildBackButton() {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WelcomeBackground2(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: _isSearching ? BackButton() : _buildBackButton(),
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
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
          automaticallyImplyLeading: false,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("items")
              .where("itemModel", isGreaterThanOrEqualTo: _searchQueryController.text.trim())
              .where("status", isEqualTo: "aprobado").snapshots(),
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
