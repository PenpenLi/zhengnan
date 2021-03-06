package server.account;

import com.alibaba.fastjson.JSONObject;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.handler.codec.http.HttpHeaderValues;
import org.apache.log4j.Logger;
import server.common.Action;
import server.common.Monitor;
import server.common.ReturnCode;
import server.login.LoginMonitor;
import server.redis.RedisClient;
import server.redis.RedisKeys;
import utils.BytesUtils;
import utils.IdGenerator;
import utils.JwtHelper;

import java.util.Date;

import static io.netty.handler.codec.http.HttpHeaderNames.*;
import static io.netty.handler.codec.http.HttpResponseStatus.OK;
import static io.netty.handler.codec.http.HttpVersion.HTTP_1_1;

/**
 * @ClassName: AccountMonitor
 * @Description: TODO
 * @Author: zhengnan
 * @Date: 2018/6/7 11:50
 */
public class AccountMonitor extends Monitor
{
    final static Logger logger = Logger.getLogger(AccountMonitor.class);



    public AccountMonitor()
    {
        super();
    }

    @Override
    protected void RespondJson(ChannelHandlerContext ctx, JSONObject jsonObject)
    {
        String action = jsonObject.get("action").toString();

        switch (action) {
            case Action.LOGIN_ACCOUNT:
                login(ctx, jsonObject);
                break;
        }
    }

    @Override
    protected void initDB()
    {
        //获取数据库
        db = RedisClient.getInstance().getDB(0);
    }

    private void login(ChannelHandlerContext ctx, JSONObject recvJson)
    {
        String[] params = getParams(recvJson);
        String username = params[0];
        String password = params[1];

        String account_id = db.hget(username, RedisKeys.account_id);
        //帐号存在就验证密码
        if (account_id == null) {//新建账号和密码
            long aid = IdGenerator.getInstance().nextId();
            db.hset(username, RedisKeys.account_id, Long.toString(aid));
            db.hset(username, RedisKeys.account_username, username);
            db.hset(username, RedisKeys.account_password, password);
            db.hset(username, RedisKeys.account_ip, ctx.channel().remoteAddress().toString());
            db.hset(username, RedisKeys.account_reg_time, new Date().toString());
            logger.info(String.format("用户:%s 登陆成功", username));
            onLoginSuccess(ctx, account_id);
        } else {
            String db_password = db.hget(username, RedisKeys.account_password);
            if (db_password.equals(password)) {//密码正确，登陆成功
                try {
                    logger.info(String.format("用户:%s 登陆成功", username));
                    onLoginSuccess(ctx, account_id);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    onLoginFail(ctx, username, ReturnCode.Code.FETCH_GAME_SERVER_LIST_ERROR);
                }
            } else {//密码错误，登陆失败
                onLoginFail(ctx, username, ReturnCode.Code.WRONG_PASSWORD);
            }
        }
    }

    private void onLoginSuccess(ChannelHandlerContext ctx, String account_id)
    {
        //游戏服务器的网关地址列表 json
        JSONObject gameServerJson = JSONObject.parseObject(db.get("GameServer"));
        JSONObject rspdJson = new JSONObject();
        rspdJson.put("action", Action.LOGIN_ACCOUNT);
        rspdJson.put("aid", account_id);
        rspdJson.put("token", JwtHelper.createJWT(account_id));
        rspdJson.put("srvList", gameServerJson);
        httpResponse(ctx, rspdJson.toString());
    }

    private void onLoginFail(ChannelHandlerContext ctx, String username, ReturnCode.Code code)
    {
        logger.info(String.format("用户:%s 登陆失败. 原因:%s", username, ReturnCode.getMsg(code)));
        httpResponse(ctx, ReturnCode.getMsg(code));
    }

    private void httpResponse(ChannelHandlerContext ctx, String msg)
    {
        //msg = StringUtils.AddControlChar(msg);
        //msg = StringUtils.AddControlChar(msg);
        logger.info(String.format("[Rspd]:%s", msg));
        FullHttpResponse response = new DefaultFullHttpResponse(
                HTTP_1_1, OK, Unpooled.wrappedBuffer(BytesUtils.string2Bytes(msg)));
        response.headers().set(CONTENT_TYPE, "text/plain");
        response.headers().set(CONTENT_LENGTH, response.content().readableBytes());
        response.headers().set(CONNECTION, HttpHeaderValues.KEEP_ALIVE);
        ctx.write(response);
    }
}
