import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? userRole;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Create an Account')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
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
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter email in correct format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              Text('User Role'),
              DropdownButton(
                hint: userRole == null
                    ? Text('User Role')
                    : Text(
                        userRole!,
                        style: TextStyle(color: Colors.blue),
                      ),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(color: Colors.blue),
                items: ['user', 'admin', 'advanced user'].map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      userRole = val;
                    },
                  );
                },
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
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
              ElevatedButton(
                onPressed: _register,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() async {
    String now = new DateTime.now().toString();
    // String id = _auth.currentUser!.uid;
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        await _users.add({
          'id': _auth.currentUser!.uid,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'userRole': userRole,
          'registrationTime': now
        });
        _emailController.clear();
        _passwordController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to register'),
        ));
      }
    }
    //add email and password to firebase
  }
}
