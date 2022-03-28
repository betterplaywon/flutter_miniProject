import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
// import 할 때 변수 중복 문제 피하기 위해 as로 지정
import './style.dart' as style;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (c) => Store(),
        child: MaterialApp(
          theme: style.theme,
          home: MyApp()
        ),
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

  saveData() async{
    var storage = await SharedPreferences.getInstance();
    //shared preferences를 통해 기존 데이터를 저장 가능.
    storage.setString('feedText','');
  }
  // 텍스트만 저장 가능하므로 cached_network_image 라이브러리 적용 필요.

    addMyData(){
      var myData = {
        'id': data.length,
        'image': userImage,
        'likes': 5,
        'date': 'July 25',
        'content': userContent,
        'liked': false,
        'user': 'John Kim'
      };
      setState(() {
        data.insert(0, myData);
      });

    }

    setUserContent(a){
      setState((){
        userContent = a;
      });
    }

  //react의 useEffect와 같은 역할인 initState문을 작성해 렌더링
  @override
  void initState() {
    super.initState();
    saveData();
    serverResponse();
  }

  addData(a){
    setState(() {
      data.add(a);
    });
  }

  //initState 내부에서는 async,await 처리가 안되어 server 데이터를 불러오는 함수 작성.
  serverResponse() async{
   var getData = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
   var decodeGetData = jsonDecode(getData.body);
setState(() {
  data = decodeGetData;
});
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
         MaterialPageRoute(builder: (c) => Upload(
             userImage: userImage,
             setUserContent: setUserContent,
         addMyData: addMyData))
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
         BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'home'),
         BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label: 'shopping'
         )
       ],
      ));
  }}


// 이미지 업로드 예시 Cunstom Widget 생성
class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(actions: [
          IconButton(onPressed: (){
            addMyData();
          }, icon: Icon(Icons.send))
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),
            Text('이미지업로드화면'),
            TextField(onChanged: (text){
              setUserContent(text);
              print(text);
              },),
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
        widget.data[i]['image'].runtimeType == String
          ? Image.network(widget.data[i]['image'])
            : Image.file(widget.data[i]['image']),

            GestureDetector(
                child: Text('date'),
            onTap: () {
                  Navigator.push(context,
               // page transition start
               PageRouteBuilder(
                   pageBuilder: (c, a1, a2) => Detail(),
                    transitionsBuilder: (c, a1, a2, child) =>
                        FadeTransition(opacity: a1, child: child),
                 transitionDuration: Duration(milliseconds: 500)
               )
                  );
            },
            ),
            // type error 발생. 문제 원인 찾아야함
            Text(widget.data[i]['content'])
          ]
        );
      });
    } else {
      return CircularProgressIndicator();
    }
  }
}

class Detail extends StatelessWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text(context.watch<Store>().name),),
      // profile창과 같은 화면을 구현할 때 CustomScrollView를 사용.
      body: CustomScrollView(
        slivers: [
         SliverToBoxAdapter(
           child: ProfileBody()
         ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (c, i) => Container(color: Colors.grey),
                childCount: 12
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)
          )
        ],
      )
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.circle),
            Text('팔로워 ${context.watch<Store>().follower}'),
          ],
        ),
        ElevatedButton(onPressed: (){
          context.read<Store>().changeName();
        }, child: Text('button'))
      ],
    );
  }
}


class Store extends ChangeNotifier {
  var name = 'kanxion';
  var follower = 0;
  changeName(){
    name = 'betterplaywon';
    // 재랜더링을 통해 변경된 데이터를 적용
    if(follower == 0) {
      follower++;
    } else if(follower != 0){
      follower--;
    }
    notifyListeners();
  }
}