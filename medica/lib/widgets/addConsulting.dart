import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import '../models/consulting.dart';

class AddConsultings extends StatefulWidget {
  final Function reload;
  AddConsultings(this.reload);
  _AddConsultingsState createState() => _AddConsultingsState();
}

class _AddConsultingsState extends State<AddConsultings> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  var dropdownValue = ConsultingData.specialties[0];
  Map<String, dynamic> _authData = {
    'age': 5,
    'content': '',
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
    bool res;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      res = await ConsultingData.addconsultings(Consulting(
          "",
          dropdownValue,
          _authData['age'],
          _authData['content'],
          "",
          Jiffy(DateTime.now()).yMMMd));
      if (res) {
        widget.reload('Consultings');
        Navigator.of(context).pop();
      }
    } catch (error) {
      const errorMessage =
          'Could not add your consulting. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add consulting'),
      ),
      body: Padding(
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
                    selectMenu(),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invalid Age!';
                        } else if (int.parse(value) < 1 ||
                            int.parse(value) > 120) {
                          return 'Invalid Age!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['age'] = int.parse(value);
                      },
                    ),
                    TextFormField(
                      enableSuggestions: true,
                      minLines: 1,
                      maxLines: 6,
                      decoration:
                          InputDecoration(labelText: 'Consulting details'),
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'It is required!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['content'] = value;
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
                  child: Text('Add'),
                  onPressed: _submit,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                ),
              ),
          ],
        ),
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
