import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.blue),
          appBarTheme: AppBarTheme(color: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black),
              actionsIconTheme: IconThemeData(color: Colors.black)
          ),

        ),
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
          title: Text('Instagram'),
        actions: [IconButton(
         icon: Icon(Icons.add_box_outlined),
         onPressed: (){},
        )],
      ),
      body: Text('insta'),
    );
  }
}
