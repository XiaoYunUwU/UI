loadstring(game:HttpGet("https://raw.githubusercontent.com/YunLua/Lua/refs/heads/main/KFC.lua", true))()
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

getgenv().gatlingcooldown = 0.05
getgenv().multiplytimes = 5
getgenv().norecoil = true
getgenv().enabled = false
getgenv().hooked = false

local Window = WindUI:CreateWindow({
    Title = "云脚本 - TDS",
    Size = UDim2.fromOffset(220, 270),
    Theme = "Dark",
})

local UtilitySection = Window:Tab({
    Title = "主要",
    Locked = false,
})

UtilitySection:Paragraph({
    Title = "说明",
    Desc = "仅适用于Gatling Gun",
    Image = "palette",
    ImageSize = 20,
    Color = "White"
})

UtilitySection:Slider({
    Title = "单次射击次数",
    Value = {Min = 1, Max = 60, Default = 5},
    Step = 1,
    Callback = function(v)
        getgenv().multiplytimes = v
    end
})

UtilitySection:Slider({
    Title = "修改射速",
    Value = {Min = 0.01, Max = 1, Default = 0.01},
    Step = 0.01,
    Callback = function(v)
        getgenv().gatlingcooldown = v
    end
})

UtilitySection:Toggle({
    Title = "开关",
    Value = false,
    Callback = function(state)
        getgenv().enabled = state

        if getgenv().hooked then return end
        getgenv().hooked = true

        local ggchannel = require(game.ReplicatedStorage.Resources.Universal.NewNetwork).Channel("GatlingGun")
        local gganim = require(game:GetService("ReplicatedStorage").Content.Tower["Gatling Gun"].Animator)
        local oldFire = gganim._fireGun

        gganim._fireGun = function(arg1)
            if not getgenv().enabled then
                return oldFire(arg1)
            end

            local camcontroller = require(game:GetService("ReplicatedStorage").Content.Tower["Gatling Gun"].Animator.CameraController)
            local camposition = camcontroller.result and camcontroller.result.Position or camcontroller.position

            for i = 1, getgenv().multiplytimes do
                ggchannel:fireServer("Fire",camposition,workspace:GetAttribute("Sync"),workspace:GetServerTimeNow())
            end

            arg1:Wait(getgenv().gatlingcooldown)
        end
    end
})