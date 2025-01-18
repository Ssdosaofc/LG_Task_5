import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_galaxy_task_5/Task%201/bottom_sheet.dart';
import 'package:liquid_galaxy_task_5/Task%201/search_on_google.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

class TextSheet extends StatefulWidget {
  const TextSheet({super.key});

  @override
  State<TextSheet> createState() => _TextSheetState();
}

class _TextSheetState extends State<TextSheet> {

  final TextEditingController query = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: true,
          child: Container(
              height: 70,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          color: isDark?Colors.grey[900]:Colors.white,
          ),
          child: Row(
            children: [
              Image.asset('assets/images/img.png',height: 20,width: 20,),
              SizedBox(width: 10,),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    style: TextStyle(fontSize: 18,color: isDark?Colors.white:Colors.black),
                    textInputAction: TextInputAction.go,
                    controller: query,
                    keyboardType: TextInputType.text,
                    onSubmitted: (value){
                      searchOnGoogle(value,context);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                    ),
                )
                ),
              ),
              TextButton(onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(context: context, builder: (BuildContext context){
                  return BottomSheetDialog();
                });
              },
              child: Image.asset('assets/images/Google_mic.svg.png',height: 20,width: 20))
            ],
          )
          ),
        );
      }
    );
  }
}
