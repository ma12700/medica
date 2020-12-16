import 'package:flutter/material.dart';
import 'package:medica/screens/auth_screen.dart';
import '../models/auth.dart';

class AppDrawer extends StatelessWidget {
  final Function select;

  const AppDrawer(this.select);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          InkWell(
            child: AppBar(
              title: Text('Medica'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Expanded(
              child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.web),
                title: Text('News'),
                onTap: () {
                  select('News');
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.local_hospital),
                title: Text('Hospitals'),
                onTap: () {
                  select('Hospitals');
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.healing),
                title: Text('Symptoms Test'),
                onTap: () {
                  select('Symptoms Test');
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Consultings'),
                onTap: () {
                  select('Consultings');
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person_search),
                title: Text('Doctors'),
                onTap: () {
                  select('Doctors');
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.local_pharmacy),
                title: Text('Pharmacies'),
                onTap: () {
                  select('Pharmacies');
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context).pop();
                  Auth.logout();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => AuthScreen()));
                },
              )
            ],
          ))
        ],
      ),
    );
  }
}
