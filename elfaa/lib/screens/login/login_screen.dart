import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elfaa/screens/signup/signup_screen.dart';
import 'package:elfaa/constants.dart';
import 'package:elfaa/screens/Homepage/navPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:elfaa/screens/login/ForgotPasswordPage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool obscured = true;
  Icon icon = Icon(Icons.visibility, color: Colors.grey);
  FocusNode focus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final double ScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: kPrimaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        title: const Text(
          "تسجيل الدخول",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.1, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logo1.png"),
                  SizedBox(height: ScreenHeight * 0.070),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.right,
                        controller: email,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.email_outlined,
                              color: Color(0xFFFD8601)),
                          labelText: "البريد الإلكتروني",
                          hintText: "أدخل بريدك الإلكتروني",
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        validator: (value) {
                          if (value!.isEmpty || email.text.trim() == "") {
                            return "الحقل مطلوب";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'أدخل بريد إلكتروني صالح';
                          }
                        },
                      )),
                  SizedBox(height: ScreenHeight * 0.025),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        focusNode: focus,
                        onTap: () {
                          FocusScope.of(context).requestFocus(focus);
                        },
                        controller: pass,
                        obscureText: obscured,
                        decoration: InputDecoration(
                          suffixIcon: focus.hasFocus
                              ? IconButton(
                                  icon: icon,
                                  onPressed: () {
                                    setState(() {
                                      obscured = !obscured;
                                      if (obscured == true) {
                                        icon = Icon(Icons.visibility,
                                            color: Colors.grey);
                                      } else {
                                        icon = Icon(Icons.visibility_off,
                                            color: Colors.grey);
                                      }
                                    });
                                  },
                                )
                              : Icon(Icons.lock_outline,
                                  color: Color(0xFFFD8601)),
                          labelText: "كلمة المرور",
                          hintText: "أدخل كلمة المرور",
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                        validator: (value) {
                          if (value!.isEmpty || pass.text.trim() == "") {
                            return "الحقل مطلوب";
                          }
                        },
                      )),
                  SizedBox(height: ScreenHeight * 0.025),
                  Align(
                    alignment: Alignment(-0.9, 0),
                    child: Container(
                      child: GestureDetector(
                        child: Text('نسيت كلمة المرور؟',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF818181),
                            )),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenHeight * 0.025),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: pass.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return NavPage();
                              },
                            ),
                          );
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "البريد الإلكتروني أو كلمة المرور غير صحيحة",
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.red,
                              fontSize: 16.0,
                              textColor: Colors.black);
                        }
                      }
                    },
                    child: Text("تسجيل الدخول",
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: ScreenHeight * 0.025),
                  signUpOption()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget logoWidget(String imageName) {
    return Center(
        child: Image.asset(
      imageName,
      fit: BoxFit.fill,
      width: 150,
      height: 150,
    ));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignupPage()));
          },
          child: Text(
            "تسجيل جديد ",
            style: TextStyle(
                fontSize: 17,
                color: Color(0xFF818181),
                fontWeight: FontWeight.w800),
          ),
        ),
        Text("ليس لديك حساب؟",
            style: TextStyle(fontSize: 17, color: Color(0xFF818181))),
      ],
    );
  }
}
