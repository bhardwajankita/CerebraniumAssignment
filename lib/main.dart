//import 'package:userdetails/form_screen.dart'
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Application',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // A widget which will be started on application startup
      home: FormScreen(),
    ); //material App
  }
}

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  String _name;
  String _email;
  String _phone;
  String _account;
  String _ifsc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        } //if
      }, //validator
      onSaved: (String value) {
        _name = value;
      },
    ); //Text form field
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        } //if

        if (!RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        return null;
      }, //validator
      onSaved: (String value) {
        _email = value;
      },
    ); //Text form field
  }

  Widget _buildPhone() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone number'),
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone number is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _phone = value;
      },
    );
  }

  Widget _buildAccount() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Account Number'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Account Number is required';
        } //if
      }, //validator
      onSaved: (String value) {
        _account = value;
      },
    ); //Text form field
  }

  Widget _buildIFSC() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'IFSC Number'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'IFSC Number is required';
        } //if
      }, //validator
      onSaved: (String value) {
        _ifsc = value;
      },
    ); //Text form field
  }

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'name': _name, // John Doe
            'email': _email,
            'phone': _phone,
            'ifsc': _ifsc,
            'account': _account // Stokes and Sons
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Form Demo")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildEmail(),
              _buildPhone(),
              _buildAccount(),
              _buildIFSC(),
              SizedBox(height: 100),
              RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16), //text style
                ), //text

                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();
                  print(_name);
                  print(_email);
                  print(_phone);
                  print(_account);
                  print(_ifsc);
                  addUser();
                }, //on pressed
              ) //raised button
            ], //widget
          ),
        ), //Column Form
      ), //Container
    ); //Scaffold
  }
}
