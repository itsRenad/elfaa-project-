import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:elfaa/screens/mngChildInfo/imgStorage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:path/path.dart' hide context;
import 'package:elfaa/constants.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
class addChild extends StatefulWidget {
  @override
  State<addChild> createState() => _addChildState();
}

class _addChildState extends State<addChild> {
//profile image variables
  File? _img;
  PickedFile? _imgFile;
  final ImagePicker _picker = ImagePicker();

//information form controllers
  final controllerName = TextEditingController();
  final controllerBirthday = TextEditingController();
  final controllerHeight = TextEditingController();

//globalKey
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controllerBirthday.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFf5f5f5),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 90,
          leading: const BackButton(color: Colors.white),
          title: const Text(
            "إضافة طفل جديد",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28)),
                      color: kPrimaryColor,
                 )),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.04, 20, 0),
                child: Column(
                  children: <Widget>[
                    childImg(),
                    const SizedBox(height: 40),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          controller: controllerName,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.child_care,
                                color: Color(0xFFFD8601)),
                            labelText: "اسم الطفل",
                          ),
                          validator: (value) {
                            if (value!.isEmpty ||
                                controllerName.text.trim() == "") {
                              return "الحقل مطلوب";
                            }
                          },
                        )),
                    const SizedBox(height: 20),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                            textAlign: TextAlign.right,
                            controller: controllerBirthday,
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_today,
                                  color: Color(0xFFFD8601)),
                              labelText: "تاريخ الميلاد",
                              hintText: "DD-MM-YYYY",
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  controllerBirthday.text.trim() == "") {
                                return "الحقل مطلوب";
                              }
                            },
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2010), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: const Color(0xFF429EB2),
                                        colorScheme: const ColorScheme.light(primary: Color(0xFF429EB2)),
                                        buttonTheme: const ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary
                                        ),
                                      ),
                                       child: child!,
                                    );
                                  },
                                  );

                              if (pickedDate != null) {
                                print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                               String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                               //   controllerBirthday.text = formattedDate; //set output date to TextField value.
                                });
                              }
                            })),
                    const SizedBox(height: 20),
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          controller: controllerHeight,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.accessibility_new,
                                color: Color(0xFFFD8601)),
                            labelText: "الطول",
                          ),
                          validator: (value) {
                            if (value!.isEmpty ||
                                controllerHeight.text.trim() == "") {
                              return "الحقل مطلوب";
                            }
                          },
                        )),
                        const SizedBox(height: 20),
                    Container(
                      width: 400,
                      child: ElevatedButton(
                          child: const Text('ربط جهاز التتبع'),
                          onPressed: null,
                          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                        child: const Text('إضافة'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final child = Child(
                                name: controllerName.text,
                                height: int.parse(controllerHeight.text),
                                birthday: DateTime.parse(controllerBirthday.text));

                            addChild(child);

                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xFF429EB2)),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  //-----------------Rero's Helping Methods--------------------------------//

  //Adding child's profile picture
  childImg() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
              radius: 80,
              backgroundImage: _imgFile == null
                  ? const AssetImage("assets/images/empty.png")
                  : FileImage(File(_imgFile!.path)) as ImageProvider),
          Positioned(
              bottom: 15,
              right: 15,
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomImgPicker()));
                  },
                  child: const Icon(Icons.camera_alt,
                      color: Color.fromARGB(255, 22, 147, 193), size: 28)))
        ],
      ),
    );
  }

//bottom container of image source options
  bottomImgPicker() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "chooose image",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  icon: const Icon(Icons.camera),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: const Text("Camera")),
              TextButton.icon(
                  icon: const Icon(Icons.image),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: const Text("Gallary"))
            ],
          )
        ],
      ),
    );
  }

//Getting the picture from the mobile camera
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    if (pickedFile == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("wth?")
          )
      );
      return null;
    }
  
    setState(() {
      _imgFile = pickedFile;
      _img = File(_imgFile!.path);
    });
    String name = basename(_imgFile!.path);
  }

  InputDecoration decoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  //adding child doc to a parent doc in the firestore database
  Future addChild(Child child) async {
    //Reference to document
    final docChild = FirebaseFirestore.instance
        .collection('parent')
        .doc('Renad')
        .collection('children')
        .doc();

    final json = child.toJson();
    //Create doc and write data
    await docChild.set(json);
  }
}

//child class
class Child {
  final String name;
  final int height;
  final DateTime birthday;

  Child({required this.name, required this.height, required this.birthday});

  Map<String, dynamic> toJson() =>
      {'name': name, 'height': height, 'birthday': birthday};
}
