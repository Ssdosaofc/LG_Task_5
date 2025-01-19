import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_galaxy_task_5/Task%205/timeline_tile.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system,
    home: Task5(
    ),
  ));
}

class Task5 extends StatefulWidget {
  const Task5({super.key});

  @override
  State<Task5> createState() => _Task5State();
}

class _Task5State extends State<Task5> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode?Colors.grey[900]:Colors.white,
      appBar: AppBar(centerTitle:true,
        title: Text('Task 5',style: GoogleFonts.kanit(textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),),
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:
        ListView(
          children: [
            CustomTimelineTile(isFirst: true, isLast: false, isPast: true, text: 'Ordered',),
            CustomTimelineTile(isFirst: false, isLast: false, isPast: true, text: 'Under Process',),
            CustomTimelineTile(isFirst: false, isLast: false, isPast: false, text: 'Shipped',),
            CustomTimelineTile(isFirst: false, isLast: true, isPast: false, text: 'Delivered',),
          ],
        ),
      ),
    );
  }
}
