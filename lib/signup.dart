import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase/firestore.dart';
import 'firebase/imgStorage.dart';
import 'util/imagePicker.dart';
import 'widgets/navigationBar.dart';
import 'login.dart'; // Ensure you have this page in your project or adjust the navigation accordingly

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  String URL = '';
  File? _profilePic;
  File? _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create an Account')),
      body: SingleChildScrollView(
        // Added SingleChildScrollView to handle overflow when keyboard appears
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: InkWell(
                  onTap: () async {
                    _imageFile = await ImagePickerr().uploadImage('gallery');
                    if (_imageFile != null) {
                      setState(() {
                        _profilePic = _imageFile;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.grey,
                    child: _profilePic == null
                        ? CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: AssetImage('images/person.png'),
                          )
                        : CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                Image.file(_profilePic!, fit: BoxFit.cover)
                                    .image,
                          ),
                  ),
                ),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                obscureText: true, // Ensures password is entered hidden
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'At least 6 characters',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Tell us something about yourself',
                ),
              ),
              SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => _register(profilePic: _profilePic),
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register({required File? profilePic}) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (profilePic != null) {
          URL = await StorageMethod()
              .uploadImageToStorage('profilePic', profilePic);
        } else {
          URL =
              'https://firebasestorage.googleapis.com/v0/b/mad-proj2.appspot.com/o/profilePic%2Fperson.png?alt=media&token=936530ff-ae79-42fd-a2c4-8c00dc11cfb3';
        }

        await FirestoreData().CreateUser(
            email: _emailController.text,
            username: _usernameController.text,
            bio: _bioController.text,
            profilePic: URL);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Navigation_Bar()), // Make sure LoginPage is defined or replace with your login page
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to register. Error: ${e.toString()}'),
        ));
        print(e.toString());
      }
    }
  }
}
