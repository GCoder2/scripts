local Player = game.Players.LocalPlayer
local PlayerName = Player.Name
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Ri Hub - Rismo", "BloodTheme")
local Main = Window:NewTab("Ana Menü")
local Scripts = Window:NewTab("Scriptler")
local PlayerSection = Main:NewSection("Oyuncu")
local GunSection = Main:NewSection("Silahlar")
local TeamSection = Main:NewSection("Takım")
local AdminSection = Scripts:NewSection("Yönetici Scriptleri")
local UsefulSection = Scripts:NewSection("Faydalı Scriptler")

-- Oyuncu Bölümü

PlayerSection:NewSlider("Yürüme Hızı", "Yürüme hızınızı değiştirir.", 200, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
PlayerSection:NewSlider("Zıplama Gücü", "Zıplama gücünüzü değiştirir.", 200, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

-- Silahlar Bölümü

GunSection:NewButton("Pompalı Tüfek Al", "Remington 870 silahını envanterinize ekler.", function()
    local args = {
        [1] = workspace.Prison_ITEMS.giver:FindFirstChild("Remington 870").ITEMPICKUP
    }
    
    workspace.Remote.ItemHandler:InvokeServer(unpack(args))
end)
GunSection:NewButton("Tabanca Al", "M9 silahını envanterinize ekler.", function()
    local args = {
        [1] = workspace.Prison_ITEMS.giver.M9.ITEMPICKUP
    }
    
    workspace.Remote.ItemHandler:InvokeServer(unpack(args))
end)
GunSection:NewButton("AK-47 Al", "AK-47 silahını envanterinize ekler.", function()
    local args = {
        [1] = workspace.Prison_ITEMS.giver:FindFirstChild("AK-47").ITEMPICKUP
    }
    
    workspace.Remote.ItemHandler:InvokeServer(unpack(args))
end)
GunSection:NewButton("M4A1 Al", "Riot Police oyun pass'i gereklidir.", function()
    local args = {
        [1] = workspace.Prison_ITEMS.giver.M4A1.ITEMPICKUP
    }
    
    workspace.Remote.ItemHandler:InvokeServer(unpack(args))
end)
GunSection:NewDropdown("Silah Güçlendirme", "Seçilen silahı aşırı güçlü yapar.", {"M9", "Remington 870", "AK-47", "Taser"}, function(v)
    local module = nil
    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(v) then
        module = require(game:GetService("Players").LocalPlayer.Backpack[v].GunStates)
    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild(v) then
        module = require(game:GetService("Players").LocalPlayer.Character[v].GunStates)
    end
    if module ~= nil then
        module["MaxAmmo"] = math.huge
        module["CurrentAmmo"] = math.huge
        module["StoredAmmo"] = math.huge
        module["FireRate"] = 0.000001
        module["Spread"] = 0
        module["Range"] = math.huge
        module["Bullets"] = 10
        module["ReloadTime"] = 0.000001
        module["AutoFire"] = true
    end
end)
GunSection:NewButton("Aimbot", "Evrensel bir aimbot sağlar.", function()
    local deltaX = nil
    local deltaY = nil
    local aimDeltaX = nil
    local aimDeltaY = nil 
    local gameAimButton = nil
    loadstring(game:HttpGet("https://pastebin.com/raw/w2S8YyDt", true))()
end)

-- Takım Bölümü

TeamSection:NewButton("Mahkûm Ol", "Mahkûm takımına geçer.", function()
    local args = {
        [1] = "Bright orange"
    }
    
    workspace.Remote.TeamEvent:FireServer(unpack(args))
    local args = {
        [1] = PlayerName
    }
    
    workspace.Remote.loadchar:InvokeServer(unpack(args))
end)
TeamSection:NewButton("Gardiyan Ol", "Gardiyan takımına geçer.", function()
    local args = {
        [1] = "Bright blue"
    }
    
    workspace.Remote.TeamEvent:FireServer(unpack(args))
    local args = {
        [1] = PlayerName
    }
    
    workspace.Remote.loadchar:InvokeServer(unpack(args))
end)
TeamSection:NewButton("Tarafsız Ol", "Tarafsız takıma geçer.", function()
    local args = {
        [1] = game:GetService("Players").LocalPlayer,
        [2] = "Medium stone grey"
    }
    
    workspace.Remote.loadchar:InvokeServer(unpack(args))
    local args = {
        [1] = PlayerName
    }
    
    workspace.Remote.loadchar:InvokeServer(unpack(args))
end)

-- Scriptler

AdminSection:NewButton("Inf Yield", "Harika bir FE yönetici scripti.", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
AdminSection:NewButton("Fates Admin", "En iyi FE yönetici scriptlerinden biri.", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))()
end)
UsefulSection:NewButton("DarkDex", "Oyundaki her şeyi görmenizi sağlar.", function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/DinosaurXxX/b757fe011e7e600c0873f967fe427dc2/raw/ee5324771f017073fc30e640323ac2a9b3bfc550/dark%2520dex%2520v4"))()
end)
UsefulSection:NewButton("SimpleSpy", "Roblox exploit yapımı için olmazsa olmaz.", function()
    loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
end)