import express from 'express';
import * as nodemailer from "nodemailer";
let db = require('./db');
var router = express.Router();
var jwt = require("jsonwebtoken");
const bcrypt = require('bcrypt');
const saltRounds = 10;

function MathRand6() {
    let num = "";
    for (let i = 0; i < 6; i++) {
        num += Math.floor(Math.random() * 10);
    }
    return num;
}

//管理员登录 Authorization: `Bearer ${token}`
router.post('/user/login',(req,res) => {
    let {username,password} = req.body;
    console.log(username);
    //查询帐户数据
    let sql = `select * from shop_user where username = ?`;
	db.exec(sql,[username,password],(results,fields) => {
        console.log(results[0]);
        // 帐号密码错误
        if(!results.length){
            res.json({
                code:1000,
                message:"帐号错误",
                data: results
            });
            return false;
        }
        let {id, password: hash} = results[0];
        if(!bcrypt.compareSync(password, hash)) {
            res.json({
                code:1000,
                message:"密码错误",
                data: results
            });
            return false;
        }
        if(results[0].activated === 0) {
            res.json({
                code:1000,
                message:"尚未激活",
                data: results
            });
            return false;
        }

        console.log(results[0]['phone']);
        // 登录成功
        let payload = {
            id,
            username,
        }

        // 生成token "1d", "20h", 60
        let token = jwt.sign(payload,'secret',{expiresIn:'365d'});
        console.log("生成的token:" + token);
        res.json({
            code:0,
            message:'登录成功',
            data: {
                token,
                id,
                username:results[0]['username'],
                mobile:results[0]['mobile'],
                address:results[0]['address'],
                head_image:results[0]['head_image'],
            }
        });
	});
});


//注册
router.post('/user/register',(req,res)  => {
    let {username,password,mobile,address, provinceId, cityId, areaId, email} = req.body;
    //查询帐户是否存在
    let sql = `select * from shop_user where username = ?`;
	db.exec(sql,[username],(results,fields) => {
        if(results.length){
            res.json({
                code:1001,
                message:"帐号已经存在",
                data: results
            });
            return false;
        }
        let activatedCode = MathRand6();
        const transporter = nodemailer.createTransport({
            service: 'qq',
            auth: {
                user: '1378026744@qq.com',
                pass: 'povpumldcrdhhhhi' //授权码,通过QQ获取
            }
        });
        const mailOptions = {
            from: '1378026744@qq.com', // 发送者
            to: email, // 接受者,可以同时发送多个,以逗号隔开
            subject: '激活码', // 标题
            text: activatedCode, // 文本
            // html: activatedCode
        };

        transporter.sendMail(mailOptions, function (err, info) {
            if (err) {
                console.log(err);
                return;
            }
            console.log('发送成功');
            const salt = bcrypt.genSaltSync(saltRounds);
            password = bcrypt.hashSync(password, salt);
            activatedCode = bcrypt.hashSync(activatedCode, salt);
            let sql = `insert into shop_user (username,password,mobile,address,provinceId,cityId,areaId,email,activated_code) values (?,?,?,?,?,?,?,?,?)`;
            db.exec(sql,[username,password,mobile,address,provinceId,cityId,areaId,email,activatedCode],(results,fields) => {
                // 登录成功
                let payload = {
                    username,
                }
                // 生成token
                let token = jwt.sign(payload,'secret',{expiresIn:'365d'});
                // 存储成功
                res.json({
                    code:0,
                    message:'注册成功',
                    data: {
                        token,
                        id:results.insertId,
                        username,
                    }
                });
            });
        });
    });
});

//激活
router.post('/user/activate', (req,res) => {
    let {user_id, activated_code} = req.body;
    //查询帐户数据
    let sql = `select * from shop_user where id = ?`;
    db.exec(sql,[user_id],(results,fields) => {
        console.log(results[0]);
        let {id, username, activated_code: hash, mobile,address,head_image } = results[0];
        if(!bcrypt.compareSync(activated_code, hash)) {
            res.json({
                code:1000,
                message:"激活码错误",
                data: results
            });
            return false;
        }

        let sql =  `update shop_user set activated = ? where id = ?`;
        db.exec(sql, [1, user_id], (results, fields) => {
            let payload = {
                id,
                username,
            }
            // 生成token "1d", "20h", 60
            let token = jwt.sign(payload,'secret',{expiresIn:'365d'});
            console.log("生成的token:" + token);
            res.json({
                code:0,
                message:'激活成功',
                data: {
                    token,
                    id,
                    username,
                    mobile,
                    address,
                    head_image,
                }
            });
        })
    });
})

router.get('/admin/user/list',(req,res)  => {
    //查询帐户数据
    let sql = `select id,username,head_image,mobile,address from shop_user order by id`;
	db.exec(sql,[],(results,fields) => {
        if(!results.length){
            res.json({
                code:1002,
                message:"获取用户列表失败",
                data: results
            });
            return false;
        }
		res.json({
			code:0,
            message:'获取成功',
            data: results
		});
	});
});

module.exports = router;
