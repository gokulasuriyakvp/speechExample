import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;


class SpeechToText extends StatefulWidget {
  const SpeechToText({super.key});

  @override
  State<SpeechToText> createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
  late speechToText.SpeechToText speech;
  String textString = "Press The Button";
  bool isListen = false;
  double confidence = 1.0;
  final Map<String, HighlightedWord> highlightWords = {
    "flutter": HighlightedWord(
        textStyle:
        TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
    "developer": HighlightedWord(
        textStyle:
        TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
  };

  void listen() async {
    if (!isListen) {
      print('Listening 1');
      bool avail = await speech.initialize();
      print('Testing: $avail');
      if (avail) {
        print('Listening 2');
        setState(() {
          isListen = true;
        });
        speech.listen(onResult: (value) {
          setState(() {
            textString = value.recognizedWords;
            print('Output: $textString');
            if (value.hasConfidenceRating && value.confidence > 0) {
              confidence = value.confidence;
            }
          });
        });
      }
    } else {
      print('Listening 3');
      setState(() {
        isListen = false;
      });
      speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    speech = speechToText.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech To Text"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: Text(
              "Confidence: ${(confidence * 100.0).toStringAsFixed(1)}%",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextHighlight(
              text: textString,
              words: highlightWords,
              textStyle: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      floatingActionButton: AvatarGlow(
        animate: isListen,
        glowColor: Colors.red,
        endRadius: 65.0,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          child: Icon(isListen ? Icons.mic : Icons.mic_none),
          onPressed: () {
            listen();
          },
        ),
      ),
    );
  }
}
