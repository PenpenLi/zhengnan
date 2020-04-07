---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2018/8/11 22:19
--- 网络监听器
---


local LuaMonoBehaviour = require('Betel.LuaMonoBehaviour')
---@class Betel.Net.NetworkListener : Betel.LuaMonoBehaviour
local NetworkListener = class("NetworkListener",LuaMonoBehaviour)

function NetworkListener:Ctor(errorReport)
    self.errorReport = errorReport --是否输出错误报告
    self.respondMap = {} --同步响应回调
    self.pushMap = {} --异步推送回调
end

function NetworkListener:addCallback(action, handler)
    local callbackList = self.respondMap[action]
    if callbackList == nil then
        callbackList = List.New()
        self.respondMap[action] = callbackList;
    end
    if not callbackList:Contain(handler) then
        callbackList:Add(handler)
    end
end

function NetworkListener:addPushCallback(action, handler)
    local callbackList = self.pushMap[action]
    if callbackList == nil then
        callbackList = List.New()
        self.pushMap[action] = callbackList;
    end
    if not callbackList:Contain(handler) then
        callbackList:Add(handler)
    end
end

function NetworkListener:removePushCallback(action, handler)
    local pushCallbackList = self.pushMap[action]
    if pushCallbackList ~= nil then
        for i = 1, pushCallbackList:Size() do
            if pushCallbackList[i] == handler then
                pushCallbackList:Remove(handler)
                break;
            end
        end
    end
end

function NetworkListener:handlerPushCallback(action, json)
    if action == nil then
        logError("action is nil")
        return
    end
    local pushCallbackList = self.pushMap[action]
    if pushCallbackList ~= nil then
        for i = 1, pushCallbackList:Size() do
            local callback = pushCallbackList[i]
            if callback then
                callback(json)
            end
        end
        --self.pushMap[action] = nil
    else
        if self.errorReport then
            logError("there is no push callback with action {0}", action)
        end
    end
end

function NetworkListener:handlerRqstCallback(action, json)
    if action == nil then
        logError("action is nil")
        return
    end
    local rqstCallbackList = self.respondMap[action]
    if rqstCallbackList ~= nil then
        for i = 1, rqstCallbackList:Size() do
            local callback = rqstCallbackList[i]
            if callback then
                callback(json)
            end
        end
        self.respondMap[action] = nil
    else
        if self.errorReport then
            logError("there is no rqst callback with action {0}", action)
        end
    end
end


return NetworkListener