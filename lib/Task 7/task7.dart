import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system,
    home: Task7(),
  ));
}

class Task7 extends StatefulWidget {
  const Task7({super.key});

  @override
  State<Task7> createState() => _Task7State();
}

class _Task7State extends State<Task7> with TickerProviderStateMixin {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Task 7',
            style: GoogleFonts.kanit(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white ,
              ),
            ),
          ),
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
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
                  labelPadding: EdgeInsets.only(left: 20, right: 20),
                  labelColor: isDarkMode ? Colors.white : Colors.black,
                  unselectedLabelColor:
                  isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  // indicator: CircleTabIndicator(
                  //   color: isDarkMode ? Colors.white : Colors.grey,
                  //   radius: 3,
                  // ),
                  indicatorColor: isDarkMode ? Colors.white : Colors.black,
                  tabs: [
                    Tab(text: "Home"),
                    Tab(text: "Maps"),
                    Tab(icon: Icon(Icons.person)),
                    Tab(icon: Icon(Icons.star)),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(
                      child: Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Maps",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Starred",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CircleTabIndicator extends Decoration {
//   final Color? color;
//   double radius;
//
//   CircleTabIndicator({required this.color, required this.radius});
//   @override
//   BoxPainter createBoxPainter([VoidCallback? onChanged]) {
//     return _CirclePainter(color: color, radius: radius);
//   }
// }
//
// class _CirclePainter extends BoxPainter {
//   final Color? color;
//   double radius;
//
//   _CirclePainter({required this.color, required this.radius});
//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
//     final paint = Paint()..color = color!..isAntiAlias = true;
//     final Offset circleOffset =
//         offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
//     canvas.drawCircle(circleOffset, radius, paint);
//   }
// }
