import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late TextEditingController _emailController,
      _passwordController,
      _repasswordController,
      _fullNameController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repasswordController = TextEditingController();
    _fullNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    _fullNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Form(
            key: _formKey,
            child: ListView(children: [
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "EMAIL ADDRESS",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Email'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "ENTER PASSWORD",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Password'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _repasswordController,
                validator: (value) {
                  if (value == null || value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "VERIFY PASSWORD",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Verify Password'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _fullNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be Empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter Full Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Full Name'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 18),
                      side: BorderSide(color: Colors.blue, width: 3.0),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Completing Registration')));

                        setState(() {
                          register();
                        });
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ])));
  }

  Future<void> register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      _db
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
            "email": _emailController.text,
            "fullName": _fullNameController.text,
            "id": userCredential.user!.uid,
            "registration_datetime": FieldValue.serverTimestamp()
          })
          .then((value) => null)
          .onError((error, stackTrace) => null);
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something Else")));
    } catch (e) {
      print(e);
    }

    setState(() {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (con) => LoginPage()));
  }
}
