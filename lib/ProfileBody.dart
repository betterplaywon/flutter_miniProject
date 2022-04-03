import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'Store.dart';

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