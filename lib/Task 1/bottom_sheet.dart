import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_galaxy_task_5/Task%201/search_on_google.dart';
import 'package:liquid_galaxy_task_5/Task%201/text_sheet.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetDialog extends StatefulWidget {
  const BottomSheetDialog({super.key});

  @override
  State<BottomSheetDialog> createState() => _BottomSheetDialogState();
}

class _BottomSheetDialogState extends State<BottomSheetDialog> {

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late String onStatus;

  final int boxCount = 4;
  final double totalWidth = 300.0;
  List<double> boxWidths = [];
  Timer? animationTimer;

  @override
  void initState() {
    super.initState();
    boxWidths = List.filled(boxCount, totalWidth / boxCount);
    listen();
    startPeriodicAnimation();

  }
  
  @override
  void dispose() {
    onStatus = '';
    if (_speechToText.isListening) {
      stopListening();
    }
    super.dispose();
  }


  void listen() async {
    if (!_speechEnabled) {
      bool available = await _speechToText.initialize(
        onStatus: (val) {
          setState(() {
            print('onStatus: $val');
            onStatus = val;
          });

        },
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() {
          _speechEnabled = true;
        });
        _speechToText.listen(
          onResult: (val) {
            setState(() {
              _lastWords = val.recognizedWords;
              print(_lastWords);

              if (val.finalResult) {
                searchOnGoogle(_lastWords, context);
              }
            });
          },
        );
      }
    } else {
      setState(() {
        _speechEnabled = false;
        _speechToText.stop();
      });
    }
  }

  void stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void randomizeWidths() {
    Random random = Random();
    List<double> randomWidths = List.generate(boxCount, (index) => random.nextDouble());
    double totalRandomValue = randomWidths.reduce((a, b) => a + b);

    // Normalize the widths to maintain the total width
    setState(() {
      boxWidths = randomWidths.map((value) => (value / totalRandomValue) * totalWidth).toList();
    });
  }

  void startPeriodicAnimation() {
    animationTimer = Timer.periodic(const Duration(milliseconds: 1), (_) {
      randomizeWidths();
    });
  }

  // void onSpeechResult(SpeechRecognitionResult result) {
  //   debugPrint('Recognized words: ${result.recognizedWords}');
  //   setState(() {
  //     _lastWords = result.recognizedWords;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 280,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        color: isDark?Colors.grey[900]:Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: 15,),
          Container(
            height: 5,
            width: 80,
            decoration: BoxDecoration(
              color: isDark?Colors.white:Colors.black,
              borderRadius: BorderRadius.circular(5)
            ),
          ),
          SizedBox(height: 30,),
          Image(image: AssetImage('assets/images/img.png'),height: 50,width: 50,),
          SizedBox(height: 20,),
          Text(
              _lastWords.isNotEmpty
                  ? _lastWords
                  : (_speechEnabled ? 'Listening...' : 'Not available in your Device'),
              style: TextStyle(color: isDark?Colors.white:Colors.black,fontSize: 25,),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60,),
          // if (onStatus == 'done')
          //   Text(
          //     'Tap on mic to speak again',
          //     style: TextStyle(color: Colors.white, fontSize: 15),
          //   ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(context: context, builder: (BuildContext context){
                  return TextSheet();
                });
              },
              child: Icon(Icons.keyboard,color: Colors.grey[700],size: 30,)),
              SizedBox(width: 10,)
            ],
          ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(boxCount, (index) {
              return AnimatedContainer(
                decoration: BoxDecoration(
                  color: _getBoxColor(index),
                  boxShadow: [
                    BoxShadow(
                      color: _getBoxColor(index).withOpacity(0.8),
                      blurRadius: 8.0,
                      spreadRadius: 6.0,
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 400),
                width: boxWidths[index],
                height: 5, // Fixed height
                // margin: const EdgeInsets.all(4.0),
              );
            }),
          )
          )],
      ),
    );
  }

  Color _getBoxColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
