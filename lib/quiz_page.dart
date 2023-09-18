import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'question.dart';
import 'dart:convert';

// QuizPage class definition would go here. Replace with the actual QuizPage class from your main.dart.
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];
  List<Question> questionBank = [];
  int questionNumber = 0;

  @override
  void initState() {
    super.initState();
    loadQuestionBank();
  }

  Future<void> loadQuestionBank() async {
    String jsonString = await rootBundle.loadString('assets/questionBank.json');
    List<dynamic> raw = jsonDecode(jsonString);
    setState(() {
      questionBank =
          raw.map((e) => Question(q: e['question'], a: e['answer'])).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questionBank.isEmpty) {
      return CircularProgressIndicator();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                questionBank[questionNumber].questionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = questionBank[questionNumber].questionAnswer;

    setState(() {
      if (userPickedAnswer == correctAnswer) {
        scoreKeeper.add(
          Icon(
            Icons.check,
            color: Colors.green,
          ),
        );
      } else {
        scoreKeeper.add(
          Icon(
            Icons.close,
            color: Colors.red,
          ),
        );
      }

      if (questionNumber < questionBank.length - 1) {
        questionNumber++;
      } else {
        final int score = scoreKeeper
            .where(
                (element) => element is Icon && (element).color == Colors.green)
            .length;

        // Show the dialog first
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Quiz Ended'),
              content: Text('Your score is: $score'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      // Reset after the dialog is closed
                      questionNumber = 0;
                      scoreKeeper.clear();
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
}
