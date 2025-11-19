local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomWindowGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local WindowFrame = Instance.new("Frame")
WindowFrame.Name = "K Script"
WindowFrame.Size = UDim2.new(0.6, 0, 0.5, 0)
WindowFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
WindowFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Màu nền cửa sổ
WindowFrame.BorderSizePixel = 0
WindowFrame.Parent = ScreenGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 10) 
WindowCorner.Parent = WindowFrame

local OriginalSize = WindowFrame.Size
local OriginalPosition = WindowFrame.Position 
local IsMinimized = false

---------------------------------------------------
-- TẠO BONG BÓNG THU NHỎ (Minimized Bubble)
---------------------------------------------------
local MinimizedBubble = Instance.new("ImageLabel")
MinimizedBubble.Name = "MinimizedKBubble"
MinimizedBubble.Size = UDim2.new(0, 50, 0, 50)
MinimizedBubble.Position = UDim2.new(0, 40, 1, -450) 
MinimizedBubble.Image = "rbxassetid://421795165" 
-- ✨ ĐÃ ĐỔI MÀU NỀN GIỐNG WINDOWFRAME
MinimizedBubble.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
-- Điều chỉnh BackgroundTransparency nếu hình ảnh chữ K đã có nền
MinimizedBubble.BackgroundTransparency = 0 -- Nếu ảnh đã trong suốt, đặt 0. Nếu ảnh có nền thì đặt 0.8 để pha màu
MinimizedBubble.Parent = ScreenGui
MinimizedBubble.Visible = false 
MinimizedBubble.Active = true 
MinimizedBubble.ZIndex = 10 

local BubbleCorner = Instance.new("UICorner") 
BubbleCorner.CornerRadius = UDim.new(0.5, 0) 
BubbleCorner.Parent = MinimizedBubble
-- ... (Khai báo các nút và nhãn giữ nguyên) ...

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.new(0.05, 0, 0.085, 0)
CloseButton.Position = UDim2.new(0.951, 0, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = WindowFrame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10) 
CloseCorner.Parent = CloseButton

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Size = UDim2.new(0.05, 0, 0.085, 0)
MinimizeButton.Position = UDim2.new(0.9, 0, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = WindowFrame
local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 10) 
MinimizeCorner.Parent = MinimizeButton
MinimizeButton.TextScaled = true
MinimizeButton.TextWrapped = true

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0.125, 0, 0.085, 0)
TitleLabel.Position = UDim2.new(0.03, 0, 0, 0)
TitleLabel.Text = "K Script"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.BorderSizePixel = 0
TitleLabel.Parent = WindowFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10) 
TitleCorner.Parent = TitleLabel
TitleLabel.TextScaled = true
TitleLabel.TextWrapped = true

---------------------------------------------------
-- LOGIC SỰ KIỆN MINIMIZE/MAXIMIZE
---------------------------------------------------

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    MinimizedBubble.Visible = false
end)

local function MaximizeWindow()
    WindowFrame.Visible = true
    MinimizedBubble.Visible = false
    
    WindowFrame:TweenSize(OriginalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    WindowFrame:TweenPosition(OriginalPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    MinimizeButton.Text = "-"
    IsMinimized = false
end

local function MinimizeWindow()
    OriginalPosition = WindowFrame.Position 
    WindowFrame.Visible = false 
    
    MinimizedBubble.Visible = true
    MinimizeButton.Text = "⬜"
    IsMinimized = true
end

MinimizeButton.MouseButton1Click:Connect(function()
    if IsMinimized then
        MaximizeWindow()
    else
        MinimizeWindow()
    end
end)

---------------------------------------------------
-- PHẦN CODE KÉO THẢ VÀ PHỤC HỒI
---------------------------------------------------

local Dragging = false
local DragStart = nil
local StartPos = nil

local BubbleDragging = false
local BubbleDragStart = nil
local BubbleStartPos = nil
local ClickTolerance = 5

-- Logic kéo thả WINDOW FRAME
WindowFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = UserInputService:GetMouseLocation()
        StartPos = WindowFrame.Position
        WindowFrame.Active = true 
    end
end)

-- Logic kéo thả BONG BÓNG
MinimizedBubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        BubbleDragging = true
        BubbleDragStart = UserInputService:GetMouseLocation()
        BubbleStartPos = MinimizedBubble.Position
        MinimizedBubble.Active = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        -- Kết thúc kéo Window Frame
        if Dragging then
            Dragging = false
            WindowFrame.Active = false
        end

        -- Xử lý kết thúc kéo Bong bóng VÀ Phục hồi
        if BubbleDragging then
            BubbleDragging = false
            MinimizedBubble.Active = false
            
            local CurrentMousePos = UserInputService:GetMouseLocation()
            local Distance = (CurrentMousePos - BubbleDragStart).Magnitude
            
            -- Nếu khoảng cách di chuyển nhỏ hơn ClickTolerance, đó là một click -> Phục hồi
            if Distance < ClickTolerance then
                MaximizeWindow()
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    -- Kéo Window Frame
    if Dragging and DragStart and StartPos then
        local MouseDelta = UserInputService:GetMouseLocation() - DragStart
        local NewX = StartPos.X.Offset + MouseDelta.X
        local NewY = StartPos.Y.Offset + MouseDelta.Y
        WindowFrame.Position = UDim2.new(StartPos.X.Scale, NewX, StartPos.Y.Scale, NewY)
    end
    
    -- Kéo Bong bóng
    if BubbleDragging and BubbleDragStart and BubbleStartPos then
        local MouseDelta = UserInputService:GetMouseLocation() - BubbleDragStart
        local NewX = BubbleStartPos.X.Offset + MouseDelta.X
        local NewY = BubbleStartPos.Y.Offset + MouseDelta.Y
        MinimizedBubble.Position = UDim2.new(BubbleStartPos.X.Scale, NewX, BubbleStartPos.Y.Scale, NewY)
    end
end)

ScreenGui.Enabled = true
