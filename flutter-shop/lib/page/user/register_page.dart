//page/user/register_page.dart文件
import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/model/user_model.dart';
import 'package:flutter_shop/config/index.dart';
import 'package:flutter_shop/utils/router_util.dart';
import 'package:flutter_shop/component/show_message.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'package:flutter_shop/component/big_button.dart';
import 'package:flutter_shop/component/logo_container.dart';
import 'package:flutter_shop/component/item_text_field.dart';
//注册页面
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  //用户名文本编辑控制器
  TextEditingController _userNameController;
  //密码文本编辑控制器
  TextEditingController _pwdController;
  //手机号文本编辑控制器
  TextEditingController _emailController;
  //手机号文本编辑控制器
  TextEditingController _mobileController;
  //地址文本编辑控制器
  TextEditingController _addressController;
  //详细地址文本编辑控制器
  TextEditingController _addressDetailController;
  //省
  String _provinceId;
  //市
  String _cityId;
  //区
  String _areaId;
  //用户名焦点节点
  FocusNode _userNameNode = FocusNode();
  //邮箱焦点节点
  FocusNode _emailNode = FocusNode();
  //手机号焦点节点
  FocusNode _mobileNode = FocusNode();
  //密码焦点节点
  FocusNode _pwdNode = FocusNode();
  //地址焦点节点
  FocusNode _addressNode = FocusNode();
  //地址详情焦点节点
  FocusNode _addressDetailNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //实例化用户名控制器
    _userNameController = TextEditingController();
    //实例化密码控制器
    _pwdController = TextEditingController();
    //实例化邮箱控制器
    _emailController = TextEditingController();
    //实例化手机号控制器
    _mobileController = TextEditingController();
    //实例化地址控制器
    _addressController = TextEditingController();
    //实例化详细地址控制器
    _addressDetailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //注册页面
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KColor.PRIMARY_COLOR,
        elevation: 0,
        //注册标题
        title: Text(KString.REGISTER_TITLE),
        centerTitle: true,
      ),
      //可滚动视图
      body: SingleChildScrollView(
        //垂直布局
        child: Column(
          //水平居左对齐
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Logo展示
            LogoContainer(),
            SizedBox(
              height: 20,
            ),
            //注册输入框组件
            _registContent(context),
            //注册按钮
            KBigButton(
              text:KString.REGISTER_TITLE,
              //点击注册
              onPressed:(){
                if(_checkInput()){
                  this._register();
                }
            },),
          ],
        ),
      ),
    );
  }

  //注册内容
  Widget _registContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          //邮箱标题
          _itemTitle(KString.EMAIL),
          SizedBox(
            height: 10,
          ),
          //邮箱输入框
          ItemTextField(
            icon: Icon(Icons.email),
            controller: _emailController,
            focusNode: _emailNode,
            title: KString.EMAIL,
            hintText: KString.PLEASE_INPUT_EMAIL,
          ),
          SizedBox(height: 20.0),
          //用户名标题
          _itemTitle(KString.USERNAME),
          SizedBox(
            height: 10,
          ),
          //用户名输入框
          ItemTextField(
            icon: Icon(Icons.person),
            controller: _userNameController,
            focusNode: _userNameNode,
            title: KString.USERNAME,
            hintText: KString.PLEASE_INPUT_NAME,
          ),
          SizedBox(height: 20.0),
          //手机号标题
          _itemTitle(KString.MOBILE),
          SizedBox(
            height: 10,
          ),
          //手机号输入框
          ItemTextField(
            icon: Icon(Icons.phone),
            controller: _mobileController,
            focusNode: _mobileNode,
            title: KString.MOBILE,
            hintText: KString.PLEASE_INPUT_MOBILE,
          ),
          SizedBox(height: 20.0),
          //密码标题
          _itemTitle(KString.PASSWORD),
          SizedBox(
            height: 10,
          ),
          //密码输入框
          ItemTextField(
            icon: Icon(Icons.lock),
            controller: _pwdController,
            focusNode: _pwdNode,
            title: KString.PASSWORD,
            hintText: KString.PLEASE_INPUT_PWD,
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          //地址标题
          _itemTitle(KString.ADDRESS),
          SizedBox(
            height: 10,
          ),
          //地址输入框
          ItemTextField(
            icon: Icon(Icons.home),
            controller: _addressController,
            focusNode: _addressNode,
            title: KString.ADDRESS,
            hintText: KString.PLEASE_INPUT_ADDRESS,
            readonly: true,
            onPressed: () {
              this._showCityPicker(context);
            },
          ),
          SizedBox(height: 20.0),
          //地址标题
          _itemTitle(KString.ADDRESS_DETAIL),
          SizedBox(
            height: 10,
          ),
          //详细地址输入框
          ItemTextField(
            icon: Icon(Icons.home),
            controller: _addressDetailController,
            focusNode: _addressDetailNode,
            title: KString.ADDRESS_DETAIL,
            hintText: KString.PLEASE_INPUT_ADDRESS_DETAIL,
          ),
          SizedBox(height: 40.0),
        ],
      ),
    );
  }

  //自定义标题
  Widget _itemTitle(String title){
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      ),
    );
  }

  //检测输入框内容是否为空
  bool _checkInput(){
    if(_userNameController.text.length == 0){
      MessageWidget.show(KString.PLEASE_INPUT_NAME);
      return false;
    }
    else if (_pwdController.text.length == 0){
      MessageWidget.show(KString.PLEASE_INPUT_PWD);
      return false;
    }
    else if (_emailController.text.length == 0){
      MessageWidget.show(KString.PLEASE_INPUT_EMAIL);
      return false;
    }
    else if (_mobileController.text.length == 0){
      MessageWidget.show(KString.PLEASE_INPUT_MOBILE);
      return false;
    }
    else if (_addressController.text.length == 0){
      MessageWidget.show(KString.PLEASE_INPUT_ADDRESS);
      return false;
    }
    return true;
  }

  //注册
  _register() async {
    //注册参数
    var formData = {
      //用户名
      'username':_userNameController.text.toString(),
      //密码
      'password':_pwdController.text.toString(),
      //手机号
      'mobile':_mobileController.text.toString(),
      //邮箱
      'email':_emailController.text.toString(),
      //地址
      'address':'${_addressController.text.toString()}${_addressDetailController.text.toString()}',
      //省
      'provinceId': _provinceId,
      //市
      'cityId': _cityId,
      //区
      'areaId': _areaId,
    };
    //调用注册接口并传递参数
    var response = await HttpService.post(ApiUrl.USER_REGISTER,param:formData);
    //判断返回code值
    if(response['code'] == 0) {
      //将Json数据转换成用户数据模型
      UserModel model = UserModel.fromJson(response['data']);
      print(model.username);
//      //跳转至个人中心页面
//      RouterUtil.toMemberPage(context);
      //跳转到激活页面
      RouterUtil.toActivatePage(context);
      //弹出注册成功消息
      MessageWidget.show(KString.REGISTER_SUCCESS);
    }else{
      //弹出注册失败消息
      MessageWidget.show(response['message']);
    }
  }

  _showCityPicker(context) async {
    Result temp = await CityPickers.showCityPicker(
      context: context,
      locationCode: '320583',
      height: 400,
    );
    String city = "${temp.provinceName}${temp.cityName}${temp.areaName}";
    print(city);
    setState(() {
      this._addressController.text = city;
      this._provinceId = temp.provinceId;
      this._cityId = temp.cityId;
      this._areaId = temp.areaId;
    });
  }
}


