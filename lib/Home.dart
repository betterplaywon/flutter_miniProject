import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount:3, itemBuilder: (ele, i){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network('https://aws1.discourse-cdn.com/auth0/original/2X/c/cc8e03e6ceb862b620c6a71ce6c76e8afac5736d.png'),
          Text('금요일'),
          Text('me'),
          Text('술마심')
        ],
      );
    });
  }
}
