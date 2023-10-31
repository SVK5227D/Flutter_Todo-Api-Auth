// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:todo2/Designs/header.dart';
import 'package:todo2/Designs/theme.dart';
import 'package:todo2/Pages/homePage.dart';
import 'package:todo2/Pages/loginPage.dart';
import 'package:todo2/Pages/noInternet.dart';
import 'package:todo2/Services/google_auth.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  // TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordVisible = true;
  bool passwordVisible1 = true;
  bool isOnline = true;

  // Check Internet connection
  Future<void> initConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isOnline = false;
      });
    } else {
      setState(() {
        isOnline = true;
      });
    }

    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOnline = false;
        });
      } else {
        setState(() {
          isOnline = true;
        });
      }
    });
  }

  void registerMethod() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Lottie.asset('assets/gif/auth.gif'),
      ),
    );

    //Password macth
    if (passwordController.text != confirmPasswordController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Password don't match"),
              ));
    } else {
      // adding new user
      try {
        // new user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailIdController.text,
          password: passwordController.text,
        );

        addNewUserDocument(userCredential);

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        // Display error
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.code),
                ));
      }
      nameController.clear();
      emailIdController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    }
  }

  Future<void> addNewUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': nameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isOnline ? GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 150,
                child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 5, color: Colors.white),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                        offset: Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey.shade300,
                                    size: 80.0,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Colors.grey.shade700,
                                    size: 25.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: TextFormField(
                              controller: nameController,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Full Name', 'Enter your full name'),
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(r'[0-9@#$]')
                              ],
                              validator: (name) {
                                if (name!.isEmpty) {
                                  return "Enter your full name";
                                }
                                return null;
                              },
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              controller: emailIdController,
                              decoration: ThemeHelper().textInputDecoration(
                                  "E-mail address", "Enter your email"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (email) {
                                if (email!.isEmpty) {
                                  return "Enter your emailid";
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                    .hasMatch(email)) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          // SizedBox(height: 20.0),
                          // Container(
                          //   decoration:
                          //       ThemeHelper().inputBoxDecorationShaddow(),
                          //   child: TextFormField(
                          //     controller: mobileNumberController,
                          //     decoration: ThemeHelper().textInputDecoration(
                          //       "Mobile Number",
                          //       "Enter your mobile number",
                          //     ),
                          //     keyboardType: TextInputType.phone,
                          //     maxLength: 10,
                          //     validator: (val) {
                          //       if (!(val!.isEmpty) &&
                          //           !RegExp(r"^(\d+)*$").hasMatch(val)) {
                          //         return "Enter a valid phone number";
                          //       } else if (val.isEmpty) {
                          //         return "Enter your mobile number";
                          //       } else if (val.length < 10) {
                          //         return "Verify your mobile number is lessthan 10";
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: passwordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password*',
                                hintText: 'Enter your password',
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible = !passwordVisible;
                                      },
                                    );
                                  },
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0)),
                              ),
                              validator: (password) {
                                if (password!.isEmpty) {
                                  return "Please enter your password";
                                } else if (password.length < 8) {
                                  return "Password length is low";
                                } else if (password.length > 15) {
                                  return "Password length must be 15 or below 15";
                                }
                                return null;
                              },
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            child: TextFormField(
                              controller: confirmPasswordController,
                              obscureText: passwordVisible1,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Enter your password',
                                fillColor: Colors.white,
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible1
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(
                                      () {
                                        passwordVisible1 = !passwordVisible1;
                                      },
                                    );
                                  },
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0)),
                              ),
                              validator: (password) {
                                if (password!.isEmpty) {
                                  return "Please enter your password";
                                } else if (password.length < 8) {
                                  return "Password length is low";
                                } else if (password.length > 15) {
                                  return "Password length must be 15 or below 15";
                                }
                                return null;
                              },
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Register".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  registerMethod();
                                }
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            //child: Text('Don\'t have an account? Create'),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(text: "Already have an account \t "),
                              TextSpan(
                                text: 'Login',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ])),
                          ),
                          SizedBox(height: 30.0),
                          Container(),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: ()async{
                          await GoogleAuthServices(context).signInWithGoogle();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage("assets/images/google_image.png"),
                                height: 18.0,
                                width: 24,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 24, right: 8),
                                child: Text(
                                  'Sign up with Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ): NoInternetScreen(),
    );
  }
}
