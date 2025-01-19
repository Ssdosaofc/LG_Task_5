import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../lg/LookAt.dart';
import '../lg/button.dart';
import '../lg/connection_flag.dart';
import '../lg/settings_page.dart';
import '../lg/ssh.dart';

bool connectionStatus = false;

void main() {
  runApp(MaterialApp(
    home: Home(
    ),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Ssh ssh;
  int selectedOption = 0;

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
        appBar: AppBar(title: Text("LG Demo App",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          backgroundColor: Colors.indigo,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings,color: Colors.white,),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())
                );
                // await Navigator.pushNamed(context, '/settings');
                _connectToLG();
              },
            ),
          ],
        ),
        body:  Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: ConnectionFlag(
                      status: connectionStatus,
                    )
                ),
                Padding(padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Button(onPressed:  () async {
                        await ssh.sendKml('night_light',
                            LookAt(77.98635346770273, 22.24821926703745,0, '6000000', '0', '0'));
                                              },
                          text: "Task 3"),
                      SizedBox(height: 20,),
                      Button(onPressed:  () async {
                        await ssh.sendKml('pagoda',
                            LookAt(85.83966187069345, 20.19248968213565,0, '170', '60', '2.413128862767669e-05'));
                       },
                          text: "Task 4"),
                      SizedBox(height: 50,),
                      // SizedBox(height: 20,),
                      Button(onPressed:  () async {
                        await ssh.clearKml();
                      }, text: "Clear KML"),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}



