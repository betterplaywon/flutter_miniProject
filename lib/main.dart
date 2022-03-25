import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 할 때 변수 중복 문제 피하기 위해 as로 지정
import './style.dart' as style;
//scroll control에 유용한 library
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  var tab = 0;
  var data = [];
  var userImage;
  var userContent;

  addPostData () {
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'March 25',
      'content': userContent,
      'liked': false,
      'user': 'John K'
    };
    setState((){
      data.insert(0, myData);
    });
  }


setUserContent(a){
  setState(() {
    userContent = a;
  });
}


  //initState 내부에서는 async,await 처리가 안되어 server 데이터를 불러오는 함수 작성.
  serverResponse() async{
   var getData = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
   var decodeGetData = jsonDecode(getData.body);
setState(() {
  data = decodeGetData;
});
   if(getData.statusCode == 200) {
     print(decodeGetData);
   } else {
     // 예외 처리
    throw Exception('Some other exception.');
   }
  }

  addData(ele){
    setState(() {
      data.add(ele);
    });
  }

  //react의 useEffect와 같은 역할인 initState문을 작성해 렌더링
  @override
  void initState() {
    super.initState();
    serverResponse();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text('Developause life'),
        actions: [IconButton(
         icon: Icon(Icons.add_box_outlined),
         onPressed: () async{
           var picker = ImagePicker();
           var image = await picker.pickImage(source: ImageSource.gallery);
         if(image != null) {
           setState(() {
             userImage = File(image.path);
           });
         }

           Navigator.push(context,
         MaterialPageRoute(builder: (context) => Upload(userImage : userImage,
             addPostData : addPostData))
         );
         },
        )],
      ),
      body: [Home(data : data, addData : addData),Text('data')][tab],
      bottomNavigationBar: BottomNavigationBar(
        //ontab의 매개변수를 index로 활용한 페이지 전환
        onTap: (ele){ setState(() {
          tab = ele;
        }); },
       items: <BottomNavigationBarItem>[
         BottomNavigationBarItem(
             icon: Icon(Icons.home_outlined),label: 'home'),
         BottomNavigationBarItem(
           icon: Icon(Icons.shopping_bag_outlined),label: 'shopping'
         )
       ],
      )
    );
  }
}

// 이미지 업로드 예시 Cunstom Widget 생성
class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addPostData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addPostData;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(onPressed: (){addPostData();}, icon: Icon(Icons.send))
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),
            Text('이미지업로드화면'),
            TextField(onChanged: (text){
              setUserContent(text);
            },),
            TextField(),
            IconButton(
                onPressed: (){Navigator.pop(context);},
                icon: Icon(Icons.close)
            ),
          ],
        )
    );

  }
}

class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.addData}) : super(key: key);

  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  addResponseData() async{
    var secondGetData =await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var decodingAddData = jsonDecode(secondGetData.body);
    widget.addData(decodingAddData);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        addResponseData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // isNotEmpty 메서드를 사용해 데이터가 존재할 때를 표기
    if(widget.data.isNotEmpty){
      return ListView.builder(itemCount:widget.data.length, controller: scroll, itemBuilder: (ele, i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        Image.network(widget.data[i]['image']
            ),
            Text('금요일'),
            Text('me'),
            Text(widget.data[i]['content'])
          ],
        );
      });
    } else {
      return CircularProgressIndicator();
    }
  }
}

