import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen(this.startQuiz, {super.key});

  final void Function() startQuiz;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // variable for text input manipulation
  final _textController = TextEditingController();

  // to store input text in
  String userName = '';

  // to assist switch between textField and text widgets
  // 1 is false, 2 is true
  int isText = 1;

  @override
  void initState() {
    getSavedData();
    super.initState();
  }

  // fetch data from local storage
  getSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('name')!;
    isText = prefs.getInt('isText')!;

    setState(() {});
  }

  @override
  Widget build(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/quiz-logo.png',
              width: 300,
            ),
            const SizedBox(
              height: 1,
            ),
            Text(
              'SPORTS QUIZ',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 15,
                letterSpacing: 10,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              // switching between textField and text widgets
              child: isText.isEven
                  ? Column(
                      children: [
                        // isText = 2, display Welcome message
                        Text(
                          'Welcome $userName!',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 15,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // clear local data button
                        IconButton(
                          onPressed: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            setState(() {
                              isText = 1;
                            });
                          },
                          icon: const Icon(Icons.clear),
                          color: const Color.fromARGB(255, 192, 99, 93),
                        ),
                      ],
                    )
                  // isText = 1, dislpay input(textField) field and store name to local storage
                  : TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "ENTER YOUR NAME",
                        filled: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _textController.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // save name to local storage
                OutlinedButton.icon(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('name', _textController.text);
                    await prefs.setInt('isText', 2);

                    userName = _textController.text;

                    setState(() {
                      isText = 2;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('SAVE'),
                ),
                const SizedBox(
                  width: 20,
                ),
                // start with quiz
                OutlinedButton.icon(
                  onPressed: widget.startQuiz,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  icon: const Icon(Icons.arrow_right_alt),
                  label: const Text('START'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
