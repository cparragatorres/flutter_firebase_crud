import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trueque_app/DialogBox/error_dialog.dart';
import 'package:trueque_app/HomeScreen/home_screen.dart';
import 'package:trueque_app/LoginScreen/login_screen.dart';
import 'package:trueque_app/WelcomeScreen/background.dart';
import 'package:trueque_app/Widgets/already_have_an_Account_check.dart';
import 'package:trueque_app/Widgets/global_var.dart';
import 'package:trueque_app/Widgets/rounded_button.dart';
import 'package:trueque_app/Widgets/rounded_input_field.dart';
import 'package:trueque_app/Widgets/rounded_password_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  String userPhotoUrl = '';
  File? _image;
  bool _isLoading = false;
  final signUpFormKey = GlobalKey<FormState>();
  //Controladores
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //Autenticacion
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Foto de perfil
  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Por favor, elija una opción"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //InkWell 1
              InkWell(
                onTap: () {
                  _getFromCamera();
                },
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.camera,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      "Cámara",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
              //InkWell 2
              InkWell(
                onTap: () {
                  _getFromGallery();
                },
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.image,
                        color: Colors.purple,
                      ),
                    ),
                    Text(
                      "Galería",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void submitFormOnSignUp() async {
    final isValid = signUpFormKey.currentState!.validate();
    if (isValid) {
      if (_image == null) {
        showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: "Por favor seleccione una imagen",
            );
          },
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
          //trim() elimina los espacios en blanco iniciales
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );
        final User? user = _auth.currentUser;
        uid = user!.uid;
        final ref = FirebaseStorage.instance.ref().child("userImages").child(uid + '.jpg');
        await ref.putFile(_image!);
        userPhotoUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection("users").doc(uid).set(
            {
              "userName" : _nameController.text.trim(),
              "id" : uid,
              "userNumber" : _phoneController.text.trim(),
              "userEmail" : _emailController.text.trim(),
              "userImage" : userPhotoUrl,
              "time" : DateTime.now(),
              "status" : "aprobado",
            }
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      } catch (error) {
        setState(() {
          ErrorAlertDialog(message: error.toString(),);
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width, screenHeight = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: WelcomeBackground2(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: signUpFormKey,
                child: InkWell(
                  onTap: () {
                    _showImageDialog();
                  },
                  child: CircleAvatar(
                    radius: screenWidth * 0.20,
                    backgroundColor: Colors.white24,
                    backgroundImage: _image == null ? null : FileImage(_image!),
                    child: _image == null
                        ? Icon(
                            Icons.camera_enhance,
                            size: screenWidth * 0.18,
                            color: Colors.black54,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              RoundedInputField(
                hintText: 'Nombre',
                icon: Icons.person,
                iconColor: Colors.white,
                onChanged: (value) {
                  _nameController.text = value;
                },
              ),
              RoundedInputField(
                hintText: 'Teléfono',
                icon: Icons.phone_android,
                iconColor: Colors.white,
                keyboard: TextInputType.number,
                onChanged: (value) {
                  _phoneController.text = value;
                },
              ),
              RoundedInputField(
                hintText: 'Correo electrónico',
                icon: Icons.email,
                iconColor: Colors.white,
                onChanged: (value) {
                  _emailController.text = value;
                },
              ),
              RoundedPasswordField(
                iconColor: Colors.white,
                onChanged: (value) {
                  _passwordController.text = value;
                },
              ),
              SizedBox(
                height: 40.0,
                child: SizedBox(width: size.width * 0.8, child: const Divider(thickness: 2.0)),
              ),
              const SizedBox(height: 8.0),
              _isLoading
                  ? Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  : RoundedButton(
                      text: "REGISTRAR",
                      press: () {
                        submitFormOnSignUp();
                      },
                    ),
              SizedBox(height: screenHeight * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
