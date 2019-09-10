---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2018/6/29 23:58
---

local BaseMediator = require("Game.Core.Ioc.BaseMediator")
---@class Game.Modules.World.View.WorldMdr : Game.Core.Ioc.BaseMediator
---@field currScene Game.Modules.World.Scenes.BaseScene
---@field currLevelName string
local WorldMdr = class("WorldMdr",BaseMediator)

function WorldMdr:Ctor()
    WorldMdr.super.Ctor(self)
    self.tempLevel = nil;
    self.currLevelName = "";
    self.currScene = nil;
    self.nextScene = nil;

    World.mdr = self
end

function WorldMdr:OnInit()
    self:EnterScene(WorldConfig.Login)
end

function WorldMdr:GetTempLevel()
    if self.tempLevel == WorldConfig.TempA then
        return WorldConfig.TempB.level
    else
        return WorldConfig.TempA.level
    end
end

---@param sceneInfo SceneInfo
function WorldMdr:EnterScene(sceneInfo, callback)
    if string.isValid(sceneInfo.level) then
        if self.currScene then
            self.currScene:OnExitScene()
        end
        log("Will enter "..sceneInfo.level)
        if self.currLevelName == sceneInfo.level then
            logError("you can not load then same scene - " .. sceneInfo.level)
        elseif sceneInfo.level == "Temp" then
            self.tempLevel = self:GetTempLevel()
            self:LoadLevel(self.tempLevel, sceneInfo, callback)
        elseif sceneInfo.needLoading then
            self.nextScene = sceneInfo
            self:EnterScene(WorldConfig.Loading)
        elseif sceneInfo == WorldConfig.Loading then
            self:LoadLevel(sceneInfo.level, sceneInfo, callback)
        else
            self:LoadScene(sceneInfo, function()
                self:LoadLevel(sceneInfo.level, sceneInfo, callback)
            end)
        end
    end
end

function WorldMdr:EnterNextScene()
    self.nextScene.needLoading = false --临时关闭加载需求
    self:EnterScene(self.nextScene,function ()
        self.nextScene.needLoading = true
        self.nextScene = nil
    end)
end

---@param sceneInfo SceneInfo
function WorldMdr:LoadScene(sceneInfo, callback)
    Res.LoadObjectAsync(sceneInfo.levelUrl, function()
        if callback ~= nil then
            callback()
        end
    end)
end

function WorldMdr:LoadLevel(levelName, sceneInfo, callback)
    sceneMgr:LoadSceneAsync(levelName, function (unityScene)
        local sceneType = require(string.format("Game.Modules.World.Scenes.%sScene",sceneInfo.sceneName,sceneInfo.sceneName))
        if sceneType == nil then
            logError("can not find scene "..sceneInfo.sceneName)
            logStack()
            return
        end
        local scene = sceneType.New(sceneInfo, unityScene)
        log("进入场景:"..sceneInfo.debugName)
        self.currScene = scene
        self.currLevelName = levelName
        scene:OnEnterScene()
        if callback ~= nil then
            callback()
        end
    end)
end

return WorldMdr