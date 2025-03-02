--[[
    Fates Admin - 16/11/2022
    Türkçe Yama By GScripts
]]

local game = game
local GetService = game.GetService
if (not game.IsLoaded(game)) then
    local Loaded = game.Loaded
    Loaded.Wait(Loaded);
end

local _L = {}
_L.start = start or tick();
local Debug = true

do
    local F_A = getgenv().F_A
    if (F_A) then
        local Notify, GetConfig = F_A.Utils.Notify, F_A.GetConfig
        local UserInputService = GetService(game, "UserInputService");
        local CommandBarPrefix = GetConfig().CommandBarPrefix
        local StringKeyCode = UserInputService.GetStringForKeyCode(UserInputService, Enum.KeyCode[CommandBarPrefix]);
        return Notify(nil, "Yüklendi", "Fates Admin zaten yüklü... 'killscript' ile kapatabilirsiniz"),
        Notify(nil, "Önekiniz", string.format("%s (%s)", StringKeyCode, CommandBarPrefix));
        Notify(nil, "Fates Admin. Türkçe Yama GScripts Tarafından Yapıldı! İyi Oyunlar.",);
    end
end

-- [var] Servisler ve Temel Tanımlamalar
local Services = {
    Workspace = GetService(game, "Workspace");
    UserInputService = GetService(game, "UserInputService");
    ReplicatedStorage = GetService(game, "ReplicatedStorage");
    StarterPlayer = GetService(game, "StarterPlayer");
    StarterPack = GetService(game, "StarterPack");
    StarterGui = GetService(game, "StarterGui");
    TeleportService = GetService(game, "TeleportService");
    CoreGui = GetService(game, "CoreGui");
    TweenService = GetService(game, "TweenService");
    HttpService = GetService(game, "HttpService");
    TextService = GetService(game, "TextService");
    MarketplaceService = GetService(game, "MarketplaceService");
    Chat = GetService(game, "Chat");
    Teams = GetService(game, "Teams");
    SoundService = GetService(game, "SoundService");
    Lighting = GetService(game, "Lighting");
    ScriptContext = GetService(game, "ScriptContext");
    Stats = GetService(game, "Stats");
}

setmetatable(Services, {
    __index = function(Table, Property)
        local Ret, Service = pcall(GetService, game, Property);
        if (Ret) then
            Services[Property] = Service
            return Service
        end
        return nil
    end,
    __mode = "v"
});

-- Temel Fonksiyon Tanımlamaları (Değişmedi)
local GetChildren, GetDescendants = game.GetChildren, game.GetDescendants
local IsA = game.IsA
local FindFirstChild, FindFirstChildOfClass, FindFirstChildWhichIsA, WaitForChild = 
    game.FindFirstChild, game.FindFirstChildOfClass, game.FindFirstChildWhichIsA, game.WaitForChild
local GetPropertyChangedSignal, Changed = game.GetPropertyChangedSignal, game.Changed
local Destroy, Clone = game.Destroy, game.Clone
local Heartbeat, Stepped, RenderStepped;
do
    local RunService = Services.RunService;
    Heartbeat, Stepped, RenderStepped = RunService.Heartbeat, RunService.Stepped, RunService.RenderStepped
end

local Players = Services.Players
local GetPlayers = Players.GetPlayers
local JSONEncode, JSONDecode, GenerateGUID = Services.HttpService.JSONEncode, Services.HttpService.JSONDecode, Services.HttpService.GenerateGUID
local Camera = Services.Workspace.CurrentCamera

-- Tablo ve String Fonksiyonları (Değişmedi)
local Tfind, sort, concat, pack, unpack = table.find, table.sort, table.concat, table.pack, table.unpack
local lower, upper, Sfind, split, sub, format, len, match, gmatch, gsub, byte = 
    string.lower, string.upper, string.find, string.split, string.sub, string.format, string.len, string.match, string.gmatch, string.gsub, string.byte
local random, floor, round, abs, atan, cos, sin, rad = math.random, math.floor, math.round, math.abs, math.atan, math.cos, math.sin, math.rad
local InstanceNew, CFrameNew, Vector3New = Instance.new, CFrame.new, Vector3.new

-- Bağlantılar ve Diğer Tanımlamalar (Değişmedi)
local Inverse, toObjectSpace, components
do
    local CalledCFrameNew = CFrameNew();
    Inverse, toObjectSpace, components = CalledCFrameNew.Inverse, CalledCFrameNew.toObjectSpace, CalledCFrameNew.components
end
local Connection, CWait, CConnect = game.Loaded, game.Loaded.Wait, game.Loaded.Connect
local Disconnect;
do
    local CalledConnection = CConnect(Connection, function() end);
    Disconnect = CalledConnection.Disconnect
end
local __H = InstanceNew("Humanoid");
local UnequipTools, ChangeState, SetStateEnabled, GetState, GetAccessories = __H.UnequipTools, __H.ChangeState, __H.SetStateEnabled, __H.GetState, __H.GetAccessories
local LocalPlayer = Players.LocalPlayer
local PlayerGui = FindFirstChildWhichIsA(LocalPlayer, "PlayerGui");
local Mouse = LocalPlayer.GetMouse(LocalPlayer);

local CThread;
do
    local wrap = coroutine.wrap
    CThread = function(Func, ...)
        if (type(Func) ~= 'function') then return nil end
        local Varag = ...
        return function()
            local Success, Ret = pcall(wrap(Func, Varag));
            if (Success) then return Ret end
            if (Debug) then warn("[FA Hata]: " .. debug.traceback(Ret)); end
        end
    end
end

-- Yardımcı Fonksiyonlar (Değişmedi)
local startsWith = function(str, searchString, rawPos)
    local pos = rawPos or 1
    return searchString == "" and true or sub(str, pos, pos) == searchString
end
local trim = function(str) return gsub(str, "^%s*(.-)%s*$", "%1"); end
local tbl_concat = function(...) local new = {} for i, v in next, {...} do for i2, v2 in next, v do new[i] = v2 end end return new end
local indexOf = function(tbl, val) if (type(tbl) == 'table') then for i, v in next, tbl do if (v == val) then return i end end end end
local forEach = function(tbl, ret) for i, v in next, tbl do ret(i, v); end end
local filter = function(tbl, ret) if (type(tbl) == 'table') then local new = {} for i, v in next, tbl do if (ret(i, v)) then new[#new + 1] = v end end return new end end
local map = function(tbl, ret) if (type(tbl) == 'table') then local new = {} for i, v in next, tbl do local Value, Key = ret(i, v); new[Key or #new + 1] = Value end return new end end
local deepsearch;
deepsearch = function(tbl, ret) if (type(tbl) == 'table') then for i, v in next, tbl do if (type(v) == 'table') then deepsearch(v, ret); end ret(i, v); end end end
local deepsearchset;
deepsearchset = function(tbl, ret, value) if (type(tbl) == 'table') then local new = {} for i, v in next, tbl do new[i] = v if (type(v) == 'table') then new[i] = deepsearchset(v, ret, value); end if (ret(i, v)) then new[i] = value(i, v); end end return new end end
local flat = function(tbl) if (type(tbl) == 'table') then local new = {} deepsearch(tbl, function(i, v) if (type(v) ~= 'table') then new[#new + 1] = v end end) return new end end
local flatMap = function(tbl, ret) if (type(tbl) == 'table') then local new = flat(map(tbl, ret)); return new end end
local shift = function(tbl) if (type(tbl) == 'table') then local firstVal = tbl[1] tbl = pack(unpack(tbl, 2, #tbl)); tbl.n = nil return tbl end end
local keys = function(tbl) if (type(tbl) == 'table') then local new = {} for i, v in next, tbl do new[#new + 1] = i end return new end end
local clone = function(toClone, shallow) if (type(toClone) == 'function' and clonefunction) then return clonefunction(toClone); end local new = {} for i, v in pairs(toClone) do if (type(v) == 'table' and not shallow) then v = clone(v); end new[i] = v end return new end
local setthreadidentity = setthreadidentity or syn_context_set or setthreadcontext or (syn and syn.set_thread_identity)
local getthreadidentity = getthreadidentity or syn_context_get or getthreadcontext or (syn and syn.get_thread_identity)
-- [var] Bitiş

local GetCharacter = GetCharacter or function(Plr) return Plr and Plr.Character or LocalPlayer.Character end
local Utils = {}

-- [extend] Genişletmeler (Değişmedi)
local Stats = Services.Stats
local ContentProvider = Services.ContentProvider
local firetouchinterest, hookfunction;
do
    local GEnv = getgenv();
    local touched = {}
    firetouchinterest = GEnv.firetouchinterest or function(part1, part2, toggle)
        if (part1 and part2) then
            if (toggle == 0) then touched[1] = part1.CFrame part1.CFrame = part2.CFrame else part1.CFrame = touched[1] touched[1] = nil end
        end
    end
    local newcclosure = newcclosure or function(f) return f end
    hookfunction = GEnv.hookfunction or function(func, newfunc, applycclosure)
        if (replaceclosure) then replaceclosure(func, newfunc); return func end
        func = applycclosure and newcclosure or newfunc
        return func
    end
end

-- Bağlantı ve Meta Yöntem Tanımlamaları (Değişmedi)
-- ... (Bu kısım kodun teknik yapısı olduğu için değişmedi)

-- [extend] Bitiş

local GetRoot = function(Plr, Char)
    local LCharacter = GetCharacter();
    local Character = Char or GetCharacter(Plr);
    return Plr and Character and (FindFirstChild(Character, "HumanoidRootPart") or FindFirstChild(Character, "Torso") or FindFirstChild(Character, "UpperTorso")) or LCharacter and (FindFirstChild(LCharacter, "HumanoidRootPart") or FindFirstChild(LCharacter, "Torso") or FindFirstChild(LCharacter, "UpperTorso"));
end

local GetHumanoid = function(Plr, Char)
    local LCharacter = GetCharacter();
    local Character = Char or GetCharacter(Plr);
    return Plr and Character and FindFirstChildWhichIsA(Character, "Humanoid") or LCharacter and FindFirstChildWhichIsA(LCharacter, "Humanoid");
end

local GetMagnitude = function(Plr, Char)
    local LRoot = GetRoot();
    local Root = GetRoot(Plr, Char);
    return Plr and Root and (Root.Position - LRoot.Position).magnitude or math.huge
end

-- Ayarlar
local Settings = {
    Prefix = "!",
    CommandBarPrefix = "Noktalı Virgül",
    ChatPrediction = false,
    Macros = {},
    Aliases = {},
}
local PluginSettings = {
    PluginsEnabled = true,
    PluginDebug = false,
    DisabledPlugins = {["PluginName"] = true},
    SafePlugins = false
}

local WriteConfig = function(Destroy)
    local JSON = JSONEncode(Services.HttpService, Settings);
    local PluginJSON = JSONEncode(Services.HttpService, PluginSettings);
    if (isfolder("fates-admin") and Destroy) then
        delfolder("fates-admin");
        writefile("fates-admin/config.json", JSON);
        writefile("fates-admin/plugins/plugin-conf.json", PluginJSON);
    else
        makefolder("fates-admin");
        makefolder("fates-admin/plugins");
        makefolder("fates-admin/chatlogs");
        writefile("fates-admin/config.json", JSON);
        writefile("fates-admin/plugins/plugin-conf.json", PluginJSON);
    end
end

local GetConfig = function()
    if (isfolder("fates-admin") and isfile("fates-admin/config.json")) then
        return JSONDecode(Services.HttpService, readfile("fates-admin/config.json"));
    else
        WriteConfig();
        return JSONDecode(Services.HttpService, readfile("fates-admin/config.json"));
    end
end

local GetPluginConfig = function()
    if (isfolder("fates-admin") and isfolder("fates-admin/plugins") and isfile("fates-admin/plugins/plugin-conf.json")) then
        return JSONDecode(Services.HttpService, readfile("fates-admin/plugins/plugin-conf.json"));
    else
        WriteConfig();
        return JSONDecode(Services.HttpService, readfile("fates-admin/plugins/plugin-conf.json"));
    end
end

local SetPluginConfig = function(conf)
    if (isfolder("fates-admin") and isfolder("fates-admin/plugins") and isfile("fates-admin/plugins/plugin-conf.json")) then WriteConfig(); end
    local NewConfig = GetPluginConfig();
    for i, v in next, conf do NewConfig[i] = v end
    writefile("fates-admin/plugins/plugin-conf.json", JSONEncode(Services.HttpService, NewConfig));
end

local SetConfig = function(conf)
    if (not isfolder("fates-admin") and isfile("fates-admin/config.json")) then WriteConfig(); end
    local NewConfig = GetConfig();
    for i, v in next, conf do NewConfig[i] = v end
    writefile("fates-admin/config.json", JSONEncode(Services.HttpService, NewConfig));
end

local CurrentConfig = GetConfig();
local Prefix = isfolder and CurrentConfig.Prefix or "!"
local Macros = CurrentConfig.Macros or {}
local AdminUsers, Exceptions, Connections = {}, {}, {Players = {}}
_L.CLI, _L.ChatLogsEnabled, _L.GlobalChatLogsEnabled, _L.HttpLogsEnabled = false, true, false, true

-- Oyuncu Bulma
local GetPlayer;
GetPlayer = function(str, noerror)
    local CurrentPlayers = filter(GetPlayers(Players), function(i, v) return not Tfind(Exceptions, v); end)
    if (not str) then return {} end
    str = lower(trim(str));
    if (Sfind(str, ",")) then return flatMap(split(str, ","), function(i, v) return GetPlayer(v, noerror); end) end

    local Magnitudes = map(CurrentPlayers, function(i, v) return {v, (GetRoot(v).CFrame.p - GetRoot().CFrame.p).Magnitude} end)

    local PlayerArgs = {
        ["hepsi"] = function() return filter(CurrentPlayers, function(i, v) return v ~= LocalPlayer end) end,
        ["diğerleri"] = function() return filter(CurrentPlayers, function(i, v) return v ~= LocalPlayer end) end,
        ["en-yakın"] = function() sort(Magnitudes, function(a, b) return a[2] < b[2] end) return {Magnitudes[2][1]} end,
        ["en-uzak"] = function() sort(Magnitudes, function(a, b) return a[2] > b[2] end) return {Magnitudes[2][1]} end,
        ["rastgele"] = function() return {CurrentPlayers[random(2, #CurrentPlayers)]} end,
        ["müttefikler"] = function() local LTeam = LocalPlayer.Team return filter(CurrentPlayers, function(i, v) return v.Team == LTeam end) end,
        ["düşmanlar"] = function() local LTeam = LocalPlayer.Team return filter(CurrentPlayers, function(i, v) return v.Team ~= LTeam end) end,
        ["npcler"] = function()
            local NPCs = {}
            local Descendants = GetDescendants(Workspace);
            local GetPlayerFromCharacter = Players.GetPlayerFromCharacter
            for i = 1, #Descendants do
                local Descendant = Descendants[i]
                local DParent = Descendant.Parent
                if (IsA(Descendant, "Humanoid") and IsA(DParent, "Model") and (FindFirstChild(DParent, "HumanoidRootPart") or FindFirstChild(DParent, "Head")) and GetPlayerFromCharacter(Players, DParent) == nil) then
                    local FakePlr = InstanceNew("Player");
                    FakePlr.Character = DParent
                    FakePlr.Name = format("%s %s", DParent.Name, "- " .. Descendant.DisplayName);
                    NPCs[#NPCs + 1] = FakePlr
                end
            end
            return NPCs
        end,
        ["ben"] = function() return {LocalPlayer} end
    }

    if (PlayerArgs[str]) then return PlayerArgs[str](); end

    local Players = filter(CurrentPlayers, function(i, v) return (sub(lower(v.Name), 1, #str) == str) or (sub(lower(v.DisplayName), 1, #str) == str); end)
    if (not next(Players) and not noerror) then Utils.Notify(LocalPlayer, "Hata", format("%s oyuncusu bulunamadı", str)); end
    return Players
end

local AddConnection = function(Connection, CEnv, TblOnly)
    if (CEnv) then CEnv[#CEnv + 1] = Connection if (TblOnly) then return Connection end end
    Connections[#Connections + 1] = Connection
    return Connection
end

local LastCommand = {}

-- [ui] Kullanıcı Arayüzü
Guis = {}
ParentGui = function(Gui, Parent)
    Gui.Name = sub(gsub(GenerateGUID(Services.HttpService, false), '-', ''), 1, random(25, 30))
    ProtectInstance(Gui);
    if (syn and syn.protect_gui) then syn.protect_gui(Gui); end
    Gui.Parent = Parent or Services.CoreGui
    Guis[#Guis + 1] = Gui
    return Gui
end
UI = Clone(Services.InsertService:LoadLocalAsset("rbxassetid://7882275026"));
UI.Enabled = true

local CommandBarPrefix;
local ConfigUI = UI.Config
local ConfigElements = ConfigUI.GuiElements
local CommandBar = UI.CommandBar
local Commands = UI.Commands
local ChatLogs = UI.ChatLogs
local Console = UI.Console
local GlobalChatLogs = Clone(UI.ChatLogs);
local HttpLogs = Clone(UI.ChatLogs);
local Notification = UI.Notification
local Command = UI.Command
local ChatLogMessage = UI.Message
local GlobalChatLogMessage = Clone(UI.Message);
local NotificationBar = UI.NotificationBar

CommandBarOpen = false
CommandBarTransparencyClone = Clone(CommandBar);
ChatLogsTransparencyClone = Clone(ChatLogs);
ConsoleTransparencyClone = Clone(Console);
GlobalChatLogsTransparencyClone = Clone(GlobalChatLogs);
HttpLogsTransparencyClone = Clone(HttpLogs);
CommandsTransparencyClone = nil
ConfigUIClone = Clone(ConfigUI);
PredictionText = ""
do
    local UIParent = CommandBar.Parent
    GlobalChatLogs.Parent = UIParent
    GlobalChatLogMessage.Parent = UIParent
    GlobalChatLogs.Name = "GenelSohbetKayıtları"
    GlobalChatLogMessage.Name = "GenelSohbetKaydıMesajı"

    HttpLogs.Parent = UIParent
    HttpLogs.Name = "HttpKayıtları"
    HttpLogs.Size = UDim2.new(0, 421, 0, 260);
    HttpLogs.Search.PlaceholderText = "Ara"
end
CommandBar.Position = UDim2.new(0.5, -100, 1, 5);

local UITheme, Values;
do
    local BaseBGColor = Color3.fromRGB(32, 33, 36);
    local BaseTransparency = 0.25
    local BaseTextColor = Color3.fromRGB(220, 224, 234);
    local BaseValues = { BackgroundColor = BaseBGColor, Transparency = BaseTransparency, TextColor = BaseTextColor }
    Values = { Background = clone(BaseValues), CommandBar = clone(BaseValues), CommandList = clone(BaseValues), Notification = clone(BaseValues), ChatLogs = clone(BaseValues), Config = clone(BaseValues) }
    local Objects = keys(Values);
    local GetBaseMT = function(Object)
        return setmetatable({}, {
            __newindex = function(self, Index, Value)
                local type = typeof(Value);
                if (Index == "BackgroundColor") then
                    if (Value == "Reset") then Value = BaseBGColor type = "Color3" end
                    assert(type == 'Color3', format("Geçersiz argüman #3 (Color3 bekleniyor, %s alındı)", type));
                    if (Object == "Background") then
                        CommandBar.BackgroundColor3 = Value
                        Notification.BackgroundColor3 = Value
                        Command.BackgroundColor3 = Value
                        ChatLogs.BackgroundColor3 = Value
                        ChatLogs.Frame.BackgroundColor3 = Value
                        Console.BackgroundColor3 = Value
                        Console.Frame.BackgroundColor3 = Value
                        HttpLogs.BackgroundColor3 = Value
                        HttpLogs.Frame.BackgroundColor3 = Value
                        UI.ToolTip.BackgroundColor3 = Value
                        ConfigUI.BackgroundColor3 = Value
                        ConfigUI.Container.BackgroundColor3 = Value
                        Commands.BackgroundColor3 = Value
                        Commands.Frame.BackgroundColor3 = Value
                        local Children = GetChildren(UI.NotificationBar);
                        for i = 1, #Children do local Child = Children[i] if (IsA(Child, "GuiObject")) then Child.BackgroundColor3 = Value end end
                        local Children = GetChildren(Commands.Frame.List);
                        for i = 1, #Children do local Child = Children[i] if (IsA(Child, "GuiObject")) then Child.BackgroundColor3 = Value end end
                        for i, v in next, Values do Values[i].BackgroundColor = Value end
                    elseif (Object == "CommandBar") then CommandBar.BackgroundColor3 = Value
                    elseif (Object == "Notification") then Notification.BackgroundColor3 = Value local Children = GetChildren(UI.NotificationBar); for i = 1, #Children do local Child = Children[i] if (IsA(Child, "GuiObject")) then Child.BackgroundColor3 = Value end end
                    elseif (Object == "CommandList") then Commands.BackgroundColor3 = Value Commands.Frame.BackgroundColor3 = Value
                    elseif (Object == "Command") then Command.BackgroundColor3 = Value
                    elseif (Object == "ChatLogs") then ChatLogs.BackgroundColor3 = Value ChatLogs.Frame.BackgroundColor3 = Value HttpLogs.BackgroundColor3 = Value HttpLogs.Frame.BackgroundColor3 = Value
                    elseif (Object == "Console") then Console.BackgroundColor3 = Value Console.Frame.BackgroundColor3 = Value
                    elseif (Object == "Config") then ConfigUI.BackgroundColor3 = Value ConfigUI.Container.BackgroundColor3 = Value
                    end
                    Values[Object][Index] = Value
                elseif (Index == "TextColor") then
                    if (Value == "Reset") then Value = BaseTextColor type = "Color3" end
                    assert(type == 'Color3', format("Geçersiz argüman #3 (Color3 bekleniyor, %s alındı)", type));
                    if (Object == "Notification") then Notification.Title.TextColor3 = Value Notification.Message.TextColor3 = Value Notification.Close.TextColor3 = Value
                    elseif (Object == "CommandBar") then CommandBar.Input.TextColor3 = Value CommandBar.Arrow.TextColor3 = Value
                    elseif (Object == "CommandList") then Command.CommandText.TextColor3 = Value local Descendants = GetDescendants(Commands); for i = 1, #Descendants do local Descendant = Descendants[i] local IsText = IsA(Descendant, "TextBox") or IsA(Descendant, "TextLabel") or IsA(Descendant, "TextButton"); if (IsText) then Descendant.TextColor3 = Value end end
                    elseif (Object == "ChatLogs") then UI.Message.TextColor3 = Value
                    elseif (Object == "Config") then local Descendants = GetDescendants(ConfigUI); for i = 1, #Descendants do local Descendant = Descendants[i] local IsText = IsA(Descendant, "TextBox") or IsA(Descendant, "TextLabel") or IsA(Descendant, "TextButton"); if (IsText) then Descendant.TextColor3 = Value end end
                    elseif (Object == "Background") then Notification.Title.TextColor3 = Value Notification.Message.TextColor3 = Value Notification.Close.TextColor3 = Value CommandBar.Input.TextColor3 = Value CommandBar.Arrow.TextColor3 = Value Command.CommandText.TextColor3 = Value UI.Message.TextColor3 = Value local Descendants = GetDescendants(ConfigUI); for i = 1, #Descendants do local Descendant = Descendants[i] local IsText = IsA(Descendant, "TextBox") or IsA(Descendant, "TextLabel") or IsA(Descendant, "TextButton"); if (IsText) then Descendant.TextColor3 = Value end end local Descendants = GetDescendants(Commands); for i = 1, #Descendants do local Descendant = Descendants[i] local IsText = IsA(Descendant, "TextBox") or IsA(Descendant, "TextLabel") or IsA(Descendant, "TextButton"); if (IsText) then Descendant.TextColor3 = Value end end
                    end
                end
            end
        })
    end
end

-- [uimore] Arayüz Daha Fazla (Değişmedi, sadece Türkçe ekler)
Utils.Click(ConfigUI.Close, "TextColor3")
AddConnection(CConnect(ConfigUI.Close.MouseButton1Click, function()
    ConfigLoaded = false
    CWait(Utils.TweenAllTrans(ConfigUI, .25).Completed);
    ConfigUI.Visible = false
end))

-- [plugin] Eklentiler
PluginConf = IsSupportedExploit and GetPluginConfig();
local Plugins;

PluginLibrary = {
    LocalPlayer = LocalPlayer,
    Services = Services,
    GetCharacter = GetCharacter,
    ProtectInstance = ProtectInstance,
    SpoofInstance = SpoofInstance,
    SpoofProperty = SpoofProperty,
    UnSpoofInstance = UnSpoofInstance,
    ReplaceCharacter = ReplaceCharacter,
    ReplaceHumanoid = ReplaceHumanoid,
    GetCorrectToolWithHandle = GetCorrectToolWithHandle,
    DisableAnimate = DisableAnimate,
    GetPlayer = GetPlayer,
    GetHumanoid = GetHumanoid,
    GetRoot = GetRoot,
    GetMagnitude = GetMagnitude,
    GetCommandEnv = function(Name) local Command = LoadCommand(Name); if (Command.CmdEnv) then return Command.CmdEnv end end,
    isR6 = isR6,
    ExecuteCommand = ExecuteCommand,
    Notify = Utils.Notify,
    HasTool = HasTool,
    isSat = isSat,
    Request = syn and syn.request or request or game.HttpGet,
    CThread = CThread,
    AddConnection = AddConnection,
    filter = filter,
    map = map,
    clone = clone,
    firetouchinterest = firetouchinterest,
    fireproximityprompt = fireproximityprompt,
    decompile = decompile,
    getnilinstances = getnilinstances,
    getinstances = getinstances,
    Drawing = Drawing
}

do
    local IsDebug = IsSupportedExploit and PluginConf.PluginDebug

    Plugins = IsSupportedExploit and map(filter(listfiles("fates-admin/plugins"), function(i, v) return lower(split(v, ".")[#split(v, ".")]) == "lua" end), function(i, v) local splitted = split(v, "\\"); return {splitted[#splitted], loadfile(v)} end) or {}

    if (PluginConf.PluginsEnabled) then
        local LoadPlugin = function(Plugin)
            if (not IsSupportedExploit) then return end
            if (Plugin and PluginConf.DisabledPlugins[Plugin.Name]) then Utils.Notify(LocalPlayer, "Eklenti Yüklenmedi", format("Eklenti %s devre dışı listesinde olduğu için yüklenmedi.", Plugin.Name)); return "Devre Dışı" end
            if (#keys(Plugin) < 3) then return Utils.Notify(LocalPlayer, "Eklenti Hatası", "Eklentilerden biri eksik bilgi içeriyor."); end
            if (IsDebug) then Utils.Notify(LocalPlayer, "Eklenti Yükleniyor", format("Eklenti %s yükleniyor.", Plugin.Name)); end
            
            local Context;
            local sett, gett = setthreadidentity, getthreadidentity
            if (sett and PluginConf.SafePlugins) then Context = gett(); sett(5); end
            local Ran, Return = pcall(Plugin.Init);
            if (sett and Context) then sett(Context); end
            if (not Ran and Return and IsDebug) then return Utils.Notify(LocalPlayer, "Eklenti Hatası", format("%s eklentisinde başlatma hatası: %s", Plugin.Name, Return)); end
            
            for i, command in next, Plugin.Commands or {} do
                if (#keys(command) < 3) then Utils.Notify(LocalPlayer, "Eklenti Komut Hatası", format("%s komutu eksik bilgi içeriyor", command.Name)); continue end
                AddCommand(command.Name, command.Aliases or {}, command.Description .. " - " .. Plugin.Author, command.Requirements or {}, command.Func, true);
                if (FindFirstChild(Commands.Frame.List, command.Name)) then Destroy(FindFirstChild(Commands.Frame.List, command.Name)); end
                local Clone = Clone(Command);
                Utils.Hover(Clone, "BackgroundColor3");
                Utils.ToolTip(Clone, format("%s\n%s - %s", command.Name, command.Description, Plugin.Author));
                Clone.CommandText.RichText = true
                Clone.CommandText.Text = format("%s %s %s", command.Name, next(command.Aliases or {}) and format("(%s)", concat(command.Aliases, ", ")) or "", Utils.TextFont("[EKLENTİ]", {77, 255, 255}));
                Clone.Name = command.Name
                Clone.Visible = true
                Clone.Parent = Commands.Frame.List
                if (IsDebug) then Utils.Notify(LocalPlayer, "Eklenti Komutu Yüklendi", format("%s komutu başarıyla yüklendi", command.Name)); end
            end
        end
        
        if (IsSupportedExploit) then
            if (not isfolder("fates-admin") and not isfolder("fates-admin/plugins") and not isfolder("fates-admin/plugin-conf.json") or not isfolder("fates-admin/chatlogs")) then WriteConfig(); end
        end

        for i, Plugin in next, Plugins do
            local PluginFunc = Plugin[2]
            if (PluginConf.SafePlugins) then setfenv(PluginFunc, PluginLibrary); else local CurrentEnv = getfenv(PluginFunc); for i2, v2 in next, PluginLibrary do CurrentEnv[i2] = v2 end end
            local Success, Ret = pcall(PluginFunc);
            if (Success) then LoadPlugin(Ret); elseif (PluginConf.PluginDebug) then Utils.Notify(LocalPlayer, "Hata", "Eklenti yüklenirken hata oluştu (daha fazla bilgi için konsola bak)"); warn("[FA Eklenti Hatası]: " .. debug.traceback(Ret)); end
        end
        
        AddCommand("eklentileriyenile", {"rfp", "yenilep", "tekraryüklep"}, "Yeni eklentileri yükler.", {}, function()
            if (not IsSupportedExploit) then return "Kullandığınız exploit eklentileri desteklemiyor" end
            PluginConf = GetPluginConfig();
            IsDebug = PluginConf.PluginDebug
            Plugins = map(filter(listfiles("fates-admin/plugins"), function(i, v) return lower(split(v, ".")[#split(v, ".")]) == "lua" end), function(i, v) return {split(v, "\\")[2], loadfile(v)} end)
            for i, Plugin in next, Plugins do
                local PluginFunc = Plugin[2]
                setfenv(PluginFunc, PluginLibrary);
                local Success, Ret = pcall(PluginFunc);
                if (Success) then LoadPlugin(Ret); elseif (PluginConf.PluginDebug) then Utils.Notify(LocalPlayer, "Hata", "Eklenti yüklenirken hata oluştu (konsola bak)"); warn("[FA Eklenti Hatası]: " .. debug.traceback(Ret)); end
            end
        end)
    end
end
-- [plugin] Bitiş

WideBar = false
Draggable = false

-- [config] Yapılandırma
do
    local UserInputService = Services.UserInputService
    local GetStringForKeyCode = UserInputService.GetStringForKeyCode
    local function GetKeyName(KeyCode)
        local _, Stringed = pcall(GetStringForKeyCode, UserInputService, KeyCode);
        local IsEnum = Stringed == ""
        return (not IsEnum and _) and Stringed or split(tostring(KeyCode), ".")[3], (IsEnum and not _);
    end

    local SortKeys = function(Key1, Key2)
        local KeyName, IsEnum = GetKeyName(Key1);
        if (Key2) then local KeyName2, IsEnum2 = GetKeyName(Key2); return format("%s + %s", IsEnum2 and KeyName2 or KeyName, IsEnum2 and KeyName2 or KeyName2); end
        return KeyName
    end

    LoadConfig = function()
        local Script = ConfigUILib.NewPage("Script");
        local Settings = Script.NewSection("Ayarlar");
    
        local CurrentConf = GetConfig();

        Settings.TextboxKeybind("Sohbet Öneki", Prefix, function(Key)
            if (not match(Key, "%A") or match(Key, "%d") or #Key > 1) then Utils.Notify(nil, "Önek", "Önek 1 karakterlik bir sembol olmalı."); return end
            Prefix = Key
            Utils.Notify(nil, "Önek", "Önek artık " .. Key);
        end)
    
        Settings.Keybind("Komut Çubuğu Öneki", GetKeyName(CommandBarPrefix), function(KeyCode1, KeyCode2)
            CommandBarPrefix = KeyCode1
            Utils.Notify(nil, "Önek", "Komut Çubuğu Öneki artık " .. GetKeyName(KeyCode1));
        end)
    
        local ToggleSave;
        ToggleSave = Settings.Toggle("Önekleri Kaydet", false, function(Callback)
            SetConfig({["Prefix"]=Prefix, ["CommandBarPrefix"]=split(tostring(CommandBarPrefix), ".")[3]});
            wait(.5);
            ToggleSave();
            Utils.Notify(nil, "Önek", "Önekler kaydedildi");
        end)
    
        local Misc = Script.NewSection("Çeşitli");

        Misc.Toggle("Sohbet Tahmini", CurrentConf.ChatPrediction or false, function(Callback)
            local ChatBar = ToggleChatPrediction();
            if (Callback) then ChatBar.CaptureFocus(ChatBar); wait(); ChatBar.Text = Prefix end
            SetConfig({ChatPrediction=Callback});
            Utils.Notify(nil, nil, format("Sohbet Tahmini %s", Callback and "açık" or "kapalı"));
        end)

        Misc.Toggle("Atılma Koruması", Hooks.AntiKick, function(Callback)
            Hooks.AntiKick = Callback
            Utils.Notify(nil, nil, format("Atılma Koruması %s", Hooks.AntiKick and "açık" or "kapalı"));
        end)

        Misc.Toggle("Işınlanma Koruması", Hooks.AntiTeleport, function(Callback)
            Hooks.AntiTeleport = Callback
            Utils.Notify(nil, nil, format("Işınlanma Koruması %s", Hooks.AntiTeleport and "açık" or "kapalı"));
        end)

        Misc.Toggle("Geniş Komut Çubuğu", WideBar, function(Callback)
            WideBar = Callback
            if (not Draggable) then Utils.Tween(CommandBar, "Quint", "Out", .5, {Position = UDim2.new(0.5, WideBar and -200 or -100, 1, 5)}) end
            Utils.Tween(CommandBar, "Quint", "Out", .5, {Size = UDim2.new(0, WideBar and 400 or 200, 0, 35)})
            SetConfig({WideBar=Callback});
            Utils.Notify(nil, nil, format("Geniş Çubuk %s", WideBar and "açık" or "kapalı"));
        end)

        Misc.Toggle("Sürüklenebilir Komut Çubuğu", Draggable, function(Callback)
            Draggable = Callback
            CommandBarOpen = true
            Utils.Tween(CommandBar, "Quint", "Out", .5, {Position = UDim2.new(0, Mouse.X, 0, Mouse.Y + 36)});
            Utils.Draggable(CommandBar);
            local TransparencyTween = CommandBarOpen and Utils.TweenAllTransToObject or Utils.TweenAllTrans
            local Tween = TransparencyTween(CommandBar, .5, CommandBarTransparencyClone);
            CommandBar.Input.Text = ""
            if (not Callback) then Utils.Tween(CommandBar, "Quint", "Out", .5, {Position = UDim2.new(0.5, WideBar and -200 or -100, 1, 5)}) end
            Utils.Notify(nil, nil, format("Sürüklenebilir Komut Çubuğu %s", Draggable and "açık" or "kapalı"));
        end)

        Misc.Toggle("Öldürme Kamerası", CurrentConf.KillCam, function(Callback)
            SetConfig({KillCam=Callback});
            _L.KillCam = Callback
        end)

        local OldFireTouchInterest = firetouchinterest
        Misc.Toggle("CFrame Dokunma", firetouchinterest == nil, function(Callback)
            firetouchinterest = Callback and function(part1, part2, toggle)
                if (part1 and part2) then if (toggle == 0) then touched[1] = part1.CFrame part1.CFrame = part2.CFrame else part1.CFrame = touched[1] touched[1] = nil end end
            end or OldFireTouchInterest
        end)

        local MacrosPage = ConfigUILib.NewPage("Makrolar");
        local MacroSection;
        MacroSection = MacrosPage.CreateMacroSection(Macros, function(Bind, Command, Args)
            local AlreadyAdded = false
            for i = 1, #Macros do if (Macros[i].Command == Command) then AlreadyAdded = true end end
            if (CommandsTable[Command] and not AlreadyAdded) then
                MacroSection.AddMacro(Command .. " " .. Args, SortKeys(Bind[1], Bind[2]));
                Args = split(Args, " ");
                if (sub(Command, 1, 2) == "un" or CommandsTable["un" .. Command]) then
                    local Shifted = {Command, unpack(Args)}
                    Macros[#Macros + 1] = {Command = "toggle", Args = Shifted, Keys = Bind}
                else
                    Macros[#Macros + 1] = {Command = Command, Args = Args, Keys = Bind}
                end
                local TempMacros = clone(Macros);
                for i, v in next, TempMacros do for i2, v2 in next, v.Keys do TempMacros[i]["Keys"][i2] = split(tostring(v2), ".")[3] end end
                SetConfig({Macros=TempMacros});
            end
        end)
        local UIListLayout = MacroSection.CommandsList.UIListLayout
        for i, v in next, CommandsTable do
            if (not FindFirstChild(MacroSection.CommandsList, v.Name)) then MacroSection.AddCmd(v.Name); end
        end
        MacroSection.CommandsList.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y);
        local Search = FindFirstChild(MacroSection.CommandsList.Parent.Parent, "Search");

        AddConnection(CConnect(GetPropertyChangedSignal(Search, "Text"), function()
            local Text = Search.Text
            for _, v in next, GetChildren(MacroSection.CommandsList) do
                if (IsA(v, "TextButton")) then local Command = v.Text v.Visible = Sfind(lower(Command), Text, 1, true) end
            end
            MacroSection.CommandsList.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y);
        end), Connections.UI, true);
        
        local PluginsPage = ConfigUILib.NewPage("Eklentiler");
        local CurrentPlugins = PluginsPage.NewSection("Mevcut Eklentiler");
        local PluginSettings = PluginsPage.NewSection("Eklenti Ayarları");
    
        local CurrentPluginConf = GetPluginConfig();
    
        CurrentPlugins.ScrollingFrame("eklentiler", function(Option, Enabled)
            CurrentPluginConf = GetPluginConfig();
            for i = 1, #Plugins do
                local Plugin = Plugins[i]
                if (Plugin[1] == Option) then
                    local DisabledPlugins = CurrentPluginConf.DisabledPlugins
                    local PluginName = Plugin[2]().Name
                    if (Enabled) then
                        DisabledPlugins[PluginName] = nil
                        SetPluginConfig({DisabledPlugins=DisabledPlugins});
                        Utils.Notify(nil, "Eklenti Açıldı", format("%s eklentisi başarıyla açıldı", PluginName));
                    else
                        DisabledPlugins[PluginName] = true
                        SetPluginConfig({DisabledPlugins=DisabledPlugins});
                        Utils.Notify(nil, "Eklenti Kapatıldı", format("%s eklentisi başarıyla kapatıldı", PluginName));
                    end
                end
            end
        end, map(Plugins, function(Key, Plugin) return not PluginConf.DisabledPlugins[Plugin[2]().Name], Plugin[1] end));
    
        PluginSettings.Toggle("Eklentiler Açık", CurrentPluginConf.PluginsEnabled, function(Callback) SetPluginConfig({PluginsEnabled = Callback}); end)
        PluginSettings.Toggle("Eklenti Hata Ayıklama", CurrentPluginConf.PluginDebug, function(Callback) SetPluginConfig({PluginDebug = Callback}); end)
        PluginSettings.Toggle("Güvenli Eklentiler", CurrentPluginConf.SafePlugins, function(Callback) SetPluginConfig({SafePlugins = Callback}); end)

        local Themes = ConfigUILib.NewPage("Temalar");
        local Color = Themes.NewSection("Renkler");
        local Options = Themes.NewSection("Seçenekler");

        local RainbowEnabled = false
        Color.ColorPicker("Tüm Arka Plan", UITheme.Background.BackgroundColor, function(Callback, IsRainbow) UITheme.Background.BackgroundColor = Callback RainbowEnabled = IsRainbow end)
        Color.ColorPicker("Komut Çubuğu", UITheme.CommandBar.BackgroundColor, function(Callback) if (not RainbowEnabled) then UITheme.CommandBar.BackgroundColor = Callback end end)
        Color.ColorPicker("Bildirim", UITheme.Notification.BackgroundColor, function(Callback) if (not RainbowEnabled) then UITheme.Notification.BackgroundColor = Callback end end)
        Color.ColorPicker("Sohbet Kayıtları", UITheme.ChatLogs.BackgroundColor, function(Callback) if (not RainbowEnabled) then UITheme.ChatLogs.BackgroundColor = Callback end end)
        Color.ColorPicker("Komut Listesi", UITheme.CommandList.BackgroundColor, function(Callback) if (not RainbowEnabled) then UITheme.CommandList.BackgroundColor = Callback end end)
        Color.ColorPicker("Yapılandırma", UITheme.Config.BackgroundColor, function(Callback) if (not RainbowEnabled) then UITheme.Config.BackgroundColor = Callback end end)
        Color.ColorPicker("Tüm Metin", UITheme.Background.TextColor, function(Callback) UITheme.Background.TextColor = Callback end)

        local ToggleSave;
        ToggleSave = Options.Toggle("Temayı Kaydet", false, function(Callback) WriteThemeConfig(); wait(.5); ToggleSave(); Utils.Notify(nil, "Tema", "Tema kaydedildi"); end)
        local ToggleLoad;
        ToggleLoad = Options.Toggle("Temayı Yükle", false, function(Callback) LoadTheme(GetThemeConfig()); wait(.5); ToggleLoad(); Utils.Notify(nil, "Tema", "Tema yüklendi"); end)
        local ToggleReset;
        ToggleReset = Options.Toggle("Temayı Sıfırla", false, function(Callback)
            UITheme.Background.BackgroundColor = "Reset" UITheme.Notification.TextColor = "Reset" UITheme.CommandBar.TextColor = "Reset" UITheme.CommandList.TextColor = "Reset" UITheme.ChatLogs.TextColor = "Reset" UITheme.Config.TextColor = "Reset" UITheme.Notification.Transparency = "Reset" UITheme.CommandBar.Transparency = "Reset" UITheme.CommandList.Transparency = "Reset" UITheme.ChatLogs.Transparency = "Reset" UITheme.Config.Transparency = "Reset"
            wait(.5); ToggleReset(); Utils.Notify(nil, "Tema", "Tema sıfırlandı");
        end)
    end

    delay(1, function()
        for i = 1, #Macros do local Macro = Macros[i] for i2 = 1, #Macro.Keys do Macros[i].Keys[i2] = Enum.KeyCode[Macros[i].Keys[i2]] end end
        if (CurrentConfig.WideBar) then WideBar = true Utils.Tween(CommandBar, "Quint", "Out", .5, {Size = UDim2.new(0, WideBar and 400 or 200, 0, 35)}) end
        KillCam = CurrentConfig.KillCam
        local Aliases = CurrentConfig.Aliases
        if (Aliases) then for i, v in next, Aliases do if (CommandsTable[i]) then for i2 = 1, #v do local Alias = v[i2] local Add = CommandsTable[i] Add.Name = Alias CommandsTable[Alias] = Add end end end end
    end)
end
-- [config] Bitiş

AddConnection(CConnect(CommandBar.Input.FocusLost, function()
    local Text = trim(CommandBar.Input.Text);
    local CommandArgs = split(Text, " ");
    CommandBarOpen = false
    if (not Draggable) then Utils.TweenAllTrans(CommandBar, .5) Utils.Tween(CommandBar, "Quint", "Out", .5, {Position = UDim2.new(0.5, WideBar and -200 or -100, 1, 5)}) end
    local Command = CommandArgs[1]
    local Args = shift(CommandArgs);
    if (Command ~= "") then ExecuteCommand(Command, Args, LocalPlayer); end
end), Connections.UI, true);

local PlayerAdded = function(plr)
    RespawnTimes[plr.Name] = tick();
    AddConnection(CConnect(plr.CharacterAdded, function() RespawnTimes[plr.Name] = tick(); end));
end

forEach(GetPlayers(Players), function(i,v) PlayerAdded(v); end);
AddConnection(CConnect(Players.PlayerAdded, function(plr) PlayerAdded(plr); end))
AddConnection(CConnect(Players.PlayerRemoving, function(plr)
    if (Connections.Players[plr.Name]) then if (Connections.Players[plr.Name].ChatCon) then Disconnect(Connections.Players[plr.Name].ChatCon); end Connections.Players[plr.Name] = nil end
    if (RespawnTimes[plr.Name]) then RespawnTimes[plr.Name] = nil end
end))

getgenv().F_A = {Utils = Utils, PluginLibrary = PluginLibrary, GetConfig = GetConfig}

Utils.Notify(LocalPlayer, "Yüklendi", format("Script %.3f saniyede yüklendi", (tick()) - _L.start));
Utils.Notify(LocalPlayer, "Hoş Geldiniz", "'komutlar' ile tüm komutları görün, 'yapılandırma' ile scripti özelleştirin");
if (debug.info(2, "f") == nil) then Utils.Notify(LocalPlayer, "Eski Script", "Güncellemeler için loadstring kullanın (https://fatesc/fates-admin)", 10); end
_L.LatestCommit = JSONDecode(Services.HttpService, game.HttpGetAsync(game, "https://api.github.com/repos/fatesc/fates-admin/commits?per_page=1&path=main.lua"))[1]
wait(1);
Utils.Notify(LocalPlayer, "En Yeni Güncelleme", format("%s - %s", _L.LatestCommit.commit.message, _L.LatestCommit.commit.author.name));