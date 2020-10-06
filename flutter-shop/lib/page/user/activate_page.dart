//激活页面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/call/call.dart';
import 'package:flutter_shop/call/notify.dart';
import 'package:flutter_shop/component/big_button.dart';
import 'package:flutter_shop/component/item_text_field.dart';
import 'package:flutter_shop/component/logo_container.dart';
import 'package:flutter_shop/component/show_message.dart';
import 'package:flutter_shop/config/api_url.dart';
import 'package:flutter_shop/config/color.dart';
import 'package:flutter_shop/config/string.dart';
import 'package:flutter_shop/model/user_model.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'package:flutter_shop/utils/router_util.dart';
import 'package:flutter_shop/utils/token_util.dart';

class ActivatePage extends StatefulWidget {
  @override
  _ActivatePageState createState() {
    return _ActivatePageState();
  }
}

class _ActivatePageState extends State<ActivatePage> {
  //用户名文本编辑控制器
  TextEditingController _activatedCodeController;
  //用户名焦点节点
  FocusNode _activatedNode = FocusNode();
  @override
  void initState() {
    super.initState();
    //实例化用户名控制器
    _activatedCodeController = TextEditingController();
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
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child:
              Column(
                children: [
                  //用户名输入框
                  ItemTextField(
                      icon:Icon(Icons.spellcheck),
                      controller:_activatedCodeController,
                      focusNode:_activatedNode,
                      title:KString.ACTIVATED_CODE,
                      hintText:KString.PLEASE_INPUT_ACTIVATED_CODE),
                  SizedBox(height: 20.0),
                  //登录按钮
                  KBigButton(
                    text:KString.ACTIVATE_TITLE,
                    //点击操作
                    onPressed:(){
                      //检测输入值
                      if(_checkInput()) {
                        this._activate();
                      }
                    },
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
  //检测输入框内容是否为空
  bool _checkInput() {
    if (_activatedCodeController.text.length == 0) {
      MessageWidget.show(KString.PLEASE_INPUT_ACTIVATED_CODE);
      return false;
    }
    return true;
  }
  //激活
  _activate() async {
    //读取本地用户信息
    var user = await TokenUtil.getUserInfo();
    //请求参数
    var param = {
      //用户Id
      'user_id':user['id'],
      //激活码
      'activated_code': this._activatedCodeController.text.toString(),
    };

    //调用激活接口并传递参数
    var response = await HttpService.post(ApiUrl.USER_ACTIVATE,param:param);
    //判断返回code值
    if(response['code'] == 0) {
      //将Json数据转换成用户数据模型
      UserModel model = UserModel.fromJson(response['data']);
      print(model.username);
      //保存登录用户信息
      await TokenUtil.saveLoginInfo(model);
      //定义登录成功消息
      var data = {
        //用户名
        'username':model.username,
        //是否登录
        'isLogin':true,
      };
      //派发登录成功消息
      Call.dispatch(Notify.LOGIN_STATUS, data: data);
      //跳转到激活页面
      RouterUtil.toMainPage(context, 3);
    }
    MessageWidget.show(response['message']);
  }
}