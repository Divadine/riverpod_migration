import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riverpod_learning/features/image360/screen/shared_3d_view_widget.dart';
import 'package:riverpod_learning/pratice_screen.dart';
import 'package:riverpod_learning/shared_widgets/app_icon_widget.dart';
import 'package:riverpod_learning/shared_widgets/app_text_field.dart';
import 'package:riverpod_learning/shared_widgets/asset_images.dart';
import 'package:riverpod_learning/shared_widgets/text_box_normal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers.dart';
import 'features/auth/screens/auth_gate.dart';
import 'features/authentication/screen/login_screen.dart';
import 'shared_widgets/submit_button.dart';
import 'features/car_filter_search/screen/car_search_screen.dart';
import 'features/cars/screen/car_home_screen.dart';
import 'features/cars/screen/popular_models_page.dart';
import 'features/chips/screen/chips_screen.dart';
import 'features/image360/screen/car_360_screen.dart';
import 'features/reels/screens/reels_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
    child: MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home:LoginScreen(),
      //BrandPickerScreen()//CarHomeScreen() //Scaffold(body: App3DViewer(src: 'assets/demo_3d_obj/ironman.glb',),),//CarSearchScreen()//ReelsScreen(),//Car360Screen(),
    ),
  ));
}