import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    home: Task1(),
  ));
}

class Task1 extends StatefulWidget {
  const Task1({super.key});

  @override
  State<Task1> createState() => _Task1State();
}

class _Task1State extends State<Task1> with TickerProviderStateMixin{
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          appBar: AppBar(centerTitle:true,
            title: Text('Task 7',style: GoogleFonts.kanit(textStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),),
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              )
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    child: TabBar(
                        controller: _tabController,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        labelPadding: EdgeInsets.only(left: 20,right: 20),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey[300],
                        indicator: CircleTabIndicator(color: Colors.grey, radius: 3),
                        tabs: [
                          Tab(text: "Home"),
                          Tab(text: "Maps"),
                          Tab(icon: Icon(Icons.person)),
                          Tab(icon: Icon(Icons.star))
                        ]),
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: TabBarView(
                        controller: _tabController,
                        children: [
                          Center(child: Text("Home",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),),
                          Center(child: Text("Maps",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold))),
                          Center(child: Text("Profile",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold))),
                          Center(child: Text("Starred",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),)),
                        ]),
                  )
                ],
              ),
            ),
        ),
        );


  }
}

class CircleTabIndicator extends Decoration {

  final Color? color;
  double radius;

  CircleTabIndicator({required this.color,required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color:color,radius:radius );
  }
}

class _CirclePainter extends BoxPainter {

  final Color? color;
  double radius;

  _CirclePainter({required this.color,required this.radius});
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint paint;
    paint = Paint()..color = color!;
    paint = paint..isAntiAlias = true;
    final Offset circleOffset = offset + Offset(cfg.size!.width/2,cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
