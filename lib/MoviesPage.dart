import 'package:douban/Constant.dart';
import 'package:douban/movie_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';

class MoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MoviesPage();
  }
}

class _MoviesPage extends State<MoviesPage> {
  List data = List();

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      //滚动方向
      scrollDirection: Axis.vertical,
      //一行多少个
      crossAxisCount: 2,
      //条目宽高比
      childAspectRatio: 1,
      padding: const EdgeInsets.all(0.0),
      primary: false,
      //左右间隔
      crossAxisSpacing: 4.0,
      //上下间隔
      mainAxisSpacing: 5.0,
      children: _getListData(),
    );





//    return new ListView(
//      //滚动方向
//      scrollDirection: Axis.vertical,
//
//      children: _getListData(),
//    );


    return GridView.custom(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 10.0, crossAxisSpacing: 20.0, ),
        childrenDelegate: SliverChildBuilderDelegate((context, position) {
          return getItemWidget(data[position]);
        }, childCount: data.length));
  }

  Widget getItemContainer(String item) {
    return Container(
      width: 5.0,
      height: 5.0,
      alignment: Alignment.center,
      child: Text(
        item,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: Colors.blue,
    );
  }

  @override
  void initState() {
    _loadData();
  }

  _loadData() async {
    print("加载数据。。。");
    Dio dio = new Dio();
    Response response = await dio.get(Constant.GET_MOVIES, data: {
      "type": "movie",
      "tag": '热门',
      "sort": "recommend",
      "page_limit": 100,
      "page_start": 0
    });
    print(response.data);
    MovieBean bean = new MovieBean.fromJson(response.data);
    setState(() {
      data = bean.subjects;
    });



  }

  Widget getItemWidget(String url) {
    //BoxFit 可设置展示图片时 的填充方式
    return new Image(image: new NetworkImage(url), fit: BoxFit.cover);
  }

  _getListData() {
    List<Widget> widgets = [];

    for (int i = 0; i < data.length; i++) {
      Subjects subjects = data[i];
      widgets.add(getItemWidget(subjects.cover));



//      widgets.add(Text(data[i]));
    }

    return widgets;
  }



}
