import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trueque_app/DialogBox/loading_dialog.dart';
import 'package:trueque_app/HomeScreen/home_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

import '../Widgets/global_var.dart';

class UploadAdScreen extends StatefulWidget {
  const UploadAdScreen({super.key});

  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {
  String postId = Uuid().v4();
  bool uploading = false;
  bool next = false;
  final List<File> _image = [];
  List<String> urlsList = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name = "";
  String phoneNo = "";
  double val = 0;
  // // CollectionReference? imgRef; eliminar luego de crear el json para subir la informacion del articulo
  String itemPrice = "";
  String itemModel = "";
  String itemColor = "";
  // String itemState = "";
  String description = "";
  // final List<String> stateItems = [
  //   "Nuevo",
  //   "Usado - Como nuevo",
  //   "Usado - Buen estado",
  //   "Usado - Aceptable",
  // ];
  // String? selectedStateValue;
  final List<String> categoryItems = [
    "Deportes",
    "Cocina",
    "Electrónico",
    "Música",
    "Videojuegos",
    "Libros",
    "Otros",
  ];
  // String? selectedCategoryValue;
  // final _uploadFormKey = GlobalKey<FormState>();

  chooseImage() async {
    // esta funcion chooseImage va seleccionar una imagen de la galería del
    // dispositivo y agregarla a una lista llamada _image utilizando el
    // paquete image_picker.
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  Future uploadFile() async {
    // Esta función uploadFile recorre una lista de imágenes y las sube una por una
    // al almacenamiento de Firebase Storage. Luego, obtiene la URL de descarga de
    // cada imagen subida y la agrega a una lista.
    // Además, actualiza el estado de la clase para reflejar el progreso de la carga
    // de las imágenes.
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      var ref = FirebaseStorage.instance.ref().child("images/${Path.basename(img.path)}");
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlsList.add(value);
          i++;
        });
      });
    }
  }

  getNameofUser() {
    // función getNameofUser realiza una consulta a Firestore para obtener el
    // nombre y el número de teléfono de un usuario y los asigna a las variables
    // correspondientes en el estado del widget.
    // Luego, imprime los valores en la consola con fines de depuración.
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!["userName"];
          phoneNo = snapshot.data()!["userNumber"];
          print("!!!NAME : " + name);
          print("!!! PHONE : " + phoneNo);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNameofUser();
    // imgRef = FirebaseFirestore.instance.collection("imageUrls"); //eliminar luego de crear el json para subir la informacion del articulo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text(
          next ? "Describa la información del artículo" : " Elija imágenes del artículo",
        ),
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
          next
              ? Container()
              : ElevatedButton(
                  onPressed: () {
                    if (_image.length == 5) {
                      setState(() {
                        uploading = true;
                        next = true;
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: "Debe subir 5 fotos del artículo",
                        gravity: ToastGravity.CENTER,
                      );
                    }
                  },
                  child: const Text("Next"),
                ),
        ],
      ),
      body: next
          ? WelcomeBackground1(
              alignmentGeometry: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12.0),
                      TextFieldItems(
                        // hintext: "¿Por qué artículo le gustaría truequear?",
                        hintext: "Enter item Price",
                        onChanged: (value) {
                          itemPrice = value;
                        },
                      ),
                      const SizedBox(height: 12.0),
                      TextFieldItems(
                        // hintext: "Ingrese el nombre de su artículo",
                        hintext: "Enter item Name",
                        onChanged: (value) {
                          itemModel = value;
                        },
                      ),
                      const SizedBox(height: 12.0),
                      DropdownButtonWidget(
                        optionName: "Categoría",
                        items: categoryItems,
                        onsaved: (value) {
                          itemColor = value.toString();
                        },
                        onchanged: (value) {
                          itemColor = value!;
                        },
                      ),

                      // const SizedBox(height: 12.0),
                      // TextFieldItems(
                      //   // hintext: "¿Cuál sería su categoría?",
                      //   hintext: "Enter item Color",
                      //   onChanged: (value) {
                      //     itemColor = value;
                      //   },
                      // ),
                      // const SizedBox(height: 12.0),
                      // DropdownButtonWidget(
                      //   optionName: "Estado del artículo",
                      //   items: stateItems,
                      //   onsaved: (value) {
                      //     itemState = value.toString();
                      //   },
                      //   onchanged: (value) {
                      //     itemState = value!;
                      //   },
                      // ),
                      const SizedBox(height: 12.0),
                      TextFieldItems(
                        // hintext: "Escriba alguna descripcion de su artículo",
                        hintext: "Write some Items Description",
                        maxlines: 6,
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                      const SizedBox(height: 30.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) { return LoadingAlertDialog(message: "Publicando...");});
                            uploadFile().whenComplete(() {
                              FirebaseFirestore.instance.collection("items").doc(postId).set({
                                "userName": name,
                                "id": _auth.currentUser!.uid,
                                "postId": postId,
                                "userNumber": phoneNo,
                                "itemPrice": itemPrice,
                                "itemModel": itemModel,
                                "itemColor": itemColor,
                                "description": description,
                                "urlImage1": urlsList[0].toString(),
                                "urlImage2": urlsList[1].toString(),
                                "urlImage3": urlsList[2].toString(),
                                "urlImage4": urlsList[3].toString(),
                                "urlImage5": urlsList[4].toString(),
                                'imgPro': userImageUrl,
                                'lat': position!.latitude,
                                'lng': position!.longitude,
                                'address': completeAddress,
                                'time': DateTime.now(),
                                'status': "aprobado",
                              });
                              Fluttertoast.showToast(msg: 'Data added succesfully..');
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                            }).catchError((onError) {
                              print("### ERRROR FIREBASE###");
                              print(onError);
                            });
                          },
                          child: const Text(
                            "Publicar!",
                            style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : WelcomeBackground1(
              alignmentGeometry: Alignment.topCenter,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: GridView.builder(
                      itemCount: _image.length + 1,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: IconButton(
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    !uploading ? chooseImage() : null;
                                  },
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                  uploading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "cargando...",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              CircularProgressIndicator(
                                value: val,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                              )
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}

class DropdownButtonWidget extends StatelessWidget {
  final String optionName;
  final Function(String?)? onsaved;
  final Function(String?)? onchanged;
  final List<String> items;

  DropdownButtonWidget({
    required this.items,
    this.optionName = "",
    required this.onsaved,
    required this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20.0)), // Cambiar el color del borde normal
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white)), // Cambiar el color del borde cuando está enfocado
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.white)), // Cambiar el color del borde cuando hay un error
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            // Cambiar el color del borde cuando hay un error y está enfocado
            borderSide: BorderSide(color: Colors.white)),
        // Add more decoration..
      ),
      hint: Text(
        optionName,
        style: TextStyle(
          color: Colors.white54,
        ),
      ),
      items: items
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.white),
                ),
              ))
          .toList(),
      onChanged: onchanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor seleccione una opción';
        }
        return null;
      },

      onSaved: onsaved,
      // onSaved: (value) {
      //   // selectedCategoryValue = value.toString();
      // },
      buttonStyleData: ButtonStyleData(
        width: 160,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
      ),
      //dropdown es para la Lista de items
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff310f0e),
        ),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all(6),
          thumbVisibility: MaterialStateProperty.all(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

class TextFieldItems extends StatelessWidget {
  final String hintext;
  final int maxlines;
  final Function(String) onChanged;

  TextFieldItems({
    required this.hintext,
    this.maxlines = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxlines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        hintText: hintext,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(width: 2, color: Colors.white70),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
