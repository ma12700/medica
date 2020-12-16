import 'package:flutter/material.dart';
import '../models/quiz.dart';

class TestWidget extends StatefulWidget {
  _TestState createState() => _TestState();
}

class _TestState extends State<TestWidget> {
  var index = 0;
  List<int> _result = [];

  void _selector(int answer) {
    if (_result.length == 0 || index == 0) {
      _result = [];
      for (int i = 0; i < QuizData.diseases.length; i++) {
        _result.add(0);
      }
    }
    for (int i = 0; i < QuizData.diseases.length; i++) {
      if (QuizData.answersOfDiseses[i][index] == answer) {
        _result[i] += 1;
      }
    }
    if (index < QuizData.questions.length) {
      setState(() {
        index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          child: index < QuizData.questions.length
              ? Column(
                  children: [
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(10.0),
                        child: Text(QuizData.questions[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28.0))),
                    ...answerWidget(),
                  ],
                )
              : Column(
                  children: [
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(30.0),
                        child: Text(resultText(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28.0))),
                    RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text("Re-Testing"),
                        onPressed: () {
                          setState(() {
                            index = 0;
                          });
                        })
                  ],
                )),
    );
  }

  List<Widget> answerWidget() {
    List<Widget> widgets = [];
    for (int i = 0; i < QuizData.answers.length; i++) {
      widgets.add(Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text(QuizData.answers[i]),
            onPressed: () {
              _selector(i);
            }),
      ));
    }
    return widgets;
  }

  String resultText() {
    int max = 0;
    int dis = 0;
    for (int i = 0; i < _result.length; i++) {
      if (_result[i] > max) {
        max = _result[i];
        dis = i;
      }
    }
    double res = max / QuizData.questions.length;
    if (res > 0.4) {
      return "You have ${QuizData.diseases[dis]} With percent ${(res * 100).toInt()}%";
    } else {
      return "You are Safe";
    }
  }
}
