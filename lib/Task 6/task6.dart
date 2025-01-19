import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_galaxy_task_5/Task%206/nav_item_model.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system,
    home: Task6(
    ),
  ));
}

class Task6 extends StatefulWidget {
  const Task6({super.key});

  @override
  State<Task6> createState() => _Task6State();
}

class _Task6State extends State<Task6> with TickerProviderStateMixin {
  int myIndex =0;

  List<SMIBool> riveIconInputs = [];
  int selectedNavIndex = 0;

  List<StateMachineController?> controllers = [];

  List<String> widgetList = ["Notification","Search","Home","Settings","Profile"];

  void riveOnInit(Artboard artboard, {required String stateMachineName}){
    StateMachineController? controller=
    StateMachineController.fromArtboard(artboard,stateMachineName);
    artboard.addController(controller!);
    controllers.add(controller);

    riveIconInputs.add(controller.findInput<bool>('active') as SMIBool);
  }

  void animateIcons(int index){
    riveIconInputs[index].change(true);
    Future.delayed(Duration(seconds: 1),(){
      riveIconInputs[index].change(false);
    }
    );
  }

  @override
  void dispose() {
    for(var controller in controllers){
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
        child:Scaffold(
          backgroundColor: isDarkMode?Colors.black:Colors.white,
          appBar: AppBar(centerTitle:true,
            title: Text('Task 6',style: GoogleFonts.kanit(textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),),
            backgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                )
            ),
          ),
          body: Center(child: Text(widgetList[selectedNavIndex],style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 70,
              margin: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                borderRadius: BorderRadius.all(Radius.circular(24)),
                boxShadow: [BoxShadow(
                  color: isDarkMode?Colors.grey.withOpacity(0.3):Colors.black.withOpacity(0.3),
                  offset: Offset(0, 10),
                  blurRadius: 20
                )]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(bottomNavItems.length,
                    (index) => GestureDetector(
                      onTap: (){
                         animateIcons(index);
                         setState(() {
                           selectedNavIndex = index;
                         });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBar(
                            isActive: selectedNavIndex== index,
                          ),
                          SizedBox(
                          height: 36, width: 36,
                          child: Opacity(
                            opacity: selectedNavIndex == index ? 1:0.5,
                            child: RiveAnimation.asset(
                                bottomNavItems[index].riveModel.src,
                              artboard: bottomNavItems[index].riveModel.artboard,
                              onInit: (artboard){
                                  riveOnInit(artboard,
                                      stateMachineName: bottomNavItems[index].riveModel.stateMachineName);
                              },
                            ),
                          ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ),
          ),
        ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(duration: Duration(milliseconds: 200,),
      margin: EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive? 20:0,
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
    );
  }
}

