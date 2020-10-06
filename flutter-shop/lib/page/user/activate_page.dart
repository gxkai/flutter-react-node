//激活页面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/component/logo_container.dart';
import 'package:flutter_shop/config/color.dart';
import 'package:flutter_shop/config/string.dart';

class ActivatePage extends StatefulWidget {
  @override
  _ActivatePageState createState() {
    return _ActivatePageState();
  }
}

class _ActivatePageState extends State<ActivatePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //登录标题
      appBar: AppBar(
        backgroundColor: KColor.PRIMARY_COLOR,
        elevation: 0,
        title: Text(KString.ACTIVATE_TITLE),
        centerTitle: true,
      ),
      //滚动视图
      body: SingleChildScrollView(
        //垂直布局
        child: Column(
          //水平方向左对齐
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //登录Logo
            LogoContainer(),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}