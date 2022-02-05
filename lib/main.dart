import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 할 때 변수 중복 문제 피하기 위해 as로 지정
import './style.dart' as style;
import './Home.dart';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: MyApp()
      )
      );
    }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  //현재 tab의 state 저장
  var tab = 0;
var responseHomeData = [];
  //initState 내부에서는 async,await 처리가 안되어 server 데이터를 불러오는 함수 작성.
  serverResponse() async{
   var getData = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
   var decodeGetData = jsonDecode(getData.body);

   if(getData.statusCode == 200) {
     print(decodeGetData);
   } else {
     // 예외 처리
    throw Exception('Some other exception.');
   }
  }

  //react의 useEffect와 같은 역할인 initState문을 작성해 렌더링
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serverResponse();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('Daily Dairy'),
        actions: [IconButton(
         icon: Icon(Icons.add_box_outlined),
         onPressed: (){},
        )],
      ),
      body: [Home(),Text('data')][tab],
      bottomNavigationBar: BottomNavigationBar(
        //ontab의 매개변수를 index로 활용한 페이지 전환
        onTap: (ele){ setState(() {
          tab = ele;
        }); },
       items: <BottomNavigationBarItem>[
         BottomNavigationBarItem(
             icon: Icon(Icons.home_outlined),label: 'home'),
         BottomNavigationBarItem(
           icon: Icon(Icons.shopping_bag_outlined),label: 'shpping'
         )
       ],
      )
    );
  }
}
