local uilib = {}
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
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

local function randomString()
    local randomlength = math.random(10,100)
    local array = {}

    for i = 1, randomlength do
        array[i] = string.char(math.random(32, 126))
    end

    return table.concat(array)
end

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
            textlabel.Parent = api["MainGui"]
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

local function RelativeXY(GuiObject, location)
    local x, y = location.X - GuiObject.AbsolutePosition.X, location.Y - GuiObject.AbsolutePosition.Y
    local x2 = 0
    local xm, ym = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    x2 = math.clamp(x, 4, xm - 6)
    x = math.clamp(x, 0, xm)
    y = math.clamp(y, 0, ym)
    return x, y, x/xm, y/ym, x2/xm
end

local function dragGUI(gui, tab)
    spawn(function()
        local dragging
        local dragInput
        local dragStart = Vector3.new(0,0,0)
        local startPos
        local function update(input)
            local delta = input.Position - dragStart
            local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            game:GetService("TweenService"):Create(gui, TweenInfo.new(.20), {Position = Position}):Play()
        end
        gui.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and dragging == false then
                    dragStart = input.Position
                    local delta = (dragStart - Vector3.new(gui.AbsolutePosition.X, gui.AbsolutePosition.Y, 0))
                    if delta.Y <= 40 then
                        dragging = true
                        startPos = gui.Position
                        
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end
        end)
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end)
end

if not is_sirhurt_closure and syn and syn.protect_gui then
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString()
    gui.DisplayOrder = 999
    syn.protect_gui(gui)
    gui.Parent = game:GetService("CoreGui")
    uilib.ScreenGui = gui
elseif gethui then
    local gui = Instance.new("ScreenGui")
    gui.Name = randomString()
    gui.DisplayOrder = 999
    gui.Parent = gethui()
    uilib.ScreenGui = gui
elseif game:GetService("CoreGui"):FindFirstChild('RobloxGui') then
    uilib.ScreenGui = game:GetService("CoreGui").RobloxGui
end

if shared.testuirise then
    shared.testuirise:Remove()
end
shared.testuirise = uilib.ScreenGui

local mainframe = Instance.new("Frame")
mainframe.Size = UDim2.new(0, 830, 0, 700)
mainframe.BackgroundColor3 = Color3.fromRGB(27, 23, 33)
mainframe.Position = UDim2.new(0.5, -330, 0.5, -368)
mainframe.Name = "MainFrame"
mainframe.Parent = uilib.ScreenGui
mainframe.ZIndex = 2
local mainframe2 = mainframe:Clone()
mainframe2.Position = UDim2.new(0, 0, 0, 0)
mainframe2.Size = UDim2.new(0, 6, 1, 0)
mainframe2.BorderSizePixel = 0
mainframe2.Parent = mainframe
local maincorner = Instance.new("UICorner")
maincorner.CornerRadius = UDim.new(0, 10)
maincorner.Parent = mainframe
local sidebar = Instance.new("Frame")
sidebar.ZIndex = 1
sidebar.BackgroundColor3 = Color3.fromRGB(27, 23, 33)
sidebar.BackgroundTransparency = 0.25
sidebar.Position = UDim2.new(0, -170, 0, 0)
sidebar.Size = UDim2.new(0, 176, 1, 0)
sidebar.Parent = mainframe
local sidecorner = Instance.new("UICorner")
sidecorner.CornerRadius = UDim.new(0, 10)
sidecorner.Parent = sidebar
local sidebartitle = Instance.new("TextLabel")
sidebartitle.Size = UDim2.new(1, -6, 0, 50)
sidebartitle.TextSize = 48
sidebartitle.Text = "Rise"
sidebartitle.Font = Enum.Font.SourceSans
sidebartitle.BackgroundTransparency = 1
sidebartitle.TextColor3 = Color3.new(1, 1, 1)
sidebartitle.Position = UDim2.new(0, -20, 0, 2)
sidebartitle.Parent = sidebar
local sidebarversion = Instance.new("TextLabel")
sidebarversion.Size = UDim2.new(1, -6, 0, 50)
sidebarversion.TextSize = 20
sidebarversion.Text = "roblox"
sidebarversion.Font = Enum.Font.SourceSans
sidebarversion.BackgroundTransparency = 1
sidebarversion.TextColor3 = Color3.new(1, 1, 1)
sidebarversion.Position = UDim2.new(0, 39, 0, -6)
sidebarversion.Parent = sidebar
local sidebarbuttonframe = Instance.new("Frame")
sidebarbuttonframe.Size = UDim2.new(1, -6, 1, -56)
sidebarbuttonframe.Position = UDim2.new(0, 0, 0, 56)
sidebarbuttonframe.BackgroundTransparency = 1
sidebarbuttonframe.Parent = sidebar
local sidebarselected = Instance.new("Frame")
sidebarselected.Size = UDim2.new(1, 0, 0, 40)
sidebarselected.BorderSizePixel = 0
sidebarselected.BackgroundColor3 = Color3.fromRGB(126, 94, 172)
sidebarselected.Parent = sidebar
local sidebarbuttonlist = Instance.new("UIListLayout")
sidebarbuttonlist.Padding = UDim.new()
sidebarbuttonlist.Parent = sidebarbuttonframe

local categorycount = 1
function uilib:CreateCategory(categorytab)
    local labelobjects = {}
    local categoryapi = {}
    local sidebarcount = categorycount
    local sidebarbutton = Instance.new("TextButton")
    sidebarbutton.Size = UDim2.new(1, 0, 0, 40)
    sidebarbutton.BackgroundTransparency = 1
    sidebarbutton.LayoutOrder = #sidebarbuttonframe:GetChildren()
    sidebarbutton.TextSize = 24
    sidebarbutton.TextColor3 = Color3.new(1, 1, 1)
    sidebarbutton.Font = Enum.Font.SourceSans
    sidebarbutton.ZIndex = 3
    sidebarbutton.TextXAlignment = Enum.TextXAlignment.Left
    sidebarbutton.Text = "         "..categorytab.Name
    sidebarbutton.Parent = sidebarbuttonframe
    local sidebaricon = Instance.new("TextLabel")
    sidebaricon.Font = Enum.Font.SourceSans
    sidebaricon.Text = categorytab.Icon or ""
    sidebaricon.Size = UDim2.new(0, 40, 0, 40)
    sidebaricon.TextSize = 20 
    sidebaricon.BackgroundTransparency =1 
    sidebaricon.ZIndex = 3
    sidebaricon.Position = UDim2.new(0, 0, 0, 2)
    sidebaricon.Parent = sidebarbutton
    local maincategoryframe = Instance.new("Frame")
    maincategoryframe.Size = UDim2.new(1, 0, 1, 0)
    maincategoryframe.Name = categorytab.Name.."CategoryFrame"
    maincategoryframe.BackgroundTransparency = 1
    maincategoryframe.ZIndex = 3
    if categorycount == 1 then
        sidebarselected.Position = UDim2.new(0, 0, 0, 16 + (sidebarcount * 40))
    end
    maincategoryframe.Visible = categorycount == 1
    maincategoryframe.Parent = mainframe
    local maincategorytitle = Instance.new("TextLabel")
    maincategorytitle.Size = UDim2.new(1, 0, 0, 35)
    maincategorytitle.BackgroundTransparency = 1
    maincategorytitle.Font = Enum.Font.SourceSansLight
    maincategorytitle.TextSize = 24
    maincategorytitle.Text = categorytab.Name
    maincategorytitle.TextColor3 = Color3.new(1, 1, 1)
    maincategorytitle.ZIndex = 3
    maincategorytitle.Parent = maincategoryframe
    local maincategorybuttonframe = Instance.new("ScrollingFrame")
    maincategorybuttonframe.Size = UDim2.new(1, -20, 1, -40)
    maincategorybuttonframe.Position = UDim2.new(0, 10, 0, 40)
    maincategorybuttonframe.ZIndex = 3
    maincategorybuttonframe.BackgroundTransparency = 1
    maincategorybuttonframe.BorderSizePixel = 0
    maincategorybuttonframe.ScrollBarThickness = 0
    maincategorybuttonframe.Parent = maincategoryframe
    local maincategorybuttonframelist = Instance.new("UIListLayout")
    maincategorybuttonframelist.Parent = (categorytab.Name ~= "Info" and maincategorybuttonframe or nil)
    maincategorybuttonframelist.Padding = UDim.new(0, 10)
    maincategorybuttonframelist:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
        maincategorybuttonframe.CanvasSize = UDim2.new(0, 0, 0, maincategorybuttonframelist.AbsoluteContentSize.Y + 10)
    end)
    sidebarbutton.MouseButton1Click:connect(function()
        for i,v in pairs(mainframe:GetChildren()) do 
            if v.Name:find("CategoryFrame") then 
                v.Visible = false
            end
        end
        for i2,v2 in pairs(labelobjects) do
            pcall(function()
                v2.TextTransparency = 1
                game:GetService("TweenService"):Create(v2, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
            end)
        end
        maincategoryframe.Visible = true
        sidebarselected:TweenPosition(UDim2.new(0, 0, 0, 16 + (sidebarcount * 40)), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.2, true)
    end)
    categorycount = categorycount + 1

    function categoryapi:CreateLabel()
        local lab = Instance.new("TextLabel")
        labelobjects[#labelobjects + 1] = lab
        lab.Parent = maincategorybuttonframe
        lab.ZIndex = 4
        return lab
    end

    function categoryapi:CreateButton(buttontab)
        local hoveranim
        local buttonapi = {}
        local optionsbuttonlayoutorder = #maincategorybuttonframe:GetChildren() + 1
        local optionsbutton = Instance.new("TextButton")
        optionsbutton.BackgroundColor3 = Color3.fromRGB(37, 36, 44)
        optionsbutton.Size = UDim2.new(1, 0, 0, 40)
        optionsbutton.AutoButtonColor = false
        optionsbutton.ZIndex = 3
        optionsbutton.LayoutOrder = optionsbuttonlayoutorder
        optionsbutton.TextSize = 24
        optionsbutton.TextColor3 = Color3.fromRGB(170, 170, 170)
        optionsbutton.Font = Enum.Font.SourceSansLight
        optionsbutton.TextXAlignment = Enum.TextXAlignment.Left
        optionsbutton.Text = ""
        optionsbutton.Parent = maincategorybuttonframe
        local optionsbuttontext = Instance.new("TextLabel")
        optionsbuttontext.BackgroundTransparency = 1 
        optionsbuttontext.Text = "   "..buttontab.Name
        optionsbuttontext.ZIndex = 3
        optionsbuttontext.TextSize = 24
        optionsbuttontext.TextColor3 = Color3.fromRGB(170, 170, 170)
        optionsbuttontext.Size = UDim2.new(1, 0, 0, 40)
        optionsbuttontext.Font = Enum.Font.SourceSansLight
        optionsbuttontext.TextXAlignment = Enum.TextXAlignment.Left
        optionsbuttontext.Parent = optionsbutton
        local optionsbuttoncorner = Instance.new("UICorner")
        optionsbuttoncorner.CornerRadius = UDim.new(0, 4)
        optionsbuttoncorner.Parent = optionsbutton
        local optionsbuttontoggle1 = Instance.new("Frame")
        optionsbuttontoggle1.Size = UDim2.new(0, 20, 0, 10)
        optionsbuttontoggle1.Position = UDim2.new(1, -30, 0, 16)
        optionsbuttontoggle1.ZIndex = 3
        optionsbuttontoggle1.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        optionsbuttontoggle1.Parent = optionsbutton
        optionsbuttontoggle1.Active = false
        local optionsbuttontoggle1corner = Instance.new("UICorner")
        optionsbuttontoggle1corner.CornerRadius = UDim.new(0, 8)
        optionsbuttontoggle1corner.Parent = optionsbuttontoggle1
        local optionsbuttontoggle2 = optionsbuttontoggle1:Clone()
        optionsbuttontoggle2.Size = UDim2.new(0, 14, 0, 14)
        optionsbuttontoggle2.BackgroundColor3 = Color3.fromRGB(83, 66, 111)
        optionsbuttontoggle2.Position = UDim2.new(0, -2, 0, -2)
        optionsbuttontoggle2.Parent = optionsbuttontoggle1
        local optionsbuttonhoverbox = Instance.new("Frame")
        optionsbuttonhoverbox.ZIndex = 4
        optionsbuttonhoverbox.Active = false
        optionsbuttonhoverbox.BackgroundTransparency = 1
        optionsbuttonhoverbox.Size = UDim2.new(1, 0, 0, 40)
        optionsbuttonhoverbox.Parent = optionsbutton
        local optionsbuttonhovertext = Instance.new("TextLabel")
        optionsbuttonhovertext.Text = buttontab.HoverText or ""
        optionsbuttonhovertext.BackgroundTransparency = 1
        local calculatedsize = game:GetService("TextService"):GetTextSize(optionsbuttontext.Text, optionsbuttontext.TextSize, optionsbuttontext.Font, Vector2.new(1000000, 1000000))
        optionsbuttonhovertext.Size = UDim2.new(1, -(calculatedsize.X + 10), 0, 40)
        optionsbuttonhovertext.Position = UDim2.new(0, (calculatedsize.X + 10), 0, 0)
        optionsbuttonhovertext.Active = false
        optionsbuttonhovertext.TextXAlignment = Enum.TextXAlignment.Left
        optionsbuttonhovertext.TextColor3 = Color3.fromRGB(100, 100, 100)
        optionsbuttonhovertext.TextSize = 20
        optionsbuttonhovertext.TextTransparency = 1
        optionsbuttonhovertext.Font = Enum.Font.SourceSansLight
        optionsbuttonhovertext.ZIndex = 3
        optionsbuttonhovertext.Parent = optionsbutton
        local optionsbuttonchildren = Instance.new("Frame")
        optionsbuttonchildren.Size = UDim2.new(1, 0, 0, 0)
        optionsbuttonchildren.Position = UDim2.new(0, 0, 0, 40)
        optionsbuttonchildren.BackgroundTransparency = 1
        optionsbuttonchildren.Visible = false
        optionsbuttonchildren.Parent = optionsbutton
        local optionsbuttonchildrenlist = Instance.new("UIListLayout")
        optionsbuttonchildrenlist.SortOrder = Enum.SortOrder.LayoutOrder
        optionsbuttonchildrenlist.Parent = optionsbuttonchildren
        optionsbuttonchildrenlist:GetPropertyChangedSignal("AbsoluteContentSize"):connect(function()
            optionsbuttonchildren.Size = UDim2.new(1, 0, 0, optionsbuttonchildrenlist.AbsoluteContentSize.Y)
            optionsbutton.Size = UDim2.new(1, 0, 0, optionsbuttonchildren.Visible and 40 + optionsbuttonchildren.Size.Y.Offset or 40)
        end)
        optionsbuttonhoverbox.MouseEnter:connect(function()
            if hoveranim then
                hoveranim:Cancel()
            end
            hoveranim = game:GetService("TweenService"):Create(optionsbuttonhovertext, TweenInfo.new(0.6), {TextTransparency = 0})
            hoveranim:Play()
        end)
        optionsbuttonhoverbox.MouseLeave:connect(function()
            if hoveranim then
                hoveranim:Cancel()
            end
            hoveranim = game:GetService("TweenService"):Create(optionsbuttonhovertext, TweenInfo.new(0.6), {TextTransparency = 1})
            hoveranim:Play()
        end)
        buttonapi.Enabled = false

        function buttonapi:ToggleButton(clicked, enabled)
            if enabled ~= nil then
                buttonapi.Enabled = enabled and true or false
            else
                buttonapi.Enabled = (not buttonapi.Enabled)
            end
            buttontab.Function(buttonapi.Enabled)
            optionsbuttontoggle2.Position = buttonapi.Enabled and UDim2.new(0, 8, 0, -2) or UDim2.new(0, -2, 0, -2)
            optionsbuttontoggle2.BackgroundColor3 = buttonapi.Enabled and Color3.fromRGB(107, 79, 146) or Color3.fromRGB(83, 66, 111)
            optionsbuttontext.TextColor3 = buttonapi.Enabled and Color3.fromRGB(126, 94, 172) or Color3.fromRGB(170, 170, 170)
            optionsbutton.BackgroundColor3 = buttonapi.Enabled and Color3.fromRGB(36, 32, 42) or Color3.fromRGB(37, 36, 44)
            optionsbuttontoggle1.BackgroundColor3 = buttonapi.Enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        end

        function buttonapi:CreateToggle(buttontab2)
            local buttonapi2 = {}
            local togglelayoutorder = #optionsbuttonchildren:GetChildren() + 1
            local toggleframe1 = Instance.new("TextButton")
            toggleframe1.LayoutOrder = togglelayoutorder
            toggleframe1.Size = UDim2.new(1, 0, 0, 30)
            toggleframe1.Text = ""
            toggleframe1.BackgroundTransparency = 1
            toggleframe1.ZIndex = 4
            toggleframe1.Parent = optionsbuttonchildren
            local toggletext = Instance.new("TextLabel")
            toggletext.Text = "   "..buttontab2.Name
            toggletext.TextSize = 22
            toggletext.ZIndex = 4
            toggletext.TextColor3 = Color3.fromRGB(190, 190, 190)
            toggletext.Font = Enum.Font.SourceSansLight
            toggletext.TextXAlignment = Enum.TextXAlignment.Left
            toggletext.BackgroundTransparency = 1
            toggletext.Size = UDim2.new(1, 0, 1, 0)
            toggletext.Parent = toggleframe1
            local calculatedsizetoggle = game:GetService("TextService"):GetTextSize(toggletext.Text, toggletext.TextSize, toggletext.Font, Vector2.new(1000000, 1000000))
            local toggleframe2 = Instance.new("Frame")
            toggleframe2.Size = UDim2.new(0, 16, 0, 16)
            toggleframe2.Position = UDim2.new(0, calculatedsizetoggle.X + 10, 0, 8)
            toggleframe2.BackgroundColor3 = Color3.fromRGB(111, 88, 145)
            toggleframe2.ZIndex = 4
            toggleframe2.Parent = toggleframe1
            local toggleframe2corner = Instance.new("UICorner")
            toggleframe2corner.CornerRadius = UDim.new(0, 16)
            toggleframe2corner.Parent = toggleframe2
            local toggleframe3 = toggleframe2:Clone()
            toggleframe3.BackgroundColor3 = optionsbutton.BackgroundColor3
            toggleframe3.Size = UDim2.new(1, -4, 1, -4)
            toggleframe3.Position = UDim2.new(0, 2, 0, 2)
            toggleframe3.Parent = toggleframe2
            local toggleframe4 = toggleframe2:Clone()
            toggleframe4.BackgroundColor3 = Color3.fromRGB(111, 88, 145)
            toggleframe4.Size = UDim2.new(1, -8, 1, -8)
            toggleframe4.Position = UDim2.new(0, 4, 0, 4)
            toggleframe4.Parent = toggleframe2
            toggleframe4.ZIndex = 5
            toggleframe4.Visible = false
            buttonapi2.Enabled = false
            buttonapi2.Object = toggleframe1

            function buttonapi2:ToggleButton(clicked, enabled2)
                if enabled2 ~= nil then
                    buttonapi2.Enabled = enabled2 and true or false
                else
                    buttonapi2.Enabled = (not buttonapi2.Enabled)
                end
                buttontab2.Function(buttonapi2.Enabled)
                toggleframe4.Visible = buttonapi2.Enabled
            end

            function buttonapi2:SetLayoutOrder(order)
                toggleframe1.LayoutOrder = order
            end

            toggleframe1.MouseButton1Click:connect(function()
                buttonapi2:ToggleButton(true)
            end)

            optionsbutton:GetPropertyChangedSignal("BackgroundColor3"):connect(function()
                if toggleframe3 then 
                    toggleframe3.BackgroundColor3 = optionsbutton.BackgroundColor3
                end 
            end)
            return buttonapi2
        end

        function buttonapi:CreateSlider(buttontab2)
            local buttonapi2 = {}
            local togglelayoutorder = #optionsbuttonchildren:GetChildren() + 1
            local toggleframe1 = Instance.new("Frame")
            toggleframe1.LayoutOrder = togglelayoutorder
            toggleframe1.Size = UDim2.new(1, 0, 0, 30)
            toggleframe1.BackgroundTransparency = 1
            toggleframe1.ZIndex = 4
            toggleframe1.Parent = optionsbuttonchildren
            local toggletext = Instance.new("TextLabel")
            toggletext.Text = "   "..buttontab2.Name
            toggletext.TextSize = 22
            toggletext.ZIndex = 4
            toggletext.TextColor3 = Color3.fromRGB(190, 190, 190)
            toggletext.Font = Enum.Font.SourceSansLight
            toggletext.TextXAlignment = Enum.TextXAlignment.Left
            toggletext.BackgroundTransparency = 1
            toggletext.Size = UDim2.new(1, 0, 1, 0)
            toggletext.Parent = toggleframe1
            local calculatedsizetoggle = game:GetService("TextService"):GetTextSize(toggletext.Text, toggletext.TextSize, toggletext.Font, Vector2.new(1000000, 1000000))
            local toggleframe2 = Instance.new("Frame")
            toggleframe2.Size = UDim2.new(0, 200, 0, 4)
            toggleframe2.Position = UDim2.new(0, calculatedsizetoggle.X + 14, 0, 15)
            toggleframe2.BackgroundColor3 = Color3.fromRGB(111, 88, 145)
            toggleframe2.BorderSizePixel = 0
            toggleframe2.ZIndex = 4
            toggleframe2.Parent = toggleframe1
            local toggleframe3 = Instance.new("TextButton")
            toggleframe3.Size = UDim2.new(0, 10, 0, 10)
            toggleframe3.Position = UDim2.new(0, -3, 0, -3)
            toggleframe3.BackgroundColor3 = Color3.fromRGB(130, 100, 174)
            toggleframe3.BorderSizePixel = 0
            toggleframe3.AutoButtonColor = false
            toggleframe3.Text = ""
            toggleframe3.ZIndex = 4
            toggleframe3.Parent = toggleframe2
            local toggletext2 = Instance.new("TextLabel")
            toggletext2.Text = "0"
            toggletext2.TextSize = 22
            toggletext2.ZIndex = 4
            toggletext2.TextColor3 = Color3.fromRGB(190, 190, 190)
            toggletext2.Font = Enum.Font.SourceSansLight
            toggletext2.TextXAlignment = Enum.TextXAlignment.Left
            toggletext2.Position = UDim2.new(0, calculatedsizetoggle.X + 223, 0, 0)
            toggletext2.BackgroundTransparency = 1
            toggletext2.Size = UDim2.new(1, 0, 1, 0)
            toggletext2.Parent = toggleframe1
            local toggleframe3corner = Instance.new("UICorner")
            toggleframe3corner.CornerRadius = UDim.new(0, 16)
            toggleframe3corner.Parent = toggleframe3
            buttonapi2.Value = buttontab2.Min or 0
            buttonapi2.Object = toggleframe1

            function buttonapi2:SetLayoutOrder(order)
                toggleframe1.LayoutOrder = order
            end

            function buttonapi2:SetValue(val)
                buttontab2.Function(val)
                buttonapi2.Value = val
                toggletext2.Text = val
                toggleframe3:TweenPosition(UDim2.new(val / buttontab2.Max, -5, 0, -3), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
            end

            toggleframe3.MouseButton1Down:connect(function()
                local x,y,xscale,yscale,xscale2 = RelativeXY(toggleframe2, game:GetService("UserInputService"):GetMouseLocation())
                buttonapi2:SetValue(math.floor(buttontab2.Min + ((buttontab2.Max - buttontab2.Min) * xscale)))
                local move
                local kill
                move = game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local x,y,xscale,yscale,xscale2 = RelativeXY(toggleframe2, game:GetService("UserInputService"):GetMouseLocation())
                        buttonapi2:SetValue(math.floor(buttontab2.Min + ((buttontab2.Max - buttontab2.Min) * xscale)))
                    end
                end)
                kill = game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        move:Disconnect()
                        kill:Disconnect()
                    end
                end)
            end)

            return buttonapi2
        end

        function buttonapi:CreateTextBox(buttontab2)
            local buttonapi2 = {}
            local togglelayoutorder = #optionsbuttonchildren:GetChildren() + 1
            local toggleframe1 = Instance.new("Frame")
            toggleframe1.LayoutOrder = togglelayoutorder
            toggleframe1.Size = UDim2.new(1, 0, 0, 30)
            toggleframe1.BackgroundTransparency = 1
            toggleframe1.ZIndex = 4
            toggleframe1.Parent = optionsbuttonchildren
            local toggletext = Instance.new("TextLabel")
            toggletext.Text = "   "..buttontab2.Name
            toggletext.TextSize = 22
            toggletext.ZIndex = 4
            toggletext.TextColor3 = Color3.fromRGB(190, 190, 190)
            toggletext.Font = Enum.Font.SourceSansLight
            toggletext.TextXAlignment = Enum.TextXAlignment.Left
            toggletext.BackgroundTransparency = 1
            toggletext.Size = UDim2.new(1, 0, 1, 0)
            toggletext.Parent = toggleframe1
            local calculatedsizetoggle = game:GetService("TextService"):GetTextSize(toggletext.Text, toggletext.TextSize, toggletext.Font, Vector2.new(1000000, 1000000))
            local toggleframe2 = Instance.new("TextBox")
            toggleframe2.Size = UDim2.new(0, 200, 0, 20)
            toggleframe2.PlaceholderText = buttontab2["TempText"] or ""
            toggleframe2.TextXAlignment = Enum.TextXAlignment.Left
            toggleframe2.TextColor3 = Color3.new(1, 1, 1)
            toggleframe2.TextSize = 20
            toggleframe2.Font = Enum.Font.SourceSans
            toggleframe2.Position = UDim2.new(0, calculatedsizetoggle.X + 14, 0, 6)
            toggleframe2.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
            toggleframe2.BackgroundTransparency = 1
            toggleframe2.BorderSizePixel = 0
            toggleframe2.ZIndex = 4
            toggleframe2.Parent = toggleframe1
            buttonapi2.Value = ""
            buttonapi2.Object = toggleframe1

            function buttonapi2:SetLayoutOrder(order)
                toggleframe1.LayoutOrder = order
            end

            function buttonapi2:SetValue(val, entered)
                toggleframe2.Text = val
                buttonapi2.Value = val
            end

            toggleframe2.FocusLost:connect(function(enter)
                buttonapi2:SetValue(toggleframe2.Text, true)
				buttontab2.Function(toggleframe2.Text)
            end)

            return buttonapi2
        end

        function buttonapi:CreateDropdown(buttontab2)
            local buttonapi2 = {}
            local togglelayoutorder = #optionsbuttonchildren:GetChildren() + 1
            local tab = buttontab2.List
            local selecteditem2 = 1
            local toggleframe1 = Instance.new("TextButton")
            toggleframe1.LayoutOrder = togglelayoutorder
            toggleframe1.Size = UDim2.new(1, 0, 0, 30)
            toggleframe1.Text = ""
            toggleframe1.BackgroundTransparency = 1
            toggleframe1.ZIndex = 4
            toggleframe1.Parent = optionsbuttonchildren
            local toggletext = Instance.new("TextLabel")
            toggletext.Text = "   "..buttontab2.Name.."   "..tab[selecteditem2]
            toggletext.TextSize = 22
            toggletext.ZIndex = 4
            toggletext.TextColor3 = Color3.fromRGB(190, 190, 190)
            toggletext.Font = Enum.Font.SourceSansLight
            toggletext.TextXAlignment = Enum.TextXAlignment.Left
            toggletext.BackgroundTransparency = 1
            toggletext.Size = UDim2.new(1, 0, 1, 0)
            toggletext.Parent = toggleframe1
            buttonapi2.Value = tab[selecteditem2]
            buttonapi2.Object = toggleframe1

            function buttonapi2:SetValue(val)
                buttonapi2.Value = val
                selecteditem2 = table.find(tab, val) or 1
                buttontab2.Function(val)
                toggletext.Text = "   "..buttontab2.Name.."   "..tab[selecteditem2]
            end

            function buttonapi2:SetLayoutOrder(order)
                toggleframe1.LayoutOrder = order
            end

            toggleframe1.MouseButton1Click:connect(function()
                selecteditem2 = selecteditem2 + 1
                if selecteditem2 > #tab then 
                    selecteditem2 = 1
                end
                buttonapi2:SetValue(tab[selecteditem2])
            end)

            toggleframe1.MouseButton2Click:connect(function()
                selecteditem2 = selecteditem2 - 1
                if selecteditem2 < 1 then 
                    selecteditem2 = #tab
                end
                buttonapi2:SetValue(tab[selecteditem2])
            end)
            
            return buttonapi2
        end

        optionsbutton.MouseButton1Click:connect(function()
            if game:GetService("UserInputService"):GetMouseLocation().Y - optionsbutton.AbsolutePosition.Y <= 80 then
                buttonapi:ToggleButton(true)
            end
        end)
        optionsbutton.MouseButton2Click:connect(function()
            optionsbuttonchildren.Visible = not optionsbuttonchildren.Visible
            optionsbutton.Size = UDim2.new(1, 0, 0, optionsbuttonchildren.Visible and 40 + optionsbuttonchildren.Size.Y.Offset or 40)
        end)

        return buttonapi
    end

    return categoryapi
end

return uilib