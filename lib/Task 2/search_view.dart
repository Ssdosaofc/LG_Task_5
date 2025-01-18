import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchView extends StatefulWidget {
  final bool isVoiceEnabled;
  final List listOfImgs;
  SearchView({super.key,required this.isVoiceEnabled,required this.listOfImgs});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {


  final TextEditingController query = TextEditingController();
  late bool voiceEnabled;
  // late bool autofocus;
  late FocusNode textFieldFocusNode;

  late List listOfImgs;
  final ImagePicker picker = ImagePicker();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String onStatus='';

  Timer? _timer;
  ValueNotifier<double> listenable = ValueNotifier(0.0);

  final gemini = Gemini.instance;
  var _result = '';

  @override
  void initState() {
    super.initState();
    voiceEnabled = widget.isVoiceEnabled;
    // autofocus = voiceEnabled?false:true;
    textFieldFocusNode = FocusNode();
    if (voiceEnabled) {
      startAnimation();
      listen();
    }else{
      textFieldFocusNode.requestFocus();
    }
    listOfImgs = widget.listOfImgs.isNotEmpty ? widget.listOfImgs : [];

    print(String.fromEnvironment('apiKey'));
    print('voiceEnabled: $voiceEnabled');
    print('listOfImgs: $listOfImgs');
  }

  void animate() {
    if (voiceEnabled) {
      listenable.value = Random().nextDouble()*10;
    } else {
      listenable.value = 0.0;
    }
  }

  void startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      listenable.value += 0.01;
    });
  }
  void stopAnimation() {
    _timer?.cancel();
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
                query.text += _lastWords;
                if(_lastWords.isNotEmpty) {
                  if(mounted) {
                    _onSubmitQuestion(query.text,listOfImgs.isNotEmpty,listOfImgs);
                  }
                }
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

  bool _isLoading = false;

  Future<void>? _onSubmitQuestion(String val,
      bool withImg, images
      ) async {
    if(query.text.isNotEmpty)
    {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(Duration(milliseconds: 100));
      if (withImg) {
        gemini
            .textAndImage(
          text: val,
          images: images,
          generationConfig: GenerationConfig(
            temperature: 0.5,
            // maxOutputTokens: 512,
          ),
        )
            .then((value) {
          setState(() async {
            _result += value?.output ?? 'No result found';
            // print("Output: $value");
            if (mounted) {
              Navigator.pop(context, {
                'question': val,
                'answer': _result,
              });
            }
          });
        }).onError((e) {
          print('text generation exception: ${e!}');
        } as FutureOr<Null> Function(Object error, StackTrace stackTrace));
      } else {
        gemini
            .text(
          val,
          generationConfig: GenerationConfig(
            temperature: 0.5,
            // maxOutputTokens: 512,
          ),
        )
            .then((value) {
          setState(() {
            _result += value?.output ?? 'No result found';
            print("Output: $value");
            if (mounted) {
              Navigator.pop(context, {
                'question': val,
                'answer': _result,
              });
            }
          });
        }).onError((e) {
          print('text generation exception: ${e!}');
        } as FutureOr<Null> Function(Object error, StackTrace stackTrace));
      }
    }
  }



  @override
  void dispose() {
    stopAnimation();
    _speechToText.stop();
    textFieldFocusNode.dispose();
    listOfImgs.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      return SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.all(20),
              height: listOfImgs.isNotEmpty?(250+MediaQuery.of(context).size.height * 0.1):250,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  (listOfImgs.isNotEmpty)
                      ? Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    // create borders for the container
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // show the images in a horizontal list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listOfImgs.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(onPressed: (){
                              listOfImgs.remove(listOfImgs[index]);
                            }, icon: Icon(CupertinoIcons.xmark_circle_fill)),
                            Container(
                            alignment: Alignment.topRight,
                            margin: const EdgeInsets.all(10),
                            child: Image.memory(
                            listOfImgs[index],
                            width: 100,
                            height: 100,
                            ),
                          ),]
                        );
                      },
                    ),
                  )
                      : const SizedBox(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Expanded(
                    child: TextField(
                      // autofocus: autofocus,
                      focusNode: textFieldFocusNode,
                      maxLines: 5,
                      style: TextStyle(fontSize: 25,color: Colors.black),
                      textInputAction: TextInputAction.go,
                      controller: query,
                      keyboardType: TextInputType.text,
                      onSubmitted: (value){
                        _onSubmitQuestion(value, listOfImgs.isNotEmpty, listOfImgs);
                      },
                      onTap: (){
                        setState(() {
                          voiceEnabled = false;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Ask Gemini',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(),
                        if(voiceEnabled)
                          IconButton(onPressed: (){
                            setState(() {
                              listen();
                              stopAnimation();
                              // autofocus = true;
                            });
                            textFieldFocusNode.requestFocus();
                          }, icon: Icon(Icons.keyboard,size: 30,)),
                        SizedBox(width: 10),
                        voiceEnabled?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              // autofocus = false;
                              if(query.text.isEmpty) {
                                Navigator.pop(context);
                              }else{
                                listen();
                                setState(() {
                                  voiceEnabled = false;
                                });
                              }
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ValueListenableBuilder(
                              valueListenable: listenable,
                              builder: (BuildContext context, value, Widget? child) {
                                return AnimatedRotation(
                                  turns: value,
                                  duration: const Duration(milliseconds: 100),
                                  child: ClipPath(
                                    clipper: WavyCircleClipper(32),
                                    child: Container(
                                        width: 80, height: 80,
                                        color: Colors.blueAccent,
                                        child: Icon(Icons.mic,size: 30,color: Colors.blueAccent,),
                                ),
                              ),
                            );
                            },
                            ),
                              Icon(Icons.mic,size: 30,color: Colors.white,)
                            ]
                          ),
                        )
                            :IconButton(onPressed: (){
                          setState(() {
                            voiceEnabled = true;
                            // autofocus = false;
                            startAnimation();
                            listen();
                            _speechEnabled = true;
                          });
                        }, icon: Icon(Icons.mic,size: 30,)),
                        SizedBox(width: 10),
                        IconButton(onPressed: () async{
                          final images =
                          await picker.pickImage(source: ImageSource.gallery);
                          if (images != null) {
                            File(images.path).readAsBytes().then(
                                  (value) => setState(() {
                                listOfImgs.add(value);
                              }),
                            );
                          }
                        }, icon: Icon(Icons.camera_alt,size: 30)),
                        Spacer(),
                        IconButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                            await _onSubmitQuestion(query.text, listOfImgs.isNotEmpty, listOfImgs);
                          },
                          icon: _isLoading
                              ? Lottie
                              .asset(
                            'assets/anims/gemini.json',
                            width: 30,height: 30,repeat: true
                          )
                              : Icon(Icons.send, size: 30),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
      );
    });

  }
}
