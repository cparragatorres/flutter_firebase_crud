import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSliderScreen extends StatefulWidget {
  final String title, urlImage1, urlImage2, urlImage3, urlImage4, urlImage5;
  final String itemColor, userNumber, description, address, itemPrice;
  final double lat, lng;

  ImageSliderScreen({
    required this.title,
    required this.urlImage1,
    required this.urlImage2,
    required this.urlImage3,
    required this.urlImage4,
    required this.urlImage5,
    required this.itemColor,
    required this.userNumber,
    required this.description,
    required this.address,
    required this.itemPrice,
    required this.lat,
    required this.lng,
  });

  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> with SingleTickerProviderStateMixin {
  static List<String> links = [];
  TabController? tabController;

  getLinks() {
    links.add(widget.urlImage1);
    links.add(widget.urlImage2);
    links.add(widget.urlImage3);
    links.add(widget.urlImage4);
    links.add(widget.urlImage5);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLinks();
    tabController = TabController(length: 5, vsync: this);
  }

  String? url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WelcomeBackground1(
      alignmentGeometry: Alignment.topCenter,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            widget.title,
            style: TextStyle(),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 6.0, right: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.white70,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.address,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                height: size.height * 0.5,
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Carousel(
                    indicatorBarColor: Colors.transparent,
                    autoScroll: true,
                    stopAtEnd: false,
                    autoScrollDuration: Duration(milliseconds: 1500),
                    animationPageDuration: Duration(milliseconds: 500),
                    activateIndicatorColor: Colors.deepOrange,
                    animationPageCurve: Curves.decelerate,
                    indicatorBarHeight: 80,
                    indicatorHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.white54,
                    items: [
                      Image.network(widget.urlImage1),
                      Image.network(widget.urlImage2),
                      Image.network(widget.urlImage3),
                      Image.network(widget.urlImage4),
                      Image.network(widget.urlImage5),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Center(
                  child: Text(
                    '\$ ${widget.itemPrice}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.brush_outlined, color: Colors.white),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.itemColor,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone_android, color: Colors.white),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.userNumber,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  widget.description,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 368.0),
                  child: ElevatedButton(
                    onPressed: () async{
                      url = "https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.lng}";
                      if (await canLaunchUrl(Uri.parse(url!))) {
                        await launchUrl(Uri.parse(url!));
                      } else {
                        throw "No se pudo abrir el mapa";
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
                    ),
                    child: Text("Comprobar la ubicación del vendedor"),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
