let db = require('./db');
var express = require('express');
var router = express.Router();

//添加
router.post('/client/order/add',(req,res) =>{
    let {user_id,username,pay,express,mobile,address,goods} = req.body;

    let sql = `insert into shop_order (user_id,username,pay,express,mobile,address,goods) values (?,?,?,?,?,?,?) `;
	db.exec(sql,[user_id,username,pay,express,mobile,address,goods],(results,fields) => {
	    let sql_delete_cart = `delete from shop_cart where user_id = ? and id in (?)`
	    db.exec(sql_delete_cart, [user_id, JSON.parse(goods).map(e => e.id)], () => {
            res.json({
                code:0,
                message:'提交订单成功',
                data:{
                    id:results.insertId
                }
            });
        });
	});
});


router.get('/client/order/list',(req,res) =>{

    let {user_id} = req.query;

    let sql = `select id,user_id,status,username,pay,express,mobile,address,goods from shop_order where user_id = ?`

	db.exec(sql,[user_id],(results,fields) => {
        res.json({
            code:0,
            message:'获取订单列表成功',
            data: {
                "list":results,
            }
        });

	});
});

module.exports = router;
