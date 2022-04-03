import 'package:flutter/material.dart';

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