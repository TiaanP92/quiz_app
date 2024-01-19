import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/start_screen.dart';
import 'package:quiz_app/results_screen.dart';
import 'package:http/http.dart' as http;

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  // Variable for data coming from API
  List responseDataQuiz = [];

  // API function
  Future api() async {
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=5&category=21&difficulty=easy&type=multiple'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['results'];
      setState(() {
        responseDataQuiz = data;
      });
    }
  }

  // require intit to instantiate api function
  @override
  void initState() {
    super.initState();
    api();
  }

  // Variable for the answer the user selected. Use on Results screen
  List<String> selectedAnswers = [];
  var activeScreen = 'start-screen';

  // when clicking on start on start screen
  void switchScreen() {
    setState(() {
      activeScreen = 'questions-screen';
    });
  }

  // use on question screens
  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    if (selectedAnswers.length == responseDataQuiz.length) {
      setState(() {
        activeScreen = 'results-screen';
      });
    }
  }

  // call from results screen
  void restartQuiz() {
    setState(() {
      selectedAnswers = [];
      activeScreen = 'questions-screen';
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget = StartScreen(switchScreen);

    // lift state to switch between screen and pass function through widgets
    if (activeScreen == 'questions-screen') {
      screenWidget = QuestionScreen(
        onSelectAnswer: chooseAnswer,
        responseDataQuestionScreen: responseDataQuiz,
      );
    }

    if (activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(
        chosenAnswers: selectedAnswers,
        onRestart: restartQuiz,
        responseDataQuestionScreen: responseDataQuiz,
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Background color for whole app
                Color.fromARGB(255, 31, 113, 109),
                Color.fromARGB(255, 38, 136, 131),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
