---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2018/6/20 16:21
--- 视图管理d
---

local LuaMonoBehaviour = require('Betel.LuaMonoBehaviour')
local Ioc = require("Game.Core.Ioc.IocBootstrap")
---@class Game.Manager.ViewManager : Betel.LuaMonoBehaviour
---@field public scene Game.Modules.World.Scenes.BaseScene
local ViewManager = class("ViewManager",LuaMonoBehaviour)

local ioc = nil
function ViewManager:Ctor()
    self.viewCache = {}
    self.viewList = List.New()

    local prefab = Res.LoadPrefab("Prefabs/UI/Common/UICanvas.prefab")
    self.uiCanvas = Instantiate(prefab)
    self.uiCanvas.name = "[UICanvas]"
    dontDestroyOnLoad(self.uiCanvas)
end

---@return UnityEngine.Transform
function ViewManager:GetUILayer(layer)
    return self.uiCanvas:FindChild(layer).transform
end
---@param scene Game.Modules.World.Scenes.BaseScene
function ViewManager:SetScene(scene)
    self.scene = scene
end

---@param viewInfo Game.Core.ViewInfo
function ViewManager:LoadView(viewInfo)
    if ioc == nil then
        ioc = Ioc.New()
        ioc:Launch()
    end
    self:DoLoadViewCo(viewInfo)
end

---@param viewInfo Game.Core.ViewInfo
function ViewManager:DoLoadViewCo(viewInfo)
    if viewInfo == nil then
        logError("'viewInfo' param is nil")
        return
    end

    if viewInfo.status == nil or viewInfo.status == ViewStatus.Unloaded then
        viewInfo.status = ViewStatus.Loading
        self:LoadViewPrefab(viewInfo,function (go)
            self:CreateView(viewInfo,go)
            viewInfo.status = ViewStatus.Loaded
        end)
    else
        if viewInfo.status == ViewStatus.Loading or
            viewInfo.status == ViewStatus.Unloading or
            viewInfo.status == ViewStatus.Loaded then
            logError("View {0} status is {1} ,you can't load this view",viewInfo.name, viewInfo.status)
        end
    end
end

---@param viewInfo Game.Core.ViewInfo
function ViewManager:UnloadView(viewInfo)
    if viewInfo.status == ViewStatus.Loaded then
        local mdr = self.viewCache[viewInfo.name]
        if mdr then
            self.viewCache[viewInfo.name] = nil
            self.viewList:Remove(mdr)
            destroy(mdr.gameObject)
            mdr:DoRemove(function ()
                viewInfo.status = ViewStatus.Unloaded
            end)
        end
    else
        logError("View {0} status is {1} ,you can't unload this view",viewInfo.name, viewInfo.status)
    end
end

---@param viewInfo Game.Core.ViewInfo
---@param callback function
function ViewManager:LoadViewPrefab(viewInfo,callback)
    local prefab = Res.LoadPrefab(viewInfo.prefab)
    if prefab then
        local go = GameObject.Instantiate(prefab)
        callback(go)
    end
end

---@param viewInfo Core.ViewInfo
---@param go UnityEngine.GameObject
function ViewManager:CreateView(viewInfo,go)
    local mdrType = ioc.mediatorContext:GetMediator(viewInfo.name)
    if mdrType == nil then
        logError("view:'{0}' has not register", viewInfo.name)
        return
    end
    local mdr = mdrType.New() ---@type Game.Core.Ioc.BaseMediator
    if viewInfo ~= ViewConfig.World then
        mdr.scene = self.scene
        mdr.uiCanvas = self.uiCanvas
        go.transform:SetParent(self:GetUILayer(mdr.layer))
    else
        dontDestroyOnLoad(go)
        go.name = "[World]"
        go.transform:SetParent(nil)
    end
    mdr.viewInfo = viewInfo
    mdr.gameObject = go
    go.name = viewInfo.name .. " - " ..go.name
    local rect = go:GetRect()
    go.transform.localPosition = Vector3.zero
    if not isNull(rect) and rect.anchorMin == Vector2.New(0,0) and rect.anchorMax == Vector2.New(1,1) then
        --rect.anchorMin = Vector2.zero
        --rect.anchorMax = Vector2.one
        rect.sizeDelta = Vector2.zero
        rect.anchoredPosition = Vector2.zero
    end
    go.transform.localEulerAngles = Vector3.zero
    --go.transform.sizeDelta = Vector2.zero
    go.transform.localScale = Vector3.one

    ioc.binder:InjectSingle(mdr)
    mdr:AddLuaMonoBehaviour(go,"Mediator")

    log("View has loaded {0}", viewInfo.name)
    self.viewCache[viewInfo.name] = mdr
    self.viewList:Add(mdr)
end

return ViewManager