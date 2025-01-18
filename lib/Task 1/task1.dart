import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_galaxy_task_5/Task%201/bottom_sheet.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main(){
  runApp(
    MaterialApp(
      home: Task1(),
    )
  );
}

class Task1 extends StatefulWidget {
  const Task1({super.key});

  @override
  State<Task1> createState() => _Task1State();
}

class _Task1State extends State<Task1> {


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark?Colors.grey[900]:Colors.white,
      appBar: AppBar(centerTitle:true,
        title: Text('Task 1',style: GoogleFonts.kanit(textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),),
        backgroundColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            )
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(10)
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {

                return isDark?Colors.grey[700]:Colors.white;
                }
                ),
                ),
                  onPressed: (){
                showModalBottomSheet(context: context, builder: (BuildContext context){
                  return BottomSheetDialog();
                });
              }, child: Padding(padding: EdgeInsets.all(0.5),
              child: Image.asset('assets/images/Google_mic.svg.png'))),
            ),
            SizedBox(height: 15,),
            Text('Tap the microphone',style: TextStyle(fontSize: 20,color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
