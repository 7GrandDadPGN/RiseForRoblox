local riseoptions = {
    CustomText = "",
    Theme = "Rise Blend",
    RenderToggle = true,
    ShowRenderModules = true,
    NameTags = false,
    R = 1,
    G = 1,
    B = 1
}

local risethemes = {
    ["Rise Blend"] = {
        TextGUIColor1 = Color3.fromRGB(71, 233, 160),
        TextGUIColor2 = Color3.fromRGB(71, 148, 253),
    },
    ["Rise"] = {
        TextGUIColor1 = Color3.fromRGB(255, 255, 255),
        TextGUIColor2 = Color3.fromRGB(255, 255, 255),
    },
    ["Rise Christmas"] = {
        TextGUIColor1 = Color3.fromRGB(255, 12, 12),
        TextGUIColor2 = Color3.fromRGB(255, 255, 255),
    },
    ["Rise Cotton Candy"] = {
        TextGUIColor1 = Color3.fromRGB(241, 111, 204),
        TextGUIColor2 = Color3.fromRGB(101, 246, 254),
    },
    ["Rice"] = {
        TextGUIColor1 = Color3.fromRGB(190, 0, 255),
        TextGUIColor2 = Color3.fromRGB(0, 190, 255),
    },
}

if isfolder("rise") == false then
	makefolder("rise")
end
if isfolder("rise/assets") == false then
	makefolder("rise/assets")
end

local function SaveSettings()
    writefile("rise/settings.json", game:GetService("HttpService"):JSONEncode(riseoptions))
end

local players = game:GetService("Players")
local lplr = players.LocalPlayer
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
    if tab.Method == "GET" then
        return {
            Body = game:HttpGet(tab.Url, true),
            Headers = {},
            StatusCode = 200
        }
    else
        return {
            Body = "bad exploit",
            Headers = {},
            StatusCode = 404
        }
    end
end 
local betterisfile = function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil
end
local setthreadidentityfunc = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity
local getthreadidentityfunc = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity
local function GetURL(scripturl, rise)
    if shared.VapeDeveloper then
        if not betterisfile((rise and "rise/" or "vape/")..scripturl) then
            error("File not found : "..(rise and "rise/" or "vape/")..scripturl)
        end
        return readfile((rise and "rise/" or "vape/")..scripturl)
    else
        local res = game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/"..(rise and "RiseForRoblox" or "VapeV4ForRoblox").."/main/"..scripturl, true)
        assert(res ~= "404: Not Found", "File not found")
        return res
    end
end
local VapeGui
local universalcolor = Color3.new(1, 1, 1)
local targetinfohealthbar
local guilib = loadstring(GetURL("guilib.lua", true))()
guilib.ScreenGui.MainFrame.Visible = false
spawn(function()
    repeat task.wait() until shared.GuiLibrary
    VapeGui = shared.GuiLibrary
    local notificationwindow = Instance.new("Frame")
    notificationwindow.Size = UDim2.new(1, 0, 1, 0)
    notificationwindow.BackgroundTransparency = 1
    notificationwindow.Parent = guilib.ScreenGui
    spawn(function()
        local num = 0
        repeat
            task.wait(0.01)
            local colornew = risethemes[riseoptions.Theme].TextGUIColor1
            if num < 1 then
                colornew = risethemes[riseoptions.Theme].TextGUIColor1:lerp(risethemes[riseoptions.Theme].TextGUIColor2, num)
            elseif num < 2 then 
                colornew = risethemes[riseoptions.Theme].TextGUIColor2:lerp(risethemes[riseoptions.Theme].TextGUIColor1, num - 1)
            else
                num = 0
            end
            if targetinfohealthbar then
                targetinfohealthbar.BackgroundColor3 = colornew
            end
            universalcolor = colornew
            for i,v in pairs(notificationwindow:GetChildren()) do 
                if v:IsA("Frame") then 
                    pcall(function()
                        v.Frame.BackgroundColor3 = colornew
                        v.TextLabel.TextColor3 = colornew
                        v.TextLabel2.TextColor3 = colornew
                    end)
                end
            end
            num = num + 0.03
        until guilib.ScreenGui == nil or guilib.ScreenGui.Parent == nil
    end)

    local function bettertween(obj, newpos, dir, style, tim, override)
        spawn(function()
            local frame = Instance.new("Frame")
            frame.Visible = false
            frame.Position = obj.Position
            frame.Parent = guilib.ScreenGui
            frame:GetPropertyChangedSignal("Position"):connect(function()
                obj.Position = UDim2.new(obj.Position.X.Scale, obj.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset)
            end)
            frame:TweenPosition(newpos, dir, style, tim, override)
            frame.Parent = nil
            task.wait(tim)
            frame:Remove()
        end)
    end

    local function bettertween2(obj, newpos, dir, style, tim, override)
        spawn(function()
            local frame = Instance.new("Frame")
            frame.Visible = false
            frame.Position = obj.Position
            frame.Parent = guilib.ScreenGui
            frame:GetPropertyChangedSignal("Position"):connect(function()
                obj.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, obj.Position.Y.Scale, obj.Position.Y.Offset)
            end)
            pcall(function()
                frame:TweenPosition(newpos, dir, style, tim, override)
            end)
            frame.Parent = nil
            task.wait(tim)
            frame:Remove()
        end)
    end

    notificationwindow.ChildRemoved:connect(function()
        for i,v in pairs(notificationwindow:GetChildren()) do
            bettertween(v, UDim2.new(1, v.Position.X.Offset, 1, -(150 + 80 * (i - 1))), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.15, true)
        end
    end)

    local function removeTags(str)
        str = str:gsub("<br%s*/>", "\n")
        return (str:gsub("<[^<>]->", ""))
    end

    VapeGui.CreateNotification = function(top, bottom, duration, customicon)
        local offset = #notificationwindow:GetChildren()
        local togglecheck = (bottom:find("Enabled") or bottom:find("Disabled"))
        if (togglecheck and (not riseoptions.RenderToggle)) then return end
        local togglecheck2 = bottom:find("Enabled") and true or false
        local newtext = removeTags(togglecheck and (togglecheck2 and "Enabled " or "Disabled ")..bottom:split(" ")[1] or bottom)
        local calculatedsize = game:GetService("TextService"):GetTextSize(newtext, 13, Enum.Font.Gotham, Vector2.new(100000, 13))
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, calculatedsize.X + 20, 0, 60)
        frame.Position = UDim2.new(1, 0, 1, -(150 + 80 * offset))
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = Color3.new(0, 0,0)
        frame.BorderSizePixel = 0
        frame.Parent = notificationwindow
        frame.Visible = true
        frame.ClipsDescendants = false
        local uicorner = Instance.new("UICorner")
        uicorner.CornerRadius = UDim.new(0, 4)
        uicorner.Parent = frame
        local textlabel1 = Instance.new("TextLabel")
        textlabel1.Font = Enum.Font.Gotham
        textlabel1.TextSize = 13
        textlabel1.RichText = true
        textlabel1.TextTransparency = 0.1
        textlabel1.TextColor3 = risethemes[riseoptions.Theme].TextGUIColor1
        textlabel1.BackgroundTransparency = 1
        textlabel1.Position = UDim2.new(0, 10, 0, 10)
        textlabel1.TextXAlignment = Enum.TextXAlignment.Left
        textlabel1.TextYAlignment = Enum.TextYAlignment.Top
        textlabel1.Text = "Notification"
        textlabel1.Parent = frame
        local textlabel2 = textlabel1:Clone()
        textlabel2.Position = UDim2.new(0, 10, 0, 30)
        textlabel2.Font = Enum.Font.Gotham
        textlabel2.Name = "TextLabel2"
        textlabel2.TextTransparency = 0
        textlabel2.RichText = true
        local frame2 = Instance.new("Frame")
        frame2.AnchorPoint = Vector2.new(1, 0)
        frame2.Size = UDim2.new(1, 0, 0, 4)
        frame2.Position = UDim2.new(1, 0, 1, -4)
        frame2.BackgroundColor3 = Color3.fromRGB(71, 233, 175)
        frame2.BorderSizePixel = 0
        frame2.Parent = frame
        textlabel2.Text = newtext
        textlabel2.Parent = frame
        spawn(function()
            pcall(function()
                bettertween2(frame, UDim2.new(1, -(calculatedsize.X + 20), 1, -(120 + 80 * offset)), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                wait(0.2)
                frame2:TweenSize(UDim2.new(0, 0, 0, 4), Enum.EasingDirection.In, Enum.EasingStyle.Linear, duration, true)
                wait(duration)
                bettertween2(frame, UDim2.new(1, 0, 1, frame.Position.Y.Offset), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
                wait(0.2)
                frame:Remove()
            end)
        end)
        return frame
    end
    VapeGui["MainGui"].ScaledGui.Visible = false
end)
loadstring(GetURL("NewMainScript.lua"))()
shared.VapeIndependent = true
if not VapeGui then VapeGui = shared.GuiLibrary end
local cachedassets = {}
local function getcustomassetfunc(path)
    if not betterisfile(path) then
        spawn(function()
            local textlabel = Instance.new("TextLabel")
            textlabel.Size = UDim2.new(1, 0, 0, 36)
            textlabel.Text = "Downloading "..path
            textlabel.BackgroundTransparency = 1
            textlabel.TextStrokeTransparency = 0
            textlabel.TextSize = 30
            textlabel.Font = Enum.Font.SourceSans
            textlabel.TextColor3 = Color3.new(1, 1, 1)
            textlabel.Position = UDim2.new(0, 0, 0, -36)
            textlabel.Parent = VapeGui["MainGui"]
            repeat wait() until betterisfile(path)
            textlabel:Remove()
        end)
        local req = requestfunc({
            Url = "https://raw.githubusercontent.com/7GrandDadPGN/RiseForRoblox/main/"..path:gsub("rise/assets", "assets"),
            Method = "GET"
        })
        writefile(path, req.Body)
    end
    if cachedassets[path] == nil then
        cachedassets[path] = getasset(path) 
    end
    return cachedassets[path]
end

local teleportfunc = game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
		local teleportstr = 'shared.VapeSwitchServers = true if shared.VapeDeveloper then loadstring(readfile("rise/main.lua"))() else loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/RiseForRoblox/main/main.lua", true))() end'
		if shared.VapeDeveloper then
			teleportstr = 'shared.VapeDeveloper = true '..teleportstr
		end
		if shared.VapePrivate then
			teleportstr = 'shared.VapePrivate = true '..teleportstr
		end
		VapeGui["SaveSettings"]()
		queueteleport(teleportstr)
    end
end)

local RenderStepTable = {}
local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end
VapeGui["MainGui"].ScaledGui.Visible = false
guilib.ScreenGui.MainFrame.Visible = VapeGui["MainGui"].ScaledGui.ClickGui.Visible
VapeGui["MainGui"].ScaledGui.ClickGui:GetPropertyChangedSignal("Visible"):connect(function()
    guilib.ScreenGui.MainFrame.Visible = VapeGui["MainGui"].ScaledGui.ClickGui.Visible
    task.delay(0.001, function()
        game:GetService("RunService"):SetRobloxGuiFocused(false)	
    end)
    if VapeGui["MainGui"].ScaledGui.ClickGui.Visible then
        guilib.ScreenGui.MainFrame.Size = UDim2.new(0, 664, 0, 560)
        guilib.ScreenGui.MainFrame.Position = UDim2.new(0.5, -264, 0.5, -294)
        guilib.ScreenGui.MainFrame:TweenSize(UDim2.new(0, 830, 0, 700), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
        guilib.ScreenGui.MainFrame:TweenPosition(UDim2.new(0.5, -330, 0.5, -368), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
    end
end)
local windowtabs = {
    Combat = guilib:CreateCategory({
        Name = "Combat",
        Icon = "⚔️"
    }),
    Blatant = guilib:CreateCategory({
        Name = "Blatant",
        Icon = "⚠️"
    }),
    Render = guilib:CreateCategory({
        Name = "Render",
        Icon = "👁️"
    }),
    Utility = guilib:CreateCategory({
        Name = "Utility",
        Icon = "🛠️"
    }),
    World = guilib:CreateCategory({
        Name = "World",
        Icon = "🌎"
    }),
    Info = guilib:CreateCategory({
        Name = "Info",
        Icon = "ℹ️"
    })
}

local infolab1 = windowtabs.Info:CreateLabel()
infolab1.Size = UDim2.new(0, 200, 0, 70)
infolab1.Position = UDim2.new(0, 124, 0, 155)
infolab1.TextColor3 = Color3.fromRGB(180, 180, 180)
infolab1.TextSize = 90
infolab1.Font = Enum.Font.SourceSans
infolab1.Text = "Rise"
infolab1.TextXAlignment = Enum.TextXAlignment.Left
infolab1.TextYAlignment = Enum.TextYAlignment.Bottom
infolab1.BackgroundTransparency = 1
local infolab2 = windowtabs.Info:CreateLabel()
infolab2.Size = UDim2.new(0, 200, 0, 70)
infolab2.Position = UDim2.new(0, 250, 0, 136)
infolab2.TextColor3 = Color3.fromRGB(130, 130, 130)
infolab2.TextSize = 40
infolab2.Font = Enum.Font.SourceSans
infolab2.Text = "roblox"
infolab2.TextXAlignment = Enum.TextXAlignment.Left
infolab2.TextYAlignment = Enum.TextYAlignment.Top
infolab2.BackgroundTransparency = 1
local infolab3 = windowtabs.Info:CreateLabel()
infolab3.Size = UDim2.new(0, 200, 0, 70)
infolab3.Position = UDim2.new(0, 124, 0, 263)
infolab3.TextColor3 = Color3.fromRGB(180, 180, 180)
infolab3.TextSize = 30
infolab3.Font = Enum.Font.SourceSansLight
infolab3.Text = "Registered to xylex"
infolab3.TextXAlignment = Enum.TextXAlignment.Left
infolab3.TextYAlignment = Enum.TextYAlignment.Top
infolab3.BackgroundTransparency = 1
local infolab4 = windowtabs.Info:CreateLabel()
infolab4.Size = UDim2.new(0, 200, 0, 70)
infolab4.Position = UDim2.new(0, 124, 0, 320)
infolab4.TextColor3 = Color3.fromRGB(130, 130, 130)
infolab4.TextSize = 30
infolab4.Font = Enum.Font.SourceSansLight
infolab4.Text = [[
Orignal Client by Alan32, Technio
Strikeless, Nicklas, Auth,
Hazsi, Solastis
and Billionare
intent.store
riseclient.com
    
Roblox Port by 7GrandDad
All rights goto the Rise Team
]]
infolab4.TextXAlignment = Enum.TextXAlignment.Left
infolab4.TextYAlignment = Enum.TextYAlignment.Top
infolab4.BackgroundTransparency = 1

local windowbuttons = {}
local tab = {}
local tab2 = {}
for i,v in pairs(VapeGui["ObjectsThatCanBeSaved"]) do 
    if v.Type == "OptionsButton" then
        table.insert(tab, v)
    end
    if v.Type == "Toggle" then
        table.insert(tab2, v)
    end
    if v.Type == "Slider" then
        table.insert(tab2, v)
    end
    if v.Type == "Dropdown" then
        table.insert(tab2, v)
    end
    if v.Type == "TextBox" then
        table.insert(tab2, v)
    end
    if v.Type == "ColorSlider" then
        table.insert(tab2, v)
    end
end
table.sort(tab, function(a, b) 
    if a.Type ~= "OptionsButton" then
        a = {Object = {Name = tostring(a["Object"].Parent):gsub("Children", "")..a["Object"].Name}}
    else
        a = {Object = {Name = a["Object"].Name}}
    end
    if b.Type ~= "OptionsButton" then
        b = {Object = {Name = tostring(b["Object"].Parent):gsub("Children", "")..b["Object"].Name}}
    else
        b = {Object = {Name = b["Object"].Name}}
    end
    return a["Object"].Name:lower() < b["Object"].Name:lower() 
end)
--[[table.sort(tab2, function(a, b) 
    a = {Object = {Name = tostring(a["Object"].Parent):gsub("Children", "")..a["Object"].Name}}
    b = {Object = {Name = tostring(b["Object"].Parent):gsub("Children", "")..b["Object"].Name}}
    return a["Object"].Name:lower() < b["Object"].Name:lower() 
end)]]
for i,v in pairs(tab) do 
    if v.Type == "OptionsButton" then 
        local old = v["Api"]["ToggleButton"]
        local newstr = tostring(v["Object"]):gsub("Button", "")
        windowbuttons[newstr] = windowtabs[tostring(v["Object"].Parent.Parent)]:CreateButton({
            Name = newstr,
            Function = function(callback)
                if callback ~= v["Api"]["Enabled"] then
                    old(true)
                end
            end,
            HoverText = v["Api"]["HoverText"] or ""
        })
        v["Api"]["ToggleButton"] = function(clicked, toggle)
            local res = old(clicked, toggle)
            windowbuttons[newstr]:ToggleButton(false, v["Api"]["Enabled"])
            return res
        end
        windowbuttons[newstr]:ToggleButton(false, v["Api"]["Enabled"])
    end
end
for i,v in pairs(tab2) do 
    if v.Type == "Toggle" and tostring(v["Object"].Parent.Parent.Parent) ~= "ClickGui" and VapeGui["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and VapeGui["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
        local newstr = tostring(v["Object"].Parent):gsub("Children", "")
        local old = v["Api"]["ToggleButton"]
        local tog = windowbuttons[newstr]:CreateToggle({
            Name = tostring(v["Object"]):gsub("Button", ""),
            Function = function(callback)
                if callback ~= v["Api"]["Enabled"] then
                    old(not v["Api"]["Enabled"])
                end
            end
        })
        v["Api"]["ToggleButton"] = function(clicked, toggle)
            local res = old(clicked, toggle)
            tog:ToggleButton(false, v["Api"]["Enabled"])
            return res
        end
        tog:SetLayoutOrder(v["Object"].LayoutOrder)
        tog:ToggleButton(false, v["Api"]["Enabled"])
        tog.Object.Visible = v["Object"].Visible
        v["Object"]:GetPropertyChangedSignal("Visible"):connect(function()
            tog.Object.Visible = v["Object"].Visible
         end)
    end
    if v.Type == "Slider" and VapeGui["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and VapeGui["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
         local newstr = tostring(v["Object"].Parent):gsub("Children", "")
         local old = v["Api"]["SetValue"]
         local slider = windowbuttons[newstr]:CreateSlider({
            Name = v["Object"].Name,
            Min = v["Api"]["Min"],
            Max = v["Api"]["Max"],
            Function = function(s) -- 500 (MaxValue) | 0 (MinValue)
                if s ~= v["Api"]["Value"] then
                    old(s)
                end
            end
         })
         slider:SetLayoutOrder(v["Object"].LayoutOrder)
         v["Api"]["SetValue"] = function(value, ...)
             local res = old(value, ...)
             slider:SetValue(value)
             return res
         end
         v["Api"]["SetValue"](tonumber(v["Api"]["Value"]))
         slider.Object.Visible = v["Object"].Visible
         v["Object"]:GetPropertyChangedSignal("Visible"):connect(function()
            slider.Object.Visible = v["Object"].Visible
         end)
    end
    if v.Type == "Dropdown" and VapeGui["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and VapeGui["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
        local newstr = tostring(v["Object"].Parent):gsub("Children", "")
        local old = v["Api"]["SetValue"]
        local drop = windowbuttons[newstr]:CreateDropdown({
            Name = v["Object"].Name,
            List = v["Api"]["List"],
            Function = function(s)
                if s ~= v["Api"]["Value"] then
                    old(s)
                end
            end
        })
        drop:SetValue(v["Api"]["Value"])
        drop:SetLayoutOrder(v["Object"].LayoutOrder)
        drop.Object.Visible = v["Object"].Visible
        v["Object"]:GetPropertyChangedSignal("Visible"):connect(function()
            drop.Object.Visible = v["Object"].Visible
        end)
    end
    if v.Type == "TextBox" and VapeGui["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")] and VapeGui["ObjectsThatCanBeSaved"][tostring(v["Object"].Parent):gsub("Children", "OptionsButton")]["ChildrenObject"] == v["Object"].Parent then
        local newstr = tostring(v["Object"].Parent):gsub("Children", "")
        local old = v["Api"]["SetValue"]
        local drop = {["Value"] = ""}
        drop = windowbuttons[newstr]:CreateTextBox({
            Name = v["Object"].Name,
            TempText = v["Object"].AddBoxBKG.AddBox.PlaceholderText,
            Function = function(val)
                if val ~= v["Api"]["Value"] then
                    old(drop["Value"], false)
                end
            end
        })
        drop:SetValue(v["Api"]["Value"])
        drop:SetLayoutOrder(v["Object"].LayoutOrder)
        drop.Object.Visible = v["Object"].Visible
        v["Object"]:GetPropertyChangedSignal("Visible"):connect(function()
            drop.Object.Visible = v["Object"].Visible
        end)
    end
end

local oldtab
local oldfunc
local olduninject = VapeGui.SelfDestruct
local nametagconnection
VapeGui.SelfDestruct = function(...)
    guilib.ScreenGui:Remove()
    if oldtab and oldfunc then 
        oldtab.ProcessCompletedChatMessage = oldfunc
    end
    if nametagconnection then 
        nametagconnection:Disconnect()
    end
    if teleportfunc then 
        teleportfunc:Disconnect()
    end
    return olduninject(...)
end
windowtabs.World:CreateButton({
    Name = "UnInject",
    Function = function(callback)
        VapeGui.SelfDestruct()
    end
})

local modal = Instance.new("TextButton")
modal.Size = UDim2.new(0, 0, 0, 0)
modal.BorderSizePixel = 0
modal.Text = ""
modal.Modal = true
modal.Parent = guilib.ScreenGui.MainFrame
local targetinfo = Instance.new("Frame")
targetinfo.Size = UDim2.new(0, 258, 0, 80)
targetinfo.Visible = false
targetinfo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
targetinfo.BackgroundTransparency = 0.5
targetinfo.Position = UDim2.new(0.5, 72, 0.5, 54)
targetinfo.ClipsDescendants = true
targetinfo.Parent = guilib.ScreenGui
local targetinfoscale = Instance.new("UIScale")
targetinfoscale.Parent = targetinfo
targetinfo:GetPropertyChangedSignal("Size"):connect(function()
    targetinfoscale.Scale = targetinfo.Size.X.Offset / 258
end)
local targetinfocorner = Instance.new("UICorner")
targetinfocorner.CornerRadius = UDim.new(0, 8)
targetinfocorner.Parent = targetinfo
local targetinfopictureframe = Instance.new("Frame")
targetinfopictureframe.Size = UDim2.new(0, 64, 0, 63)
targetinfopictureframe.AnchorPoint = Vector2.new(0.5, 0.5)
targetinfopictureframe.Position = UDim2.new(0, 38, 0, 39)
targetinfopictureframe.BackgroundTransparency = 0.8
targetinfopictureframe.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
targetinfopictureframe.Parent = targetinfo
local targetinfopictureframecorner = Instance.new("UICorner")
targetinfopictureframecorner.CornerRadius = UDim.new(0, 128)
targetinfopictureframecorner.Parent = targetinfopictureframe
local targetinfopicture = Instance.new("ImageLabel")
targetinfopicture.Size = UDim2.new(1, -4, 1, -4)
targetinfopicture.Position = UDim2.new(0, 2, 0, 2)
targetinfopicture.BackgroundTransparency = 1
targetinfopicture.ScaleType = Enum.ScaleType.Fit
targetinfopicture.Image = 'rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420'
targetinfopicture.Parent = targetinfopictureframe
local targetinfopicturecorner = Instance.new("UICorner")
targetinfopicturecorner.CornerRadius = UDim.new(0, 128)
targetinfopicturecorner.Parent = targetinfopicture
targetinfohealthbar = Instance.new("Frame")
targetinfohealthbar.Position = UDim2.new(0, 74, 0, 55)
targetinfohealthbar.BackgroundColor3 = Color3.fromRGB(133, 77, 195)
targetinfohealthbar.BorderSizePixel = 0
targetinfohealthbar.Size = UDim2.new(0, 140, 0, 10)
targetinfohealthbar.Parent = targetinfo
local targetinfoname = Instance.new("TextLabel")
targetinfoname.Font = Enum.Font.TitilliumWeb
targetinfoname.TextSize = 40
targetinfoname.BackgroundTransparency = 1 
targetinfoname.TextColor3 = Color3.new(1, 1, 1)
targetinfoname.Text = "Target info"
targetinfoname.TextXAlignment = Enum.TextXAlignment.Left
targetinfoname.Size = UDim2.new(1, -72, 0, 40)
targetinfoname.TextScaled = true
targetinfoname.Position = UDim2.new(0, 72, 0, 13)
targetinfoname.Parent = targetinfo
local targetinfohealthtext = Instance.new("TextLabel")
targetinfohealthtext.Font = Enum.Font.TitilliumWeb
targetinfohealthtext.TextSize = 26
targetinfohealthtext.BackgroundTransparency = 1 
targetinfohealthtext.TextColor3 = Color3.new(1, 1, 1)
targetinfohealthtext.Text = "20.0"
targetinfohealthtext.TextXAlignment = Enum.TextXAlignment.Left
targetinfohealthtext.Size = UDim2.new(0, 20, 0, 30)
targetinfohealthtext.Position = UDim2.new(0, 219, 0, 43)
targetinfohealthtext.Parent = targetinfo
local targetinfodamage = Instance.new("Frame")
targetinfodamage.BackgroundTransparency = 1
targetinfodamage.BorderSizePixel = 0
targetinfodamage.BackgroundColor3 = Color3.new(1, 0, 0)
targetinfodamage.Size = UDim2.new(1, 0, 1, 0)
targetinfodamage.Parent = targetinfopictureframe
local targetinfodamagecorner = Instance.new("UICorner")
targetinfodamagecorner.CornerRadius = UDim.new(0, 128)
targetinfodamagecorner.Parent = targetinfodamage
local targetvape = shared.VapeTargetInfo
local oldupdate = targetvape.UpdateInfo
local lasthealth = 100
local lastplr
local healthanim
local targetvisible = false
targetvape.UpdateInfo = function(tab, targetsize)
    targetvisible = (targetsize > 0)
    if (targetsize > 0) then
        pcall(function()
            targetinfo:TweenSizeAndPosition(UDim2.new(0, 258, 0, 80), UDim2.new(0.5, 72, 0.5, 54), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
        end)
        targetinfo.Visible = true
    else
        spawn(function()
            for i = 1, 30 do 
                task.wait(0.01)
                if targetvisible then return end
            end
            pcall(function()
                targetinfo:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 144, 0.5, 108), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.2, true)
            end)
            for i = 1, 30 do 
                task.wait(0.01)
                if targetvisible then return end
            end
            targetinfo.Visible = false
        end)
    end
	for i,v in pairs(tab) do
		local plr = game:GetService("Players"):FindFirstChild(i)
        if lastplr ~= plr then 
            lastplr = plr
        else
            if v["Health"] < lasthealth then 
                targetinfopictureframe.Size = UDim2.new(0, 59, 0, 58)
                targetinfopictureframe:TweenSize(UDim2.new(0, 64, 0, 63), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.4, true)
                if healthanim then 
                    healthanim:Cancel()
                end
                targetinfodamage.BackgroundTransparency = 0.4
                healthanim = game:GetService("TweenService"):Create(targetinfodamage, TweenInfo.new(0.4), {BackgroundTransparency = 1})
                healthanim:Play()
            end
        end
        lasthealth = v["Health"]
		targetinfopicture.Image = 'rbxthumb://type=AvatarHeadShot&id='..v["UserId"]..'&w=420&h=420'
		targetinfohealthbar:TweenSize(UDim2.new(0, 140 * (v["Health"] / v["MaxHealth"]), 0, 10), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
		local healthtext = (math.floor((v["Health"] / 5) * 10) / 10)
        targetinfohealthtext.Text = healthtext..(tostring(healthtext):len() < 3 and ".0" or "")
		targetinfoname.Text = plr and plr.DisplayName or "Player"
	end
    return oldupdate(tab, targetsize)
end


local risetext = Instance.new("TextLabel")
risetext.Text = "Rise"
risetext.Font = Enum.Font.TitilliumWeb
risetext.TextSize = 53
risetext.TextColor3 = Color3.new(1, 1, 1)
risetext.BackgroundTransparency = 1
risetext.TextYAlignment = Enum.TextYAlignment.Top
risetext.TextXAlignment = Enum.TextXAlignment.Left
risetext.Size = UDim2.new(0, 400, 0, 60)
risetext.Position = UDim2.new(0, 6, 0, -10)
risetext.Parent = guilib.ScreenGui
local risetext2 = risetext:Clone()
risetext2.TextColor3 = Color3.new(0, 0, 0)
risetext2.Position = UDim2.new(0, 1, 0, 1)
risetext2.ZIndex = 0
risetext2.TextTransparency = 0.65
risetext2.Parent = risetext
local risegradient = Instance.new("UIGradient")
risegradient.Rotation = 180
risegradient.Parent = risetext
local risetextversion = risetext:Clone()
local risetextcustom = risetext:Clone()
risetextversion.TextSize = 26
risetextversion.Text = "5.94"
risetextversion.Position = UDim2.new(0, 66, 0, 6)
risetextversion.Parent = risetext
risetextversion.TextLabel.TextSize = 26
risetextversion.TextLabel.Text = risetextversion.Text
risetextcustom.TextSize = 26
risetextcustom.Text = riseoptions.CustomText or ""
risetextcustom.Position = UDim2.new(0, 66, 0, 22)
risetextcustom.Parent = risetext
risetextcustom.TextLabel.TextSize = 26
risetextcustom.TextLabel.Text = risetextcustom.Text

pcall(function()
    for i,v in pairs(getconnections(game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
        if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
            oldfunc = getmetatable(debug.getupvalues(v.Function)[1].ChatBar.CommandProcessor).ProcessCompletedChatMessage
            oldtab = getmetatable(debug.getupvalues(v.Function)[1].ChatBar.CommandProcessor)
            getmetatable(debug.getupvalues(v.Function)[1].ChatBar.CommandProcessor).ProcessCompletedChatMessage = function(self, message, chatwindow)
                local res = oldfunc(self, message, chatwindow)
                if message:sub(1, 5) == ".bind" then
                    local args = message:split(" ")
                    table.remove(args, 1)
                    if #args >= 2 then
                        local module = VapeGui["ObjectsThatCanBeSaved"][args[1].."OptionsButton"]
                        print(module)
                        if module then 
                            local suc, res = pcall(function() return Enum.KeyCode[args[2]] end)
                            print(suc, res)
                            if suc or args[2] == "None" then
                                local oldiden = getthreadidentityfunc()
                                setthreadidentityfunc(8)
                                module["Api"]["SetKeybind"](suc and res.Name or "")
                                VapeGui["CreateNotification"]("", "Set "..args[1].."'s bind to "..args[2]:upper()..".", 5)
                                setthreadidentityfunc(oldiden)
                            end
                        end
                    end
                    return true
                elseif message:sub(1, 11) == ".clientname" then
                    local args = message:split(" ")
                    table.remove(args, 1)
                    if #args >= 1 then
                        local oldiden = getthreadidentityfunc()
                        setthreadidentityfunc(8)
                        local clientname = ""
                        for i,v in pairs(args) do clientname = clientname..v.." " end
                        risetextcustom.Text = clientname
                        risetextcustom.TextLabel.Text = clientname
                        riseoptions.CustomText = clientname
                        setthreadidentityfunc(oldiden)
                    end
                    return true
                end
                return res
            end
        end
    end
end)

spawn(function()
    local val = 0
    repeat
        task.wait(0.01)
        local tab = {}
        val = val + 0.001
        if val > 1 then 
            
            val = val - 1
        end
        for i = 1, 10 do 
            table.insert(tab, ColorSequenceKeypoint.new(((i / 10) + val) % 1, i % 2 == 0 and risethemes[riseoptions.Theme].TextGUIColor2 or risethemes[riseoptions.Theme].TextGUIColor1))
        end
        table.sort(tab, function(a, b)
            return a.Time < b.Time
        end)
        local tab2 = {}
        for i2,v2 in pairs(tab) do 
            if i2 == 1 and v2.Time ~= 0 then 
                local lastcolor = tab[1].Value:lerp(tab[#tab].Value, math.clamp((tab[#tab].Time - 0.9) * 10, 0, 1))
                table.insert(tab2, ColorSequenceKeypoint.new(0, lastcolor:lerp(v2.Value, (v2.Time * 10) - 1)))
            elseif i2 == #tab and v2.Time ~= 1 then 
                table.insert(tab2, ColorSequenceKeypoint.new(1, tab[1].Value:lerp(v2.Value, math.clamp((v2.Time - 0.9) * 10, 0, 1))))
            end
            table.insert(tab2, v2)
        end
        table.sort(tab2, function(a, b)
            return a.Time < b.Time
        end)
        pcall(function()
            risegradient.Color = ColorSequence.new(tab2)
            risetextversion.UIGradient.Color = ColorSequence.new(tab2)
            risetextcustom.UIGradient.Color = ColorSequence.new(tab2)
        end)
    until guilib.ScreenGui == nil or guilib.ScreenGui.Parent == nil
end)

local risearraylist = Instance.new("Frame")
risearraylist.Size = UDim2.new(1, 0, 1, 0)
risearraylist.Position = UDim2.new(0, -10, 0, 10)
risearraylist.BackgroundTransparency = 1
risearraylist.Parent = guilib.ScreenGui
local risearraylistlayout = Instance.new("UIListLayout")
risearraylistlayout.VerticalAlignment = Enum.VerticalAlignment.Top
risearraylistlayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
risearraylistlayout.SortOrder = Enum.SortOrder.LayoutOrder
risearraylistlayout.Parent = risearraylist
local newnum = 0

local function refreshbars(textlists)
    local size = 0
    for i3,v3 in pairs(textlists) do 
        size = size + 22
    end
    risearraylistlayout.Parent = nil
    risearraylist:ClearAllChildren()
    risearraylistlayout.Parent = risearraylist
	for i2,v2 in pairs(textlists) do
		local newstr = v2.Text:gsub(":", " ")
		local textsize = v2.Size or Vector2.new(0, 0)
        local calcnum = (newnum + (i2 / 10)) % 2
		local frame = Instance.new("TextLabel")
		frame.BorderSizePixel = 0
		frame.BackgroundTransparency = 0.62
        frame.Text = newstr
        frame.TextSize = 30
        frame.TextColor3 = Color3.new(1, 0, 0)
        if calcnum < 1 then 
            frame.TextColor3 = risethemes[riseoptions.Theme].TextGUIColor1:lerp(risethemes[riseoptions.Theme].TextGUIColor2, calcnum)
        elseif calcnum < 2 then 
            frame.TextColor3 = risethemes[riseoptions.Theme].TextGUIColor2:lerp(risethemes[riseoptions.Theme].TextGUIColor1, calcnum - 1)
        else
            frame.TextColor3 = risethemes[riseoptions.Theme].TextGUIColor1
        end
        frame.Font = Enum.Font.TitilliumWeb
		frame.BackgroundColor3 = Color3.new(0,0,0)
		frame.Visible = true
		frame.ZIndex = (#textlists - i2) + 1
		frame.LayoutOrder = i2
		frame.Size = UDim2.new(0, textsize.X + 10, 0, 22)
		frame.Parent = risearraylist
        if i2 == 1 then 
            local image = Instance.new("ImageLabel")
            image.Size = UDim2.new(1, 0, 0, 6)
            image.ImageTransparency = 0
            image.Position = UDim2.new(0, 0, 0, -6)
            image.Rotation = 180
            image.BackgroundTransparency = 1
            image.ImageColor3 = Color3.new(0, 0, 0)
            image.ZIndex = 0
            image.Image = getcustomassetfunc("rise/assets/WindowBlurLine.png")
            image.BorderSizePixel = 0
            image.Parent = frame
            local imagecorner1 = Instance.new("ImageLabel")
            imagecorner1.Size = UDim2.new(0, 6, 0, 6)
            imagecorner1.ImageTransparency = 0
            imagecorner1.Position = UDim2.new(0, -6, 0, -6)
            imagecorner1.BackgroundTransparency = 1
            imagecorner1.ImageColor3 = Color3.new(0, 0, 0)
            imagecorner1.ZIndex = 0
            imagecorner1.Image = getcustomassetfunc("rise/assets/WindowBlurCorner.png")
            imagecorner1.BorderSizePixel = 0
            imagecorner1.Parent = frame
            local imagecorner2 = Instance.new("ImageLabel")
            imagecorner2.Size = UDim2.new(0, 6, 0, 6)
            imagecorner2.ImageTransparency = 0
            imagecorner2.Position = UDim2.new(1, 0, 0, -6)
            imagecorner2.Rotation = 90
            imagecorner2.BackgroundTransparency = 1
            imagecorner2.ImageColor3 = Color3.new(0, 0, 0)
            imagecorner2.ZIndex = 0
            imagecorner2.Image = getcustomassetfunc("rise/assets/WindowBlurCorner.png")
            imagecorner2.BorderSizePixel = 0
            imagecorner2.Parent = frame
            local imagerightline = Instance.new("ImageLabel")
            imagerightline.Size = UDim2.new(0, 6, 0, size)
            imagerightline.ImageTransparency = 0
            imagerightline.Position = UDim2.new(1, 0, 0, 0)
            imagerightline.Rotation = 180
            imagerightline.BackgroundTransparency = 1
            imagerightline.ImageColor3 = Color3.new(0, 0, 0)
            imagerightline.ZIndex = 0
            imagerightline.Image = getcustomassetfunc("rise/assets/WindowBlurLine2.png")
            imagerightline.BorderSizePixel = 0
            imagerightline.Parent = frame
        end
        if i2 == #textlists then 
            local imagecorner4 = Instance.new("ImageLabel")
            imagecorner4.Size = UDim2.new(0, 6, 0, 6)
            imagecorner4.ImageTransparency = 0
            imagecorner4.Position = UDim2.new(1, 0, 1, 0)
            imagecorner4.BackgroundTransparency = 1
            imagecorner4.Rotation = 180
            imagecorner4.ImageColor3 = Color3.new(0, 0, 0)
            imagecorner4.ZIndex = 0
            imagecorner4.Image = getcustomassetfunc("rise/assets/WindowBlurCorner.png")
            imagecorner4.BorderSizePixel = 0
            imagecorner4.Parent = frame
        end
        local imagecorner3 = Instance.new("ImageLabel")
        imagecorner3.Size = UDim2.new(0, 6, 0, 6)
        imagecorner3.ImageTransparency = 0
        imagecorner3.Position = UDim2.new(0, -6, 1, 0)
        imagecorner3.BackgroundTransparency = 1
        imagecorner3.Rotation = 270
        imagecorner3.ImageColor3 = Color3.new(0, 0, 0)
        imagecorner3.ZIndex = 0
        imagecorner3.Image = getcustomassetfunc("rise/assets/WindowBlurCorner.png")
        imagecorner3.BorderSizePixel = 0
        imagecorner3.Parent = frame
        local imagebottom = Instance.new("ImageLabel")
        if i2 ~= #textlists then
            local nextone = textlists[i2 + 1]
            local textsize = nextone.Size + Vector2.new(10, 0)
            imagebottom.Size = UDim2.new(0, math.clamp((frame.Size.X.Offset - textsize.X) - 1, 0, 1000), 0, 6)
        else
            imagebottom.Size = UDim2.new(1, 0, 0, 6)
        end
        imagebottom.ImageTransparency = 0
        imagebottom.Position = UDim2.new(0, 0, 1, 0)
        imagebottom.Rotation = 0
        imagebottom.BackgroundTransparency = 1
        imagebottom.ImageColor3 = Color3.new(0, 0, 0)
        imagebottom.ZIndex = 0
        imagebottom.Image = getcustomassetfunc("rise/assets/WindowBlurLine.png")
        imagebottom.BorderSizePixel = 0
        imagebottom.Parent = frame
        local imageleftline = Instance.new("ImageLabel")
        imageleftline.Size = UDim2.new(0, 6, 1, 0)
        imageleftline.ImageTransparency = 0
        imageleftline.Position = UDim2.new(0, -6, 0, 0)
        imageleftline.Rotation = 0
        imageleftline.BackgroundTransparency = 1
        imageleftline.ImageColor3 = Color3.new(0, 0, 0)
        imageleftline.ZIndex = 0
        imageleftline.Image = getcustomassetfunc("rise/assets/WindowBlurLine2.png")
        imageleftline.BorderSizePixel = 0
        imageleftline.Parent = frame
	end
end

local function UpdateHud()
    local text = ""
	local text2 = ""
	local tableofmodules = {}
    local sizes = {}
	local first = true
	
	for i,v in pairs(VapeGui["ObjectsThatCanBeSaved"]) do
		if v["Type"] == "OptionsButton" and v["Api"]["Name"] ~= "Text GUI" then
			if v["Api"]["Enabled"] then
                if not riseoptions.ShowRenderModules then
                    if v["Object"].Parent.Parent.Name == "Render" then continue end
                end
				table.insert(tableofmodules, {["Text"] = v["Api"]["Name"], ["ExtraText"] = v["Api"]["GetExtraText"]})
                sizes[v["Api"]["Name"]] = game:GetService("TextService"):GetTextSize(v["Api"]["Name"], 30, Enum.Font.TitilliumWeb, Vector2.new(1000000, 1000000))
			end
		end
	end
	table.sort(tableofmodules, function(a, b) 
        textsize1 = sizes[a["Text"]]
        textsize2 = sizes[b["Text"]]
        return textsize1.X > textsize2.X 
    end)
	local textlists = {}
	for i2,v2 in pairs(tableofmodules) do
		table.insert(textlists, {Text = v2["Text"], Size = sizes[v2["Text"]] or Vector2.new(0, 0)})
	end
    refreshbars(textlists)
end

UpdateHud()
VapeGui["UpdateHudEvent"].Event:connect(UpdateHud)
spawn(function()
    repeat 
        task.wait(0.01)
        newnum = (newnum + 0.01) % 2
    until guilib.ScreenGui == nil or guilib.ScreenGui.Parent == nil
end)

spawn(function()
    repeat 
        task.wait(0.01)
        local num = newnum
        local list = risearraylist:GetChildren()
        table.remove(list, table.find(list, risearraylistlayout))
        for i,v in pairs(list) do
            local calcnum = (newnum + (i / 10)) % 2
            if calcnum < 1 then 
                v.TextColor3 = risethemes[riseoptions.Theme].TextGUIColor1:lerp(risethemes[riseoptions.Theme].TextGUIColor2, calcnum)
            elseif calcnum < 2 then 
                v.TextColor3 = risethemes[riseoptions.Theme].TextGUIColor2:lerp(risethemes[riseoptions.Theme].TextGUIColor1, calcnum - 1)
            else
                v.TextColor3 = risethemes[riseoptions.Theme].TextGUIColor1
            end
        end
    until guilib.ScreenGui == nil or guilib.ScreenGui.Parent == nil
end)

local Interface = windowtabs.Render:CreateButton({
    Name = "Interface",
    Function = function() end
})
local risethemelist = {}
for i,v in pairs(risethemes) do table.insert(risethemelist, i) end
local InterfaceTheme = Interface:CreateDropdown({
    Name = "Theme",
    List = risethemelist,
    Function = function(val)
        riseoptions.Theme = val
    end
})
local InterfaceRenderR = Interface:CreateSlider({
    Name = "Red",
    Min = 0,
    Max = 255,
    Function = function(val)
        riseoptions.R = val / 255
        risethemes.Rise.TextGUIColor1 = Color3.new(riseoptions.R, riseoptions.G, riseoptions.B)
        local h, s, v = Color3.toHSV(risethemes.Rise.TextGUIColor1)
        risethemes.Rise.TextGUIColor2 = Color3.fromHSV(h, s, math.clamp(v - 0.3, 0, 1))
    end
})
local InterfaceRenderG = Interface:CreateSlider({
    Name = "Green",
    Min = 0,
    Max = 255,
    Function = function(val)
        riseoptions.G = val / 255
        risethemes.Rise.TextGUIColor1 = Color3.new(riseoptions.R, riseoptions.G, riseoptions.B)
        local h, s, v = Color3.toHSV(risethemes.Rise.TextGUIColor1)
        risethemes.Rise.TextGUIColor2 = Color3.fromHSV(h, s, math.clamp(v - 0.3, 0, 1))
    end
})
local InterfaceRenderB = Interface:CreateSlider({
    Name = "Blue",
    Min = 0,
    Max = 255,
    Function = function(val)
        riseoptions.B = val / 255
        risethemes.Rise.TextGUIColor1 = Color3.new(riseoptions.R, riseoptions.G, riseoptions.B)
        local h, s, v = Color3.toHSV(risethemes.Rise.TextGUIColor1)
        risethemes.Rise.TextGUIColor2 = Color3.fromHSV(h, s, math.clamp(v - 0.3, 0, 1))
    end
})
local InterfaceRenderNotifications = Interface:CreateToggle({
    Name = "Show Notifications on Toggle",
    Function = function(callback)
        riseoptions.RenderToggle = callback
    end
})
local InterfaceRenderList = Interface:CreateToggle({
    Name = "Show Render Modules on List",
    Function = function(callback)
        riseoptions.ShowRenderModules = callback
        VapeGui["UpdateHudEvent"]:Fire()
    end
})


local function isAlive(plr)
	if plr then
		return plr and plr.Character and plr.Character.Parent ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid")
	end
	return lplr and lplr.Character and lplr.Character.Parent ~= nil and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Head") and lplr.Character:FindFirstChild("Humanoid")
end

local NameTagsFolder = Instance.new("Folder")
NameTagsFolder.Name = "NameTagsFolder"
NameTagsFolder.Parent = VapeGui["MainGui"]
local nametagsfolderdrawing = {}
nametagconnection = players.PlayerRemoving:connect(function(plr)
    if NameTagsFolder:FindFirstChild(plr.Name) then
        NameTagsFolder[plr.Name]:Remove()
    end
    if nametagsfolderdrawing[plr.Name] then 
        pcall(function()
            nametagsfolderdrawing[plr.Name].Text:Remove()
            nametagsfolderdrawing[plr.Name].BG:Remove()
            nametagsfolderdrawing[plr.Name] = nil
        end)
    end
end)
local NameTags = windowtabs.Render:CreateButton({
    Name = "RiseNameTags",
    Function = function(callback)
        riseoptions.NameTags = callback
        if callback then 
            BindToRenderStep("NameTags", 500, function()
                for i,plr in pairs(players:GetChildren()) do
                    local thing
                    if NameTagsFolder:FindFirstChild(plr.Name) then
                        thing = NameTagsFolder[plr.Name]
                        thing.Visible = false
                    else
                        thing = Instance.new("TextLabel")
                        thing.BackgroundTransparency = 0.5
                        thing.BackgroundColor3 = Color3.new(0, 0, 0)
                        thing.BorderSizePixel = 0
                        thing.Visible = false
                        thing.RichText = true
                        thing.TextYAlignment = Enum.TextYAlignment.Top
                        thing.Name = plr.Name
                        thing.Font = Enum.Font.Gotham
                        thing.TextSize = 16
                        thing.TextColor3 = Color3.new(1, 1, 1)
                        thing.Parent = NameTagsFolder
                        local healthbar = Instance.new("Frame")
                        healthbar.BorderSizePixel = 0
                        healthbar.Size = UDim2.new(1, 0, 0, 2)
                        healthbar.Position = UDim2.new(0, 0, 1, -2)
                        healthbar.Parent = thing
                    end

                    if plr then
                        if isAlive(plr) and plr:GetAttribute("Team") ~= lplr:GetAttribute("Team") and plr ~= lplr then
                            local headPos, headVis = workspace.CurrentCamera:WorldToViewportPoint((plr.Character.HumanoidRootPart:GetRenderCFrame() * CFrame.new(0, plr.Character.Head.Size.Y + plr.Character.HumanoidRootPart.Size.Y, 0)).Position)
                            
                            if headVis then
                                local displaynamestr = plr.DisplayName or plr.Name
                                local nametagSize = game:GetService("TextService"):GetTextSize(displaynamestr, thing.TextSize, thing.Font, Vector2.new(100000, 100000))
                                thing.Size = UDim2.new(0, nametagSize.X + 30, 0, nametagSize.Y + 4)
                                thing.Text = displaynamestr
                                thing.TextColor3 = Color3.new(1, 1, 1)
                                thing.Visible = headVis
                                thing.Position = UDim2.new(0, headPos.X - thing.Size.X.Offset / 2, 0, (headPos.Y - thing.Size.Y.Offset) - 36)
                                thing.Frame.BackgroundColor3 = universalcolor
                                thing.Frame.Size = UDim2.new(math.clamp(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth, 0, 1), 0, 0, 2)
                            end
                        end
                    end
                end
            end)
        else
            UnbindFromRenderStep("NameTags")
            NameTagsFolder:ClearAllChildren()
        end
    end,
    HoverText = ""
})

local function LoadSettings()
    local suc, res = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile("rise/settings.json")) end)
    if suc and type(res) == "table" then 
        if risethemes[res.Theme] == nil then
            res.Theme = "Rise Blend"
        end
        riseoptions = res
        if InterfaceTheme then 
            InterfaceTheme:SetValue(riseoptions.Theme)
        end
        if InterfaceRenderList then 
            InterfaceRenderList:ToggleButton(false, riseoptions.ShowRenderModules)
        end
        if InterfaceRenderNotifications then 
            InterfaceRenderNotifications:ToggleButton(false, riseoptions.RenderToggle)
        end
        if InterfaceRenderR then 
            InterfaceRenderR:SetValue(math.floor(riseoptions.R * 255))
        end
        if InterfaceRenderG then 
            InterfaceRenderG:SetValue(math.floor(riseoptions.G * 255))
        end
        if InterfaceRenderB then 
            InterfaceRenderB:SetValue(math.floor(riseoptions.B * 255))
        end
        if NameTags then 
            NameTags:ToggleButton(false, riseoptions.NameTags)
        end
        if risetextcustom then
            risetextcustom.Text = riseoptions.CustomText
            risetextcustom.TextLabel.Text = riseoptions.CustomText
        end
    end
end


LoadSettings()
spawn(function()
    repeat
        task.wait(10)
        if (guilib.ScreenGui == nil or guilib.ScreenGui.Parent == nil) then break end
        SaveSettings()
    until (guilib.ScreenGui == nil or guilib.ScreenGui.Parent == nil)
end)