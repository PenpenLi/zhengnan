---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2018/6/11 23:39
---

---@class Core.Ioc.IocBinder
local IocBinder = class("IocBinder")

function IocBinder:Ctor()
    self.singleList = {} --单例列表
    self.typeDict = {}  --类型
end

function IocBinder:Bind(type)
    self.type = type
    return self
end

function IocBinder:ToSingleton()
    local singleton = self.type.New()
    table.insert(self.singleList,singleton)
    --log("[Bind singleton] -- {0}",self.type.__classname)
    return singleton
end

function IocBinder:To(target)
    self.typeDict[target] = self.type
    return self
end

-- inject all the singleton in to the object,but not then self
function IocBinder:InjectSingle(obj)
    for _, singleton in pairs(self.singleList) do
        if singleton.__classname ~= obj.__classname then
            local index = string.startLower(singleton.__classname) --the first word startLower
            obj[index] = singleton
        end
    end
end

-- inject each other single
function IocBinder:InjectSingleEachOther(obj)
    for _, singleton in pairs(self.singleList) do
        local index = singleton.__classname
        self:InjectSingle(singleton)
    end
end

return IocBinder