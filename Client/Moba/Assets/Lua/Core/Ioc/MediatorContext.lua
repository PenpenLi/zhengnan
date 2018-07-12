---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2018/6/12 10:37
---

local IocContext = require("Core.Ioc.IocContext")
local MediatorContext = class("MediatorContext",IocContext)

function MediatorContext:Ctor(binder)
    self.binder = binder
end

function MediatorContext:GetMediator(viewName)
    local mdrClass = self.binder.typeDict[viewName]
    if mdrClass == nil then
        logError("View:{0} mediator has not register",viewName)
    end
    return mdrClass
end

function MediatorContext:Launch()
    --TODO
	self.binder:Bind(require("Modules.Login.View.LoginMdr")):To(ViewConfig.Login.name)
	self.binder:Bind(require("Modules.Notice.View.NoticeMdr")):To(ViewConfig.Notice.name)
	self.binder:Bind(require("Modules.World.View.WorldMdr")):To(ViewConfig.World.name)
    --TODO
end

return MediatorContext