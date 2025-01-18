import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> searchOnGoogle(String query, BuildContext context) async {

  if (query.isNotEmpty) {
    final encodedQuery = Uri.encodeComponent(query);
    final url = 'https://www.google.com/search?q=$encodedQuery';

    // if (await canLaunchUrl(Uri(scheme: 'https://www.google.com',query: encodedQuery))) {
    //   await launchUrl(Uri(scheme: 'https://www.google.com',query: encodedQuery));
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch $url");
      Fluttertoast.showToast(
        msg: "Could not launch $url",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,);
    }
    Navigator.pop(context);
  }
}