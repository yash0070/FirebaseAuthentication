import 'package:firebase_app/HomeScreen.dart';
import 'package:firebase_app/RegistrationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // email field
    final emailField = TextFormField(
      autofocus: false,
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
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );

    // password field

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      onSaved: (value) {
        passwordController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'password is required';
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );

    // login bUtton

    final logInButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.deepPurple,
      child: MaterialButton(
          child: Text("LogIn"),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          }),
    );

    // // google signIn button
    // final googleButton = Material(
    //   elevation: 5.0,
    //   borderRadius: BorderRadius.circular(20.0),
    //   color: Colors.white,
    //   child: MaterialButton(
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Image(
    //             image: AssetImage("images/googleLogo.png"),
    //             height: 45,
    //             width: 45,
    //           ),
    //           SizedBox(
    //             width: 30.0,
    //           ),
    //           Text(
    //             "Sign in with Google",
    //             style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    //           ),
    //         ],
    //       ),
    //       minWidth: MediaQuery.of(context).size.width,
    //       onPressed: () {}),
    // );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: SingleChildScrollView(
                child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150.0,
                      child: Image.asset(
                        "images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 45.0),
                    emailField,
                    const SizedBox(height: 25.0),
                    passwordField,
                    const SizedBox(height: 35.0),
                    logInButton,
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationScreen()));
                          },
                          child: const Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                  ],
                )),
          ),
        ))));
  }

  void signIn(String email, String password) async {
    if (_key.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "login Succesfully"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  Future<void> googleSignIn() async {}
}
