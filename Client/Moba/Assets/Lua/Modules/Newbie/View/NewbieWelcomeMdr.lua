---
--- Generated by Tools
--- Created by zheng.
--- DateTime: 2018-08-13-23:21:04
---

---@class Modules.Newbie.View.NewbieWelcomeMdr : Core.Ioc.BaseMediator
local BaseMediator = require("Core.Ioc.BaseMediator")
local NewbieWelcomeMdr = class("NewbieWelcomeMdr",BaseMediator)

function NewbieWelcomeMdr:OnInit()
    self.mainRoleInfo = self.roleModel.mainRoleInfo;
    self.gameObject:SetText("TextWelcome", self.mainRoleInfo.roleName .. " 你好! 欢迎来到游戏世界.请开始新手引导")
end

function NewbieWelcomeMdr:On_Click_BtnGuideOver()
    World.EnterScene(WorldConfig.Lobby)
end

return NewbieWelcomeMdr
