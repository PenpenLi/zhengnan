---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhengnan.
--- DateTime: 2018/6/12 10:35
---

---@class Betel.Ioc.IocContext
local IocContext = class("IocContext")

function IocContext:Ctor(binder)
    self.binder = binder
end

function IocContext:Launch()

end

return IocContext