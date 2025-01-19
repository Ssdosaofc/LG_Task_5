import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({required this.text, required this.onPressed});
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(onPressed: (){
          onPressed();
        },
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(8),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {

              return Colors.black;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.grey;
              }
              return Colors.white;
            },
          ),
          overlayColor: MaterialStateProperty.all<Color>(Colors.amberAccent.withOpacity(0.5)), // Highlight color upon press
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(5)
          ),
        ),
        child: Padding(padding: EdgeInsets.all(5),
            child: Text(
                text,
                style: TextStyle(
                fontSize: 20,
                color: Colors.yellowAccent[800]
                ),
                ),
        )


        ),
    )
    );
  }
}
