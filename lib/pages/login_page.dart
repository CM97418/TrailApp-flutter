import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String courseNumber = '';
  String bibNumber = '';

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Naviguer vers la page principale en passant les paramètres
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(courseNumber: courseNumber, bibNumber: bibNumber),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion Trail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Numéro de course'),
                validator: (value) => value!.isEmpty ? 'Entrer le numéro de course' : null,
                onChanged: (value) => courseNumber = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Numéro de dossard'),
                validator: (value) => value!.isEmpty ? 'Entrer le numéro de dossard' : null,
                onChanged: (value) => bibNumber = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Se connecter'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
