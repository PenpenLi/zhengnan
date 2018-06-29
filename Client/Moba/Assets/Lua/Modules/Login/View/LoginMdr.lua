---
--- Generated by Tools
--- Created by zheng.
--- DateTime: 2018-06-19-00:17:42
---

---@class Modules.Login.View.LoginMdr : Core.Ioc.BaseMediator
local BaseMediator = require("Core.Ioc.BaseMediator")
local LoginMdr = class("LoginMdr",BaseMediator)

function LoginMdr:OnInit()
    print("MVC 测试")

    ---@type Core.List
    local testList = List.New()
    testList:Add(123)
    testList:Add(123)
    testList:Add(123)
    testList:Add(123)

    for i = 1, testList:Size() do
        print(testList[i])
    end
end

return LoginMdr
