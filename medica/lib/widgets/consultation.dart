import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:medica/models/auth.dart';
import 'package:medica/models/consulting.dart';

class ConsultationWidget extends StatefulWidget {
  _ConsultationWidgetState createState() => _ConsultationWidgetState();
}

class _ConsultationWidgetState extends State<ConsultationWidget> {
  bool _isLoading = false;
  bool _isShow = false;
  @override
  Widget build(BuildContext context) {
    return ConsultingData.consultingsData.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'You didn`t enter any consultings click the add button to start.',
                textAlign: TextAlign.center,
              ),
            ),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return consultCard(ConsultingData.consultingsData[index], index);
            },
            itemCount: ConsultingData.consultingsData.length);
  }

  Widget consultCard(Consulting consult, int index) {
    print(consult.id);
    return Card(
        elevation: 5,
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(5.0),
                child: Text(
                  "Specialty: " + consult.specialty,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(5.0),
                  child: Text(
                    "Age: " + consult.age.toString(),
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(5.0),
                  child: Text(
                    "Date: " + consult.time,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  )),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Text(consult.content)),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        child: StreamBuilder(
                      stream: Auth.database
                          .child(
                              'specialty/${consult.specialty}/consultation/${Auth.userId}/${consult.id}/answer')
                          .onValue,
                      builder: (context, snap) {
                        if (snap.hasData &&
                            !snap.hasError &&
                            snap.data.snapshot.value != null) {
                          consult.answer = snap.data.snapshot.value;
                          return RaisedButton(
                              color: Colors.blue[200],
                              child: Icon(_isShow
                                  ? Icons.close
                                  : Icons.question_answer),
                              onPressed: () {
                                if (!_isShow) {
                                  setState(() {
                                    _isShow = true;
                                  });
                                }
                              });
                        } else
                          return RaisedButton(
                            color: Colors.blue[200],
                            child: Icon(Icons.question_answer),
                            onPressed: null,
                          );
                      },
                    )),
                    Flexible(
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                color: Colors.blue[200],
                                child: Icon(Icons.delete),
                                onPressed: () {
                                  _delete(consult.specialty, consult.id);
                                },
                              ))
                  ],
                ),
              ),
              if (_isShow)
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(5.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Text(consult.answer)),
            ],
          ),
        ));
  }

  Future<void> _delete(String specialty, String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool res = await ConsultingData.deleteConsultings(specialty, id);
      if (res) {
        ConsultingData.consultingsData
            .removeWhere((element) => element.id == id);
      }
    } catch (error) {
      print("error delete : " + error.toString());
    }
    setState(() {
      _isLoading = true;
    });
  }
}
