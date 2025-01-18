import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatelessWidget {
  final String text;
  final bool isPast;
  const EventCard({super.key,
    required this.text,
    required this.isPast
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black),)),
          Text(isPast? 'Completed':'In Progress'
              ,style: GoogleFonts.robotoCondensed(textStyle: TextStyle(color: isPast?Colors.blue:Colors.blueGrey))
          )
        ],
      ),
    );
  }
}
