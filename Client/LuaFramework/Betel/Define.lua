---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zheng.
--- DateTime: 2018/6/10 20:56
---

---Lua基本类型分别为


TYPE = {}
--TYPE.nil = "nil"          --这个最简单，只有值nil属于该类，表示一个无效值（在条件表达式中相当于false）。
TYPE.boolean = "boolean"    --包含两个值：false和true。
TYPE.number = "number"        --表示双精度类型的实浮点数
TYPE.string = "string"        --字符串由一对双引号或单引号来表示
TYPE.func = "function"        --由 C 或 Lua 编写的函数
TYPE.userdata = "userdata"    --表示任意存储在变量中的C数据结构
TYPE.thread = "thread"        --表示执行的独立线路，用于执行协同程序
TYPE.table = "table"        --Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串。在 Lua 里，table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。

---UnityEngine
GameObject = UnityEngine.GameObject;
Application = UnityEngine.Application;
PlayerPrefs = UnityEngine.PlayerPrefs;
Vector2 = UnityEngine.Vector2
Vector3 = UnityEngine.Vector3
Vector4 = UnityEngine.Vector4
Color = UnityEngine.Color;
Input = UnityEngine.Input;
Time = UnityEngine.Time;
Mathf = UnityEngine.Mathf;
Camera = UnityEngine.Camera
Rect = UnityEngine.Rect
---@class UnityEngine.EventSystems
---@field EventTrigger UnityEngine.EventSystems.EventTrigger
---@field EventTriggerType UnityEngine.EventSystems.EventTriggerType
EventSystems = {
    EventTrigger = UnityEngine.EventSystems.EventTrigger;
    EventTriggerType = UnityEngine.EventSystems.EventTriggerType;
    InputButton = UnityEngine.EventSystems.PointerEventData.InputButton;
}
EventTrigger = EventSystems.EventTrigger
EventTriggerType = EventSystems.EventTriggerType
InputButton = EventSystems.InputButton
---3rd

---@class DT
---@field DOTween DG.Tweening.DOTween
---@field Ease DG.Tweening.Ease
---@field RotateMode DG.Tweening.RotateMode
---@field LoopType DG.Tweening.LoopType
DT = {
    DOTween = DG.Tweening.DOTween,
    Ease = DG.Tweening.Ease,
    LoopType = DG.Tweening.LoopType,
    RotateMode = DG.Tweening.RotateMode
}
DOTween = DT.DOTween
Ease = DT.Ease
LoopType = DT.LoopType
RotateMode = DT.RotateMode

---Framework
logger = Logger
Tools = require("Betel.Utils.Tools")
Math3D = require("Betel.Utils.Math3D")
Event = require("Betel.Events.Event")
Handler = require("Betel.Handler")
EventDispatcher = require("Betel.Events.EventDispatcher")
edp = EventDispatcher.New() --全局事件派发器
ListViewEvent = require("Betel.UI.ListViewEvent")
BaseList = require("Betel.UI.BaseList")
ListItemRenderer = require("Betel.UI.ListItemRenderer")

StateAction = FastBehavior.StateAction
StateMachine = FastBehavior.StateMachine
StateNode = FastBehavior.StateNode
FastLuaBehavior = FastBehavior.FastLuaBehavior

---=============---
---Global Define
---=============---
List = require("Betel.List")
