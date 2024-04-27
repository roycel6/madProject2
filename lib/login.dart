import 'homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'widgets/navigationBar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _formkey =
      GlobalKey<ScaffoldMessengerState>();
  bool _validateEmail = false;
  bool _validatePass = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _formkey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          title: Text('Login', style: TextStyle(color: Colors.black)),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText:
                      _validateEmail ? "Please enter an email address" : null,
                ),
              ),
              SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _validatePass ? "Please enter a password" : null,
                ),
              ),
              SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _validateEmail = _emailController.text.isEmpty;
                    _validatePass = _passwordController.text.isEmpty;
                  });
                  if (_validateEmail == false && _validatePass == false) {
                    _login();
                  }
                },
                child: Text('Login', style: TextStyle()),
              ),
              SizedBox(height: 14),
              TextButton(
                onPressed: _goToSignUp,
                child: Text('New user? Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      _emailController.clear();
      _passwordController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Navigation_Bar()),
      );
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Failed to login'),
        duration: Duration(seconds: 3),
      );
      _formkey.currentState!.showSnackBar(snackBar);
    }
  }

  void _goToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
