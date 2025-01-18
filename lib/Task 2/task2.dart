import 'dart:io';

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

import 'code_wrapper.dart';

void main() {
  Gemini.init(
    apiKey:
    // const String.fromEnvironment('apiKey')
    String.fromEnvironment('apiKey'),
    enableDebugging: true,
  );
  runApp(
    MaterialApp(
      home: Task2(),
    )
  );
}



class Task2 extends StatefulWidget {

  const Task2({super.key});

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> {

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    codeWrapper(child, text, language) => CodeWrapperWidget(child, text, language);

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark?Colors.white:Colors.black,
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
                                  color: Colors.grey[400],
                                ),
                                width: (MediaQuery.of(context).size.width - 50),
                                padding: EdgeInsets.all(10),
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
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage('assets/images/gemini.png'),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                    padding: EdgeInsets.all(20),
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
                      ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => LinearGradient(colors: isDark
                          ? [Colors.pink.shade200, Colors.blue.shade400]
                          : [Colors.pink.shade300, Colors.blue.shade700]).createShader(
                        Rect.fromLTWH(5, 5, bounds.width, bounds.height),
                        ),
            child: Text(
              'Ask Gemini',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50,),
            ),
            ),
                    ),
                  ),
                ),
                Container(
                  height: 85,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: isDark?Colors.grey[300]!:Colors.grey)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: isDark?Colors.grey[300]!:Colors.grey, width: 2),
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
                                    style: TextStyle(fontSize: 15, color: isDark?Colors.grey[200]!:Colors.grey[400]),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(46),
                                color: isDark?Colors.grey[200]!:Colors.grey[400],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        bottomNav(true, []);
                                      });
                                    },
                                    icon: Icon(Icons.mic, size: 25,color: isDark?Colors.white:Colors.grey[900],),
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
                                    icon: Icon(Icons.camera_alt, size: 25),
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
