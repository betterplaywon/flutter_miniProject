import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'ProfileBody.dart';
import 'Store.dart';

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