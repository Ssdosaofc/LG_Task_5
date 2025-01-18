import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_galaxy_task_5/Task%205/event_card.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';


class CustomTimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String text;

  const CustomTimelineTile({super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(color: isPast? Colors.blue:Colors.blueGrey),
        indicatorStyle: IndicatorStyle(
          width: 30,
          color: isPast? Colors.blue:Colors.blueGrey,
          iconStyle: IconStyle(
              iconData: Icons.task_alt_outlined,
            color: isPast? Colors.white:Colors.blueGrey
          )
        ),
        endChild: EventCard(text: text,isPast: isPast,),
      ),
    );
  }
}


