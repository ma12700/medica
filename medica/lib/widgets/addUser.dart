import 'package:flutter/material.dart';
import 'package:medica/models/doctors.dart';
import 'package:medica/models/pharmacy.dart';
import '../models/consulting.dart';
import '../models/http_exception.dart';

class AddUser extends StatefulWidget {
  final String user;
  AddUser(this.user);
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  var dropdownValue = 'Children';
  var newSpecality = false;
  final _passwordController = TextEditingController();
  Map<String, dynamic> _authData = {
    'name': '',
    'phone': '',
    'address': '',
    'specality': '',
    'email': '',
    'password': '',
  };
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.user == 'doctor') {
        await DoctorModel.addDoctor(
            _authData['email'],
            _authData['password'],
            Doctor(dropdownValue, _authData['name'], _authData['phone'],
                _authData['address'], 0));
      } else {
        await PharmacyModel.addPharmacy(
            _authData['email'],
            _authData['password'],
            Pharmacy(
                _authData['name'], _authData['phone'], _authData['address']));
      }
      _formKey.currentState.reset();
      _passwordController.text = "";
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not add user. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (widget.user == 'doctor')
                    !newSpecality
                        ? selectMenu()
                        : TextFormField(
                            decoration: InputDecoration(labelText: 'Specialty'),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value.isEmpty ||
                                  ConsultingData.specialties.contains(value)) {
                                return 'Invalid Specialty!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _authData['specality'] = value;
                            },
                          ),
                  if (widget.user == 'doctor')
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            newSpecality = !newSpecality;
                          });
                        },
                        textColor: Colors.blue,
                        child: Text(!newSpecality
                            ? 'Enter new Specialty'
                            : 'Select from current Specialties')),
                  TextFormField(
                    enableSuggestions: true,
                    decoration: InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Invalid Name!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['name'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'It is required!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['phone'] = value;
                    },
                  ),
                  TextFormField(
                    enableSuggestions: true,
                    decoration: InputDecoration(labelText: 'Address'),
                    keyboardType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Invalid Address!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['address'] = value;
                    },
                  ),
                  TextFormField(
                    enableSuggestions: true,
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Invalid Name!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          )),
          if (_isLoading)
            CircularProgressIndicator()
          else
            Container(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Add ' + widget.user),
                onPressed: _submit,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
              ),
            ),
        ],
      ),
    );
  }

  Widget selectMenu() {
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.grey,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          _authData['specality'] = newValue;
        });
      },
      items: ConsultingData.specialties
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            width: double.infinity,
            child: Text(
              value,
            ),
          ),
        );
      }).toList(),
    );
  }
}
