import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_galaxy_task_5/Task%202/search_view.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/container/list.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/blocks/leaf/paragraph.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:morphable_shape/morphable_shape.dart';

import 'code_wrapper.dart';

void main() {
  Gemini.init(
    apiKey:
    const String.fromEnvironment('apiKey'),
    enableDebugging: true,
  );
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Task2(),
    )
  );
}



class Task2 extends StatefulWidget {

  const Task2({super.key});

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> with TickerProviderStateMixin{

  var question = '';
  var answer = '';

  final ImagePicker picker = ImagePicker();
  var listOfImgs = [];

  void bottomNav(bool isVoiceEnabled, List listOfImgs) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SearchView(
          isVoiceEnabled: isVoiceEnabled,
          listOfImgs: listOfImgs,
        );
      },
    );

    if (result != null && result is Map) {
      setState(() {
        question = result['question'] ?? '';
        answer = result['answer'] ?? '';
        print(question);
        print(answer);
      });
    }
  }

  final starShapes = [
    StarShapeBorder(
      corners: 6,
      inset: 11.6953125.toPercentLength,
      cornerRadius: (231.2508167053851 * 0.1667).toPXLength,
      insetRadius: 0.toPXLength,
      cornerStyle: CornerStyle.rounded,
      insetStyle: CornerStyle.rounded,
    ),
    StarShapeBorder(
      corners: 6,
      inset: 12.6.toPercentLength,
      cornerRadius: (60 * 0.1667).toPXLength,
      insetRadius: (160 * 0.1667).toPXLength,
      cornerStyle: CornerStyle.rounded,
      insetStyle: CornerStyle.rounded,
    ),
    StarShapeBorder(
      corners: 6,
      inset: 26.406250000000075.toPercentLength,
      cornerRadius: (0 * 0.1667).toPXLength,
      insetRadius: (0 * 0.1667).toPXLength,
      cornerStyle: CornerStyle.rounded,
      insetStyle: CornerStyle.rounded,
    ),
    StarShapeBorder(
      corners: 6,
      inset: 30.44002474993097.toPercentLength,
      cornerRadius: (86.54205560062454 * 0.1667).toPXLength,
      insetRadius: (55.23216904049404 * 0.1667).toPXLength,
      cornerStyle: CornerStyle.rounded,
      insetStyle: CornerStyle.rounded,
    ),
    StarShapeBorder(
      corners: 6,
      inset: 30.toPercentLength,
      cornerRadius: (206.3 * 0.1667).toPXLength,
      insetRadius: (5.7 * 0.1667).toPXLength,
      cornerStyle: CornerStyle.rounded,
      insetStyle: CornerStyle.rounded,
    ),
  ];


  late AnimationController _controller;
  late Animation _progressAnimation;
  late MorphableShapeBorderTween _shapeTween;
  int _currentIndex = 0;


  void _setNextTween() {
    final beginShape = starShapes[_currentIndex];
    final endShape = starShapes[(_currentIndex + 1) % starShapes.length];
    _shapeTween = MorphableShapeBorderTween(begin: beginShape, end: endShape);
  }

  Timer? _timer;
  ValueNotifier<double> listenable = ValueNotifier(0.0);

  bool onHover = false;
  bool hasZoomed = false;
  late Animation _scaleAnimation;
  late AnimationController _scaleController;
  late Animation _rotateAnimation;
  late AnimationController _rotateController;
  late AnimationController _gradientController;
  late Animation<Alignment> _topAnim;
  late Animation<Alignment> _bottomAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      reverseDuration: Duration(milliseconds: 500)
    );
    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      reverseDuration: Duration(milliseconds: 500)
    );
    _gradientController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    _progressAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
    _scaleAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut, reverseCurve: Curves.easeInOut));
    _rotateAnimation = Tween(begin: 0.0, end: 360.0)
        .animate(CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut, reverseCurve: Curves.easeInOut));

    _topAnim = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topLeft,end: Alignment.topRight),
          weight: 1
      ),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topRight,end: Alignment.bottomRight),
          weight: 1
      ),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomRight,end: Alignment.bottomLeft),
          weight: 1
      ),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomLeft,end: Alignment.topLeft),
          weight: 1
      ),
    ]).animate(_gradientController);
    _bottomAnim = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomRight,end: Alignment.bottomLeft),
          weight: 1
      ),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.bottomLeft,end: Alignment.topLeft),
          weight: 1
      ),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topLeft,end: Alignment.topRight),
          weight: 1
      ),
      TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(begin: Alignment.topRight,end: Alignment.bottomRight),
          weight: 1
      ),
    ]).animate(_gradientController);

    _gradientController.repeat();

    _setNextTween();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % starShapes.length;
          _setNextTween();
        });
        _controller.forward(from: 0);
      }
    });

    _controller.forward();

    listenable.value = Random().nextDouble()*10;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      listenable.value += 0.01;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    codeWrapper(child, text, language) => CodeWrapperWidget(child, text, language);

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark?Colors.black:Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Task 2',
            style: GoogleFonts.kanit(
              textStyle: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          backgroundColor: Colors.grey[700],
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.cleaning_services,color: Colors.white,size: 20,),
              onPressed: () {
                setState(() {
                  question = '';
                  answer = '';
                });
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SizedBox(height: 10,),
                Expanded(
                  child: (question.isNotEmpty && answer.isNotEmpty) ?SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                  color: Colors.grey[600],
                                ),
                                width: (MediaQuery.of(context).size.width - 50),
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: MarkdownWidget(
                                  data: question,
                                  config: config.copy(
                                    configs: [
                                      isDark
                                          ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
                                          : const PreConfig().copy(wrapper: codeWrapper),
                                      const PConfig(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      ListConfig(
                                        marker: (isOrdered, depth, index) {
                                          return Container(
                                            margin: EdgeInsets.only(left: 10 * depth.toDouble()),
                                            child: Text(
                                              isOrdered ? '${index + 1}.' : '•',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  selectable: true,
                                  shrinkWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark?Colors.black:Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage('assets/images/gemini.png'),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  SizedBox(height: 15,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                      color: Colors.blue[400],
                                    ),
                                    width: (MediaQuery.of(context).size.width - 100),
                                    child: MarkdownWidget(
                                      data: answer,
                                      config: config.copy(
                                        configs: [
                                          isDark
                                              ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
                                              : const PreConfig().copy(wrapper: codeWrapper),
                                          const PConfig(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          ListConfig(
                                            marker: (isOrdered, depth, index) {
                                              return Container(
                                                margin: EdgeInsets.only(left: 10 * depth.toDouble()),
                                                child: Text(
                                                  isOrdered ? '${index + 1}.' : '•',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      selectable: true,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                      ],
                    ),
                  ):Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child:
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: _topAnim.value,
                                    end: _bottomAnim.value,
                                    colors:
                                    [Colors.purpleAccent,Colors.blueAccent,],
                                    stops: [0.4,0.6]
                                ).createShader(
                                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                                ),
                                child:AnimatedBuilder(
                                  animation: _scaleAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _scaleAnimation.value,
                                      child: ValueListenableBuilder(
                                        valueListenable: listenable,
                                        builder: (BuildContext context, value, Widget? child) {
                                          return AnimatedRotation(
                                            turns: value,
                                            duration: const Duration(milliseconds: 100),
                                            child:
                                                // Text(
                                                //   'Ask Gemini',
                                                //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50,),
                                                // ),
                                                AnimatedBuilder(animation: _progressAnimation,
                                                    builder: (context, child){
                                                      double t = _progressAnimation.value;
                                                      return Center(
                                                          child: DecoratedShadowedShape(
                                                            decoration:
                                                            BoxDecoration(color: Colors.amberAccent),
                                                            shape: _shapeTween.lerp(t),
                                                            child: SizedBox(
                                                              width: 100,
                                                              height: 100,
                                                            ),
                                                          ));
                                                    })
                                            );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          ),
                          MouseRegion(
                            onEnter: (e){
                              setState(() {
                                onHover = true;
                                _scaleController.forward();
                                _rotateController.forward();
                              });
                            },
                            onExit: (e){
                              setState(() {
                                _scaleController.reverse();
                                _rotateController.reverse();
                                onHover = false;
                              });
                            },
                            child: AnimatedBuilder(
                                animation: _rotateAnimation,
                              builder: (BuildContext context, Widget? child) {
                                  return Transform.rotate(angle: _rotateAnimation.value * pi / 360,
                                    child:  Image(width:45,height:45,image: AssetImage('assets/images/gemini.png'),
                                      color: onHover?Colors.white:(!isDark?Colors.black:Colors.white),),
                                  );
                              },

                            )
                          ),
                          //

                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 85,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: isDark?Colors.grey[600]!:Colors.grey)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: isDark?Colors.grey[500]!:Colors.grey, width: 2),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    bottomNav(false, []);
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Ask Gemini',
                                    style: TextStyle(fontSize: 15, color: isDark?Colors.grey[500]!:Colors.grey[400]),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(46),
                                color: isDark?Colors.grey[700]!:Colors.grey[300],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        bottomNav(true, []);
                                      });
                                    },
                                    icon: Icon(Icons.mic, size: 25,color: isDark?Colors.grey[400]:Colors.grey[800],),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final images = await picker.pickImage(source: ImageSource.camera);
                                      if (images != null) {
                                        File(images.path).readAsBytes().then(
                                              (value) => setState(() {
                                            listOfImgs.add(value);
                                            setState(() {
                                              bottomNav(false, listOfImgs);
                                            });
                                          }),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.camera_alt, size: 25,color: isDark?Colors.grey[400]:Colors.grey[800],),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}


