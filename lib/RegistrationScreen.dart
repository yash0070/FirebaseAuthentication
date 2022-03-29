// ignore_for_file: unused_field

import 'dart:async';

import 'package:firebase_app/HomeScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150.0,
                        child: Image.asset("images/logo.png"),
                      ),
                      SizedBox(height: 45.0),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        onSaved: (value) {
                          nameController.text = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Name',
                            contentPadding: EdgeInsets.all(15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Email',
                            contentPadding: EdgeInsets.all(15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key),
                            hintText: 'Password',
                            contentPadding: EdgeInsets.all(15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.deepPurple,
                        child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text("SignUp"),
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                signUp();
                              }
                            }),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      Fluttertoast.showToast(msg: "Created Succesfully");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
