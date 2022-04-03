import 'package:flutter/material.dart';

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
    // state가 변화 적용
    notifyListeners();
  }
}