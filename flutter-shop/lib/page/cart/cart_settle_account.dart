//page/cart/cart_settle_account.dart文件
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/call/call.dart';
import 'package:flutter_shop/call/notify.dart';
import 'package:flutter_shop/config/index.dart';
import 'package:flutter_shop/model/cart_model.dart';
import 'package:flutter_shop/data/data_center.dart';
import 'package:flutter_shop/service/http_service.dart';
import 'package:flutter_shop/utils/router_util.dart';
import 'package:flutter_shop/component/circle_check_box.dart';
import 'package:flutter_shop/component/small_button.dart';

//购物结算组件
class CartSettleAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //容器
    return Container(
      margin: EdgeInsets.all(5.0),
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      //水平布局
      child: Row(
        children: <Widget>[
          //全选复选框
          _allCheckBox(context),
          //总价容器
          _allPriceContainer(context),
          //结算按钮
          _settleButton(context),
        ],
      ),
    );
  }

  //全选按钮
  Widget _allCheckBox(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          CircleCheckBox(
            value: DataCenter.getInstance().cartList.every((element) => element.is_checked == 1),
            onChanged: (bool val) {
              int is_checked = val ? 1 : 0;
              List<int> ids = [];
              DataCenter.getInstance().cartList.forEach((CartModel element) {
                if(element.is_checked != is_checked) {
                  ids.add(element.id);
                }
              });
              _goodCheckedUpdateBatch(context, is_checked, ids);
            },
          ),
          //全选
          Text(KString.CHECK_ALL),
        ],
      ),
    );
  }

  //总价容器
  Widget _allPriceContainer(BuildContext context) {
    //总价
    int price = 0;
    //计算总价
    DataCenter.getInstance().cartList.forEach((CartModel item) {
      //判断是否选中
      if (item.is_checked == 1) {
        //统计价格
        price += item.good_price * item.good_count;
      }
    });

    //容器
    return Container(
      width: ScreenUtil().setWidth(430),
      alignment: Alignment.centerRight,
      //水平布局
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: ScreenUtil().setWidth(200),
            //合计标签
            child: Text(
              KString.ALL_PRICE,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(230),
            //总价
            child: Text(
              '￥${price}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color: KColor.PRICE_TEXT_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //结算按钮
  Widget _settleButton(BuildContext context) {
    //商品数量
    int _goodCount = 0;
    //统计选中的商品数量
    DataCenter.getInstance().cartList.forEach((CartModel item) {
      if (item.is_checked == 1) {
        _goodCount++;
      }
    });
    //结算小按钮
    return KSmallButton(
      text: KString.SETTLE_ACCOUNT + '(${_goodCount})',
      onPressed: () {
        //获取数据中心存储的购物车数据
        List<CartModel> cartList = [];
        DataCenter.getInstance().cartList.forEach((e) =>
          //提取选中商品
          {
            if(e.is_checked == 1) {
              cartList.add(e)
            }
          }
        );
        RouterUtil.toWriteOrderPage(context, cartList);
      },
    );
  }

  //更新购物车条目
  _goodCheckedUpdateBatch(BuildContext context, int is_checked, List<int> ids) async {
    //参数
    var param = {
      // id 列表
      'ids': ids,
      //是否选中
      'is_checked': is_checked,
    };
    //调用购物车更新接口
    var response = await HttpService.post(ApiUrl.CART_UPDATE_BATCH, param: param);
    //将Json数据转换成购物车列表数据模型
    CartListModel model = CartListModel.fromJson(response['data']);
    //设置数据中心购物列表数据
    DataCenter.getInstance().cartList = model.list;
    //派发消息 刷新购物车
    Call.dispatch(Notify.RELOAD_CART_LIST);
  }
}
