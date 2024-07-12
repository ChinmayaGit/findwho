import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:findwho/demo_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState() {
    super.initState();
    // getZone();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: authCheck()),
    );
  }
}