---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2018/6/29 23:45
---

---@class Core.ViewInfo : Core.LuaObject
local LuaObject = require("Core.LuaObject")
local ViewInfo = class("LuaMonoBehaviour",LuaObject)

function ViewInfo:Ctor()
    self.name = ""
    self.url = ""
end

return ViewInfo