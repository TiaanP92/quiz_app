import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quiz_app/answer_button.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({
    super.key,
    required this.onSelectAnswer,
    required this.responseDataQuestionScreen,
  });

  final void Function(String answer) onSelectAnswer;
  final List<dynamic> responseDataQuestionScreen;

  @override
  State<QuestionScreen> createState() {
    return _QuestionScreenState();
  }
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<String> shuffledOptions = [];

  @override
  void initState() {
    super.initState();
  }

  var currentQuestionIndex = 0;

  void answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    setState(() {
      currentQuestionIndex++;
    });
  }

  // the following fucntion is to shuffle the options for the multiple choice.
  // so the correct answer is not always in the same spot.
  void updateShuffleOption() {
    setState(() {
      shuffledOptions = shuffleOption([
        widget.responseDataQuestionScreen[currentQuestionIndex]
            ['correct_answer'],
        ...(widget.responseDataQuestionScreen[currentQuestionIndex]
            ['incorrect_answers'] as List)
      ]);
    });
  }

  List<String> shuffleOption(List<String> option) {
    List<String> shuffledOptions = List.from(option);
    shuffledOptions.shuffle();
    return shuffledOptions;
  }

  @override
  Widget build(context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Questions
            Text(
              widget.responseDataQuestionScreen.isNotEmpty
                  ? widget.responseDataQuestionScreen[currentQuestionIndex]
                      ['question']
                  : '',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            // Answer options
            ...shuffleOption([
              widget.responseDataQuestionScreen[currentQuestionIndex]
                  ['correct_answer'],
              ...(widget.responseDataQuestionScreen[currentQuestionIndex]
                  ['incorrect_answers'] as List)
            ]).map((answer) {
              return AnswerButton(
                  answerText: answer,
                  onTap: () {
                    answerQuestion(answer);
                  });
            }),
          ],
        ),
      ),
    );
  }
}
