import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../lg/LookAt.dart';
import '../lg/settings_page.dart';
import '../lg/ssh.dart';

bool connectionStatus = false;

void main(){
  runApp(
    MaterialApp(
      home: Task3(),
    )
  );
}

class Task3 extends StatefulWidget {
  const Task3({super.key});

  @override
  State<Task3> createState() => _Task3State();
}

class _Task3State extends State<Task3> {

  late Ssh ssh;

  @override
  void initState() {
    super.initState();
    ssh = Ssh();
    _connectToLG();
  }

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle:true,
        title: Text('Task 3',style: GoogleFonts.kanit(textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white))),
        backgroundColor:  Colors.grey[700],
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(
        //         bottom: Radius.circular(25),
        //     )
        // ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings,color: Colors.white,),
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())
              );
              _connectToLG();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(fit:BoxFit.fill,image: NetworkImage('https://thumbs.dreamstime.com/b/illustration-glowing-diwali-oil-lamps-diyas-intricate-floral-patterns-fiery-orange-red-hues-deep-blue-background-331828368.jpg'))
        ),
        child: Center(
          child: GestureDetector(
            onTap: () async {
              await ssh.sendKml('night_light',
                  LookAt(77.98635346770273, 22.24821926703745,0, '6000000', '0', '0'));
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.purple[800],
                borderRadius: BorderRadius. circular (12),
                boxShadow: [
                  BoxShadow (
                color: Colors.grey.shade500,
                offset: Offset (6, 6),
                blurRadius: 15, spreadRadius: 1,
              ),
                  BoxShadow (
                color: Colors.white, offset: Offset (-6, -6),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              ]
              ),
              child: Icon(Icons.send,color: Colors.grey[300],size: 40,),
            ),
          ),
        ),
      ),
    );
  }
}

