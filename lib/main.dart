//import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/layout/home_layout.dart';
//import 'package:todo/shared/components/components.dart';
//import 'package:todo/shared/cubit/bloc_observer.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Tasks',
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
        primarySwatch:Colors.blueGrey,
        //primaryColor: Colors.black,
       ),
      home:HomeScreen(),
    );
  }
}

