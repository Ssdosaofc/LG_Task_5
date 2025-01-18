import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../lg/LookAt.dart';
import '../lg/settings_page.dart';
import '../lg/ssh.dart';

bool connectionStatus = false;

void main(){
  runApp(
      MaterialApp(
        home: Task4(),
      )
  );
}

class Task4 extends StatefulWidget {
  const Task4({super.key});

  @override
  State<Task4> createState() => _Task4State();
}

class _Task4State extends State<Task4> {

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
        title: Text('Task 4',style: GoogleFonts.kanit(textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white))),
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
            image: DecorationImage(fit:BoxFit.cover,image:
            NetworkImage(
                'https://w0.peakpx.com/wallpaper/901/533/HD-wallpaper-digital-blender-3d-abstract-cube-light-effects-3d-3d-blocks-render-cgi-digital-art-abstract.jpg'
            )
            )
        ),
        child: Center(
          child: GestureDetector(
            onTap: () async {
              await ssh.sendKml('pagoda',
                  LookAt(85.83966187069345, 20.19248968213565,0, '170', '60', '2.413128862767669e-05'));
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
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
              child: Icon(Icons.send,color: Colors.grey,size: 40,),
            ),
          ),
        ),
      ),
    );
  }
}
