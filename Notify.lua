-- Hi, heres documentation..
--[[
    local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Iceware-RBLX/Storage/refs/heads/main/Notify.lua"))()

    Notify({
        Name = "Success",
        Description = "Notification system has been loaded!",
        Duration = 5,
        Icon = "9080568477801",
        IconColor = Color3.fromRGB(0, 255, 0)
    })
]]



local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local gethui = gethui or function()
    return CoreGui
end

local FromRGB = Color3.fromRGB
local FromHSV = Color3.fromHSV
local UDim2New = UDim2.new
local UDimNew = UDim.new
local Vector2New = Vector2.new
local InstanceNew = Instance.new
local TableInsert = table.insert
local StringFormat = string.format

local Library = {
    Font = Font.new("rbxasset://fonts/families/Inter.json", Enum.FontWeight.SemiBold), -- Inter SemiBold
    Theme = {
        Background = FromRGB(16, 18, 21),
        Border = FromRGB(32, 36, 42),
        Text = FromRGB(255, 255, 255),
        ["Inactive Text"] = FromRGB(128, 128, 128),
        Accent = FromRGB(196, 231, 255)
    },
    Tween = {
        Time = 0.3,
        Style = Enum.EasingStyle.Cubic,
        Direction = Enum.EasingDirection.Out
    },
    Connections = {},
    Threads = {},
    UnnamedConnections = 0,
    ThemeItems = {},
    ThemeMap = {}
}

local Tween = {}
Tween.__index = Tween

function Tween:Create(Item, Info, Goal, IsRawItem)
    Item = IsRawItem and Item or Item.Instance
    Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

    local NewTween = {
        Tween = TweenService:Create(Item, Info, Goal),
        Info = Info,
        Goal = Goal,
        Item = Item
    }

    NewTween.Tween:Play()
    setmetatable(NewTween, Tween)
    return NewTween
end

local Instances = {}
Instances.__index = Instances

function Instances:Create(Class, Properties)
    local NewItem = {
        Instance = Instance.new(Class),
        Properties = Properties,
        Class = Class
    }

    setmetatable(NewItem, Instances)

    for Property, Value in pairs(NewItem.Properties) do
        NewItem.Instance[Property] = Value
    end

    return NewItem
end

function Instances:Tween(Info, Goal)
    return Tween:Create(self, Info, Goal)
end

function Instances:AddToTheme(Properties)
    for Property, Value in pairs(Properties) do
        if type(Value) == "string" then
            self.Instance[Property] = Library.Theme[Value]
        end
    end
end

function Instances:Clean()
    if self.Instance then
        self.Instance:Destroy()
    end
end

function Library:Thread(Function)
    local NewThread = coroutine.create(Function)
    coroutine.wrap(function()
        coroutine.resume(NewThread)
    end)()
    TableInsert(self.Threads, NewThread)
    return NewThread
end

local Screen = Instance.new("ScreenGui")
Screen.Name = "Notifications"
Screen.DisplayOrder = 100
Screen.Parent = gethui()

Library.NotifHolder = Instances:Create("Frame", {
    Parent = Screen,
    Name = "NotifHolder",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2New(1, 0),
    Position = UDim2New(1, -15, 0, 15),
    Size = UDim2New(0, 0, 1, 0),
    BorderSizePixel = 0,
    AutomaticSize = Enum.AutomaticSize.X,
})

Instances:Create("UIListLayout", {
    Parent = Library.NotifHolder.Instance,
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDimNew(0, 10)
})

Library.Notification = function(self, Data)
    Data = Data or { }

    local Notification = {
        Name = Data.Name or Data.name or "Title",
        Description = Data.Description or Data.description or "Description",
        Duration = Data.Duration or Data.duration or 5,
        Icon = Data.Icon or Data.icon or "9080568477801",
        IconColor = Data.IconColor or Data.iconcolor or FromRGB(255, 255, 255),
    }

    local Items = { } do
        Items["Notification"] = Instances:Create("Frame", {
            Parent = Library.NotifHolder.Instance,
            Name = "\0",
            BorderColor3 = FromRGB(0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundColor3 = FromRGB(16, 18, 21)
        })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background"})

        Instances:Create("UIStroke", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            Color = FromRGB(32, 36, 42),
            Transparency = 0.4000000059604645,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }):AddToTheme({Color = "Border"})

        Instances:Create("UICorner", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            CornerRadius = UDimNew(0, 5)
        })

        Instances:Create("UIPadding", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            PaddingTop = UDimNew(0, 8),
            PaddingBottom = UDimNew(0, 8),
            PaddingRight = UDimNew(0, 8),
            PaddingLeft = UDimNew(0, 8)
        })

        if Notification.Icon then 
            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                ImageColor3 = Notification.IconColor,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                Image = "rbxassetid://"..Notification.Icon,
                BackgroundTransparency = 1,
                Position = UDim2New(1, 5, 0, 0),
                Size = UDim2New(0, 22, 0, 22),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
        end

        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = Notification.Name,
            Size = UDim2New(0, 0, 0, 15),
            BackgroundTransparency = 1,
            Position = UDim2New(0, 0, 0, 2),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 14,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

        Items["Description"] = Instances:Create("TextLabel", {
            Parent = Items["Notification"].Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            TextTransparency = 0.5,
            Text = Notification.Description,
            Size = UDim2New(0, 0, 0, 15),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 0, 0, 24),
            BorderColor3 = FromRGB(0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            TextSize = 14,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["Description"]:AddToTheme({TextColor3 = "Inactive Text"})
    end

    local OldSize = Items["Notification"].Instance.AbsoluteSize
    Items["Notification"].Instance.BackgroundTransparency = 1
    Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)

    for Index, Value in Items["Notification"].Instance:GetDescendants() do
        if Value:IsA("UIStroke") then 
            Value.Transparency = 1
        elseif Value:IsA("TextLabel") then 
            Value.TextTransparency = 1
        elseif Value:IsA("ImageLabel") then 
            Value.ImageTransparency = 1
        elseif Value:IsA("Frame") then 
            Value.BackgroundTransparency = 1
        end
    end
    
    task.wait(0.2)

    Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None

    Library:Thread(function()
        Items["Notification"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0,  OldSize.X, 0, OldSize.Y)})
        
        task.wait(0.06)

        for Index, Value in Items["Notification"].Instance:GetDescendants() do
            if Value:IsA("UIStroke") then
                Tween:Create(Value, nil, {Transparency = 0}, true)
            elseif Value:IsA("TextLabel") then
                Tween:Create(Value, nil, {TextTransparency = 0}, true)
            elseif Value:IsA("ImageLabel") then
                Tween:Create(Value, nil, {ImageTransparency = 0}, true)
            elseif Value:IsA("Frame") then
                Tween:Create(Value, nil, {BackgroundTransparency = 0}, true)
            end
        end

        task.delay(Notification.Duration, function()
            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("UIStroke") then
                    Tween:Create(Value, nil, {Transparency = 1}, true)
                elseif Value:IsA("TextLabel") then
                    Tween:Create(Value, nil, {TextTransparency = 1}, true)
                elseif Value:IsA("ImageLabel") then
                    Tween:Create(Value, nil, {ImageTransparency = 1}, true)
                elseif Value:IsA("Frame") then
                    Tween:Create(Value, nil, {BackgroundTransparency = 1}, true)
                end
            end

            task.wait(0.06)

            Items["Notification"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})

            task.wait(0.5)
            Items["Notification"]:Clean()
        end)
    end)

    return Notification
end


return function(Data)
    return Library:Notification(Data)
end

