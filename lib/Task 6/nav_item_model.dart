import 'package:liquid_galaxy_task_5/Task%206/rive_model.dart';

class NavItemModel{
  late final String title;
  late final RiveModel riveModel;

  NavItemModel({required this.title,required this.riveModel});
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(
    title: "Notification",
    riveModel: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity"),
  ),
  NavItemModel(
    title: "Search",
    riveModel: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SEARCH",
        stateMachineName: "SEARCH_Interactivity"),
  ),
  NavItemModel(
    title: "Home",
    riveModel: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity"),
  ),
  NavItemModel(
    title: "Settings",
    riveModel: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "SETTINGS",
        stateMachineName: "SETTINGS_Interactivity"),
  ),
  NavItemModel(
    title: "Profile",
    riveModel: RiveModel(
        src: "assets/RiveAssets/icons.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity"),
  ),

];