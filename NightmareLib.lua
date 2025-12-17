--[[
    NIGHTMARE HUB LIBRARY (Color Changes + Regular Buttons)
]]

local NightmareHub = {}
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- UI Variables
local ScreenGui
local MainFrame
local ToggleButton
local TabButtons = {}
local ScrollFrame
local TabContent = {}
local CurrentTab = "Main"

-- Button states
local ButtonStates = {
    joinServer = false,
    serverHop = false,
    rejoin = false
}

-- ==================== CREATE UI ====================
function NightmareHub:CreateUI()
    -- Cleanup
    if game.CoreGui:FindFirstChild("NightmareHubUI") then
        game.CoreGui:FindFirstChild("NightmareHubUI"):Destroy()
    end
    
    -- ScreenGui
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NightmareHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    
    -- Toggle Button
    ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 60, 0, 60)
    ToggleButton.Position = UDim2.new(0, 20, 0.5, -30)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Image = "rbxassetid://121996261654076"
    ToggleButton.Active = true
    ToggleButton.Draggable = true
    ToggleButton.Parent = ScreenGui
    
    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 320, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    -- Styling
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 50, 50)
    mainStroke.Thickness = 2
    mainStroke.Parent = MainFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 45)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "NIGHTMARE HUB"
    titleLabel.TextColor3 = Color3.fromRGB(139, 0, 0)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.Arcade
    titleLabel.Parent = MainFrame
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Arcade
    closeBtn.Parent = MainFrame
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    local closeBtnStroke = Instance.new("UIStroke")
    closeBtnStroke.Color = Color3.fromRGB(255, 50, 50)
    closeBtnStroke.Thickness = 1
    closeBtnStroke.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 35)
    tabContainer.Position = UDim2.new(0, 10, 0, 55)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = MainFrame
    
    -- Tab Buttons
    local tabs = {"Main", "Visual", "Misc", "Discord"}
    for i, tabName in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 70, 1, 0)
        tabBtn.Position = UDim2.new(0, (i-1) * 75, 0, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabBtn.TextSize = 12
        tabBtn.Font = Enum.Font.Arcade
        tabBtn.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabBtn
        
        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = Color3.fromRGB(100, 0, 0)
        tabStroke.Thickness = 1
        tabStroke.Parent = tabBtn
        
        TabButtons[tabName] = {button = tabBtn, stroke = tabStroke}
        
        tabBtn.MouseButton1Click:Connect(function()
            self:SwitchTab(tabName)
        end)
    end
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -105)
    contentFrame.Position = UDim2.new(0, 10, 0, 95)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = MainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = contentFrame
    
    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.fromRGB(60, 0, 0)
    contentStroke.Thickness = 1
    contentStroke.Parent = contentFrame
    
    -- ScrollingFrame
    ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
    ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = contentFrame
    
    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 8)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Parent = ScrollFrame
    
    scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Initialize tab content
    for _, tabName in ipairs(tabs) do
        TabContent[tabName] = {}
    end
    
    -- Setup Discord tab content
    self:SetupDiscordTab()
    
    -- 🔥 CRITICAL: Delay to ensure everything loads before connecting events
    task.wait(0.1)
    
    -- Toggle button functionality
    ToggleButton.MouseButton1Click:Connect(function()
        print("🔘 Toggle button clicked!")
        MainFrame.Visible = not MainFrame.Visible
        print("📱 UI Visibility:", MainFrame.Visible and "SHOW" or "HIDE")
    end)
    
    -- Set default tab
    self:SwitchTab("Main")
    
    print("✅ UI Created Successfully!")
end

-- ==================== HELPER FUNCTIONS ====================
function NightmareHub:CreateToggleButton(text, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -10, 0, 35)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = text
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.Arcade
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = toggleBtn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Parent = toggleBtn
    
    local isToggled = false
    
    toggleBtn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        if isToggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        end
        
        if callback then callback(isToggled) end
    end)
    
    return toggleBtn
end

-- 🔥 FIXED: Create regular button WITH COLOR CHANGES
function NightmareHub:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Arcade
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Parent = button
    
    -- 🔥 FIXED: Click with color changes but not toggle
    button.MouseButton1Click:Connect(function()
        print("🔘 BUTTON CLICKED:", text)
        if callback then 
            callback() 
        end
    end)
    
    return button
end

function NightmareHub:CreateSection(text)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -10, 0, 25)
    section.BackgroundTransparency = 1
    section.Text = "━━ " .. text .. " ━━"
    section.TextColor3 = Color3.fromRGB(255, 50, 50)
    section.TextSize = 12
    section.Font = Enum.Font.Arcade
    
    return section
end

function NightmareHub:CreateTextBox(placeholderText)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 0, 35)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = placeholderText or ""
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 14
    textBox.Font = Enum.Font.Arcade
    textBox.ClearTextOnFocus = false
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextTruncate = Enum.TextTruncate.AtEnd
    
    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 10)
    inputPadding.PaddingRight = UDim.new(0, 10)
    inputPadding.Parent = textBox
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 8)
    textBoxCorner.Parent = textBox
    
    local textBoxStroke = Instance.new("UIStroke")
    textBoxStroke.Color = Color3.fromRGB(0, 0, 0)
    textBoxStroke.Thickness = 0.5
    textBoxStroke.Parent = textBox
    
    return textBox
end

-- ==================== DYNAMIC TAB FUNCTIONS ====================
function NightmareHub:AddMainToggle(text, callback)
    local toggle = self:CreateToggleButton(text, callback)
    table.insert(TabContent["Main"], toggle)
    toggle.Parent = ScrollFrame
    toggle.Visible = (CurrentTab == "Main")
    return toggle
end

function NightmareHub:AddVisualToggle(text, callback)
    local toggle = self:CreateToggleButton(text, callback)
    table.insert(TabContent["Visual"], toggle)
    toggle.Parent = ScrollFrame
    toggle.Visible = (CurrentTab == "Visual")
    return toggle
end

function NightmareHub:AddMiscToggle(text, callback)
    local toggle = self:CreateToggleButton(text, callback)
    table.insert(TabContent["Misc"], toggle)
    toggle.Parent = ScrollFrame
    toggle.Visible = (CurrentTab == "Misc")
    return toggle
end

-- ==================== DISCORD TAB (WITH COLOR CHANGES) ====================
function NightmareHub:SetupDiscordTab()
    -- Social Section
    local socialSection = self:CreateSection("SOCIAL")
    table.insert(TabContent["Discord"], socialSection)
    socialSection.Parent = ScrollFrame
    socialSection.Visible = false
    
    -- 🔥 TIKTOK BUTTON (WITH COLOR CHANGES)
    local tiktokBtn = self:CreateButton("Tiktok", function()
        print("🔥 Tiktok clicked")
        setclipboard("https://www.tiktok.com/@n1ghtmare.gg?_r=1&_t=ZS-91TYDcuhlRQ")
        tiktokBtn.Text = "COPIED!"
        tiktokBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(2)
        tiktokBtn.Text = "Tiktok"
        tiktokBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end)
    table.insert(TabContent["Discord"], tiktokBtn)
    tiktokBtn.Parent = ScrollFrame
    tiktokBtn.Visible = false
    
    -- 🔥 DISCORD BUTTON (WITH COLOR CHANGES)
    local discordBtn = self:CreateButton("Discord", function()
        print("🔥 Discord clicked")
        setclipboard("https://discord.gg/Bcdt9nXV")
        discordBtn.Text = "COPIED!"
        discordBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(2)
        discordBtn.Text = "Discord"
        discordBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end)
    table.insert(TabContent["Discord"], discordBtn)
    discordBtn.Parent = ScrollFrame
    discordBtn.Visible = false
    
    -- Server Section
    local serverSection = self:CreateSection("SERVER")
    table.insert(TabContent["Discord"], serverSection)
    serverSection.Parent = ScrollFrame
    serverSection.Visible = false
    
    -- Job ID Input
    local jobIdInput = self:CreateTextBox("Input Job Id")
    table.insert(TabContent["Discord"], jobIdInput)
    jobIdInput.Parent = ScrollFrame
    jobIdInput.Visible = false
    
    -- 🔥 JOIN SERVER BUTTON (WITH COLOR CHANGES)
    local joinServerBtn = self:CreateButton("Join Server", function()
        if ButtonStates.joinServer then return end
        
        local jobId = jobIdInput.Text:gsub("%s+", "")
        
        if jobId == "" then
            ButtonStates.joinServer = true
            joinServerBtn.Text = "ENTER JOB ID!"
            joinServerBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            task.wait(1.5)
            joinServerBtn.Text = "Join Server"
            joinServerBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            ButtonStates.joinServer = false
        else
            ButtonStates.joinServer = true
            joinServerBtn.Text = "JOINING..."
            joinServerBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            
            task.spawn(function()
                local success = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
                end)
                
                if success then
                    joinServerBtn.Text = "TELEPORTING..."
                    joinServerBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                    task.wait(2)
                else
                    joinServerBtn.Text = "FAILED!"
                    joinServerBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    task.wait(2)
                end
                
                joinServerBtn.Text = "Join Server"
                joinServerBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
                ButtonStates.joinServer = false
            end)
        end
    end)
    table.insert(TabContent["Discord"], joinServerBtn)
    joinServerBtn.Parent = ScrollFrame
    joinServerBtn.Visible = false
    
    -- 🔥 COPY JOB ID BUTTON (WITH COLOR CHANGES)
    local copyJobIdBtn = self:CreateButton("Copy Current Job ID", function()
        print("🔥 Copy Job ID clicked")
        local currentJobId = game.JobId
        if currentJobId and currentJobId ~= "" then
            setclipboard(currentJobId)
            copyJobIdBtn.Text = "COPIED: " .. currentJobId:sub(1, 8) .. "..."
            copyJobIdBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            task.wait(2)
            copyJobIdBtn.Text = "Copy Current Job ID"
            copyJobIdBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        else
            copyJobIdBtn.Text = "NO JOB ID!"
            copyJobIdBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            task.wait(1)
            copyJobIdBtn.Text = "Copy Current Job ID"
            copyJobIdBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        end
    end)
    table.insert(TabContent["Discord"], copyJobIdBtn)
    copyJobIdBtn.Parent = ScrollFrame
    copyJobIdBtn.Visible = false
    
    -- 🔥 SERVER HOP BUTTON (WITH COLOR CHANGES)
    local serverHopBtn = self:CreateButton("Server Hop", function()
        if ButtonStates.serverHop then return end
        
        ButtonStates.serverHop = true
        serverHopBtn.Text = "SEARCHING..."
        serverHopBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
        task.spawn(function()
            local servers = {}
            local cursor = ""
            
            repeat
                local url = string.format(
                    "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&cursor=%s",
                    game.PlaceId,
                    cursor
                )
                
                local success, result = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(url))
                end)
                
                if success and result.data then
                    for _, server in ipairs(result.data) do
                        if server.id ~= game.JobId and server.playing < server.maxPlayers then
                            table.insert(servers, server.id)
                        end
                    end
                    cursor = result.nextPageCursor or ""
                else
                    break
                end
            until cursor == ""
            
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                local success = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
                end)
                
                if success then
                    serverHopBtn.Text = "HOPPING..."
                    serverHopBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                    task.wait(2)
                else
                    serverHopBtn.Text = "FAILED!"
                    serverHopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                    task.wait(2)
                end
            else
                serverHopBtn.Text = "NO SERVERS!"
                serverHopBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                task.wait(2)
            end
            
            serverHopBtn.Text = "Server Hop"
            serverHopBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            ButtonStates.serverHop = false
        end)
    end)
    table.insert(TabContent["Discord"], serverHopBtn)
    serverHopBtn.Parent = ScrollFrame
    serverHopBtn.Visible = false
    
    -- 🔥 REJOIN BUTTON (WITH COLOR CHANGES)
    local rejoinBtn = self:CreateButton("Rejoin Server", function()
        if ButtonStates.rejoin then return end
        
        ButtonStates.rejoin = true
        rejoinBtn.Text = "REJOINING..."
        rejoinBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        
        task.spawn(function()
            local success = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
            
            if success then
                rejoinBtn.Text = "TELEPORTING..."
                rejoinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                task.wait(2)
            else
                rejoinBtn.Text = "FAILED!"
                rejoinBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                task.wait(2)
            end
            
            rejoinBtn.Text = "Rejoin Server"
            rejoinBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            ButtonStates.rejoin = false
        end)
    end)
    table.insert(TabContent["Discord"], rejoinBtn)
    rejoinBtn.Parent = ScrollFrame
    rejoinBtn.Visible = false
    
    -- Utility Section
    local utilitySection = self:CreateSection("UTILITY")
    table.insert(TabContent["Discord"], utilitySection)
    utilitySection.Parent = ScrollFrame
    utilitySection.Visible = false
    
    -- Dynamic Island Toggle (KEPT AS TOGGLE)
    local dynamicIslandGui = nil
    local isDynamicIslandActive = false
    
    local function createDynamicIsland()
        if game.CoreGui:FindFirstChild("DynamicIslandGUI") then
            game.CoreGui:FindFirstChild("DynamicIslandGUI"):Destroy()
        end
        
        local diScreenGui = Instance.new("ScreenGui")
        diScreenGui.Name = "DynamicIslandGUI"
        diScreenGui.Parent = game.CoreGui
        diScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        diScreenGui.ResetOnSpawn = false
        
        local dynamicIsland = Instance.new("Frame")
        dynamicIsland.Name = "DynamicIsland"
        dynamicIsland.Size = UDim2.new(0, 400, 0, 70)
        dynamicIsland.Position = UDim2.new(0.5, -200, 0, 10)
        dynamicIsland.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        dynamicIsland.BorderSizePixel = 0
        dynamicIsland.Parent = diScreenGui
        dynamicIsland.Active = true
        
        local islandCorner = Instance.new("UICorner")
        islandCorner.CornerRadius = UDim.new(0, 35)
        islandCorner.Parent = dynamicIsland
        
        local islandStroke = Instance.new("UIStroke")
        islandStroke.Color = Color3.fromRGB(40, 40, 40)
        islandStroke.Thickness = 1
        islandStroke.Transparency = 0.5
        islandStroke.Parent = dynamicIsland
        
        -- Avatar Container
        local avatarContainer = Instance.new("Frame")
        avatarContainer.Name = "AvatarContainer"
        avatarContainer.Size = UDim2.new(0, 55, 0, 55)
        avatarContainer.Position = UDim2.new(0, 8, 0.5, -27.5)
        avatarContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        avatarContainer.BorderSizePixel = 0
        avatarContainer.Parent = dynamicIsland
        
        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(1, 0)
        avatarCorner.Parent = avatarContainer
        
        local avatarImage = Instance.new("ImageLabel")
        avatarImage.Name = "Avatar"
        avatarImage.Size = UDim2.new(1, -4, 1, -4)
        avatarImage.Position = UDim2.new(0, 2, 0, 2)
        avatarImage.BackgroundTransparency = 1
        avatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        avatarImage.Parent = avatarContainer
        
        local avatarImgCorner = Instance.new("UICorner")
        avatarImgCorner.CornerRadius = UDim.new(1, 0)
        avatarImgCorner.Parent = avatarImage
        
        -- Info Container
        local infoContainer = Instance.new("Frame")
        infoContainer.Name = "InfoContainer"
        infoContainer.Size = UDim2.new(1, -260, 1, 0)
        infoContainer.Position = UDim2.new(0, 70, 0, 0)
        infoContainer.BackgroundTransparency = 1
        infoContainer.Parent = dynamicIsland
        
        local usernameLabel = Instance.new("TextLabel")
        usernameLabel.Name = "Username"
        usernameLabel.Size = UDim2.new(1, 0, 0, 18)
        usernameLabel.Position = UDim2.new(0, 0, 0, 8)
        usernameLabel.BackgroundTransparency = 1
        usernameLabel.Text = "@" .. LocalPlayer.Name
        usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        usernameLabel.Font = Enum.Font.GothamBold
        usernameLabel.TextSize = 15
        usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
        usernameLabel.Parent = infoContainer
        
        -- Stats Container
        local statsContainer = Instance.new("Frame")
        statsContainer.Name = "StatsContainer"
        statsContainer.Size = UDim2.new(1, 0, 0, 22)
        statsContainer.Position = UDim2.new(0, 0, 1, -27)
        statsContainer.BackgroundTransparency = 1
        statsContainer.Parent = infoContainer
        
        -- FPS Container
        local fpsContainer = Instance.new("Frame")
        fpsContainer.Name = "FPS"
        fpsContainer.Size = UDim2.new(0.33, -2, 1, 0)
        fpsContainer.Position = UDim2.new(0, 0, 0, 0)
        fpsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        fpsContainer.BorderSizePixel = 0
        fpsContainer.Parent = statsContainer
        
        local fpsCorner = Instance.new("UICorner")
        fpsCorner.CornerRadius = UDim.new(0, 8)
        fpsCorner.Parent = fpsContainer
        
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Name = "FPSValue"
        fpsLabel.Size = UDim2.new(1, 0, 1, 0)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.Text = "60"
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        fpsLabel.Font = Enum.Font.GothamBold
        fpsLabel.TextSize = 11
        fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
        fpsLabel.Parent = fpsContainer
        
        -- Ping Container
        local pingContainer = Instance.new("Frame")
        pingContainer.Name = "Ping"
        pingContainer.Size = UDim2.new(0.33, 1, 1, 0)
        pingContainer.Position = UDim2.new(0.33, 1, 0, 0)
        pingContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        pingContainer.BorderSizePixel = 0
        pingContainer.Parent = statsContainer
        
        local pingCorner = Instance.new("UICorner")
        pingCorner.CornerRadius = UDim.new(0, 8)
        pingCorner.Parent = pingContainer
        
        local pingLabel = Instance.new("TextLabel")
        pingLabel.Name = "PingValue"
        pingLabel.Size = UDim2.new(1, 0, 1, 0)
        pingLabel.BackgroundTransparency = 1
        pingLabel.Text = "0ms"
        pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        pingLabel.Font = Enum.Font.GothamBold
        pingLabel.TextSize = 11
        pingLabel.TextXAlignment = Enum.TextXAlignment.Center
        pingLabel.Parent = pingContainer
        
        -- Time Container
        local timeContainer = Instance.new("Frame")
        timeContainer.Name = "Time"
        timeContainer.Size = UDim2.new(0.33, 2, 1, 0)
        timeContainer.Position = UDim2.new(0.66, 5, 0, 0)
        timeContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        timeContainer.BorderSizePixel = 0
        timeContainer.Parent = statsContainer
        
        local timeCorner = Instance.new("UICorner")
        timeCorner.CornerRadius = UDim.new(0, 8)
        timeCorner.Parent = timeContainer
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Name = "TimeValue"
        timeLabel.Size = UDim2.new(1, 0, 1, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = "00:00"
        timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        timeLabel.Font = Enum.Font.GothamBold
        timeLabel.TextSize = 11
        timeLabel.TextXAlignment = Enum.TextXAlignment.Center
        timeLabel.Parent = timeContainer
        
        -- Draggable functionality
        local dragging = false
        local dragInput, dragStart, startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            dynamicIsland.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        dynamicIsland.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = dynamicIsland.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        dynamicIsland.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
        
        -- FPS Counter
        local lastTime = tick()
        local frameCount = 0
        local fps = 60
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if not isDynamicIslandActive then return end
            
            frameCount = frameCount + 1
            local currentTime = tick()
            
            if currentTime - lastTime >= 1 then
                fps = frameCount
                frameCount = 0
                lastTime = currentTime
                
                fpsLabel.Text = tostring(fps)
                
                if fps >= 55 then
                    fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif fps >= 30 then
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end)
        
        -- Ping Counter
        spawn(function()
            while wait(2) do
                if not isDynamicIslandActive then break end
                
                local success, ping = pcall(function()
                    return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                end)
                
                if success then
                    local pingValue = math.floor(ping)
                    pingLabel.Text = pingValue .. "ms"
                    
                    if pingValue <= 100 then
                        pingLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    elseif pingValue <= 200 then
                        pingLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    else
                        pingLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end)
        
        -- Time Update
        spawn(function()
            while wait(1) do
                if not isDynamicIslandActive then break end
                
                local time = os.date("*t")
                timeLabel.Text = string.format("%02d:%02d", time.hour, time.min)
            end
        end)
        
        return diScreenGui
    end
    
    -- Dynamic Island Toggle (KEPT AS TOGGLE)
    local dynamicIslandBtn = self:CreateToggleButton("Dynamic Island", function(state)
        isDynamicIslandActive = state
        
        if state then
            dynamicIslandGui = createDynamicIsland()
            print("✅ Dynamic Island ON")
        else
            if dynamicIslandGui then
                dynamicIslandGui:Destroy()
                dynamicIslandGui = nil
            end
            if game.CoreGui:FindFirstChild("DynamicIslandGUI") then
                game.CoreGui:FindFirstChild("DynamicIslandGUI"):Destroy()
            end
            print("❌ Dynamic Island OFF")
        end
    end)
    table.insert(TabContent["Discord"], dynamicIslandBtn)
    dynamicIslandBtn.Parent = ScrollFrame
    dynamicIslandBtn.Visible = false
end

-- ==================== TAB SWITCHING ====================
function NightmareHub:SwitchTab(tabName)
    CurrentTab = tabName
    
    -- Update tab button colors
    for name, data in pairs(TabButtons) do
        if name == tabName then
            data.button.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            data.button.TextColor3 = Color3.fromRGB(255, 255, 255)
            data.stroke.Color = Color3.fromRGB(255, 50, 50)
        else
            data.button.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
            data.button.TextColor3 = Color3.fromRGB(150, 150, 150)
            data.stroke.Color = Color3.fromRGB(100, 0, 0)
        end
    end
    
    -- Show/hide content
    for _, items in pairs(TabContent) do
        for _, item in ipairs(items) do
            item.Visible = false
        end
    end
    
    if TabContent[tabName] then
        for _, item in ipairs(TabContent[tabName]) do
            item.Visible = true
        end
    end
end

return NightmareHub
