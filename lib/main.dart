import 'package:flutter/material.dart';
// import 할 때 변수 중복 문제 피하기 위해 as로 지정
import './style.dart' as style;

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: MyApp()
      )
      );
    }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('Instagram Test'),
        actions: [IconButton(
         icon: Icon(Icons.add_box_outlined),
         onPressed: (){},
        )],
      ),
      body: Text('insta'),
    );
  }
}
