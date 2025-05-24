-- Создаем основной GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AdvancedGUI"
gui.Parent = game:GetService("CoreGui")

-- Главный фрейм (теперь можно перемещать)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- Для перемещения
mainFrame.Draggable = true -- Включаем перемещение
mainFrame.Parent = gui

-- Заголовок (удерживать для перемещения)
local title = Instance.new("TextLabel")
title.Text = "Меню управления (удерживайте для перемещения)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Parent = mainFrame

-- Вкладки
local tabs = {"Главная", "Инфо", "GUI SETTINGS"}
local currentTab = "Главная"

local tabButtons = {}
local tabContent = Instance.new("Frame")
tabContent.Size = UDim2.new(1, -20, 1, -70)
tabContent.Position = UDim2.new(0, 10, 0, 60)
tabContent.BackgroundTransparency = 1
tabContent.Parent = mainFrame

-- Переменные для управления
local currentKeybind = Enum.KeyCode.LeftAlt
local guiVisible = true
local waitingForInput = false

-- Функция обновления вкладок
local function updateTabs()
    -- Очищаем предыдущий контент
    for _, child in ipairs(tabContent:GetChildren()) do
        child:Destroy()
    end
    
    -- Обновляем кнопки
    for tabName, button in pairs(tabButtons) do
        button.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 60)
    end
    
    -- Создаем контент для текущей вкладки
-- Добавляем этот код в раздел создания вкладки "GUI SETTINGS"
if currentTab == "Главная" then
    local settingsFrame = Instance.new("Frame")
    settingsFrame.Size = UDim2.new(1, 0, 1, 0)
    settingsFrame.BackgroundTransparency = 1
    settingsFrame.Parent = tabContent

    -- Заголовок
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Text = "Настройки скорости:"
    speedLabel.Size = UDim2.new(1, 0, 0, 20)
    speedLabel.Position = UDim2.new(0, 0, 0, 10)
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.SourceSansSemibold
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = settingsFrame

    -- Контейнер слайдера (фиксирует баг с перемещением GUI)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = UDim2.new(1, -20, 0, 30)
    sliderContainer.Position = UDim2.new(0, 10, 0, 40)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = settingsFrame

    -- Фон слайдера
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 10)
    sliderFrame.Position = UDim2.new(0, 0, 0, 10)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = sliderContainer

    -- Ползунок (круглый для красоты)
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new(0.5, -10, 0, 0) -- Начальная позиция 50%
    sliderButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderContainer

    -- Скругление (если executor поддерживает UICorner)
    pcall(function()
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = sliderButton
    end)

    -- Текст значения
    local sliderText = Instance.new("TextLabel")
    sliderText.Text = "50%"
    sliderText.Size = UDim2.new(1, 0, 0, 20)
    sliderText.Position = UDim2.new(0, 0, 0, -5)
    sliderText.BackgroundTransparency = 1
    sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderText.Parent = sliderContainer

    -- Настройки скорости
    local minSpeed, maxSpeed = 16, 100
    local defaultSpeed = 0.5 -- 50%

    -- Функция обновления скорости
    local function updateSpeed(sliderPercent)
        local speed = minSpeed + (maxSpeed - minSpeed) * sliderPercent
        sliderText.Text = math.floor(speed) .. "%"
        
        -- Применяем к персонажу
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end

    -- Перетаскивание ползунка (теперь без багов)
    local isDragging = false
    local startX, startPosX

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            startX = input.Position.X
            startPosX = sliderButton.Position.X.Offset
        end
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local deltaX = input.Position.X - startX
            local newPos = math.clamp(startPosX + deltaX, 0, sliderFrame.AbsoluteSize.X - 20)
            
            sliderButton.Position = UDim2.new(0, newPos, 0, 0)
            local percent = newPos / (sliderFrame.AbsoluteSize.X - 20)
            updateSpeed(percent)
        end
    end)

    -- Кнопка сброса (теперь точно 50%)
    local resetButton = Instance.new("TextButton")
    resetButton.Text = "Сбросить (50%)"
    resetButton.Size = UDim2.new(1, -20, 0, 25)
    resetButton.Position = UDim2.new(0, 10, 0, 80)
    resetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetButton.Parent = settingsFrame

    resetButton.MouseButton1Click:Connect(function()
        sliderButton.Position = UDim2.new(0.5, -10, 0, 0)
        updateSpeed(defaultSpeed)
    end)

    -- Инициализация
    updateSpeed(defaultSpeed)

    return settingsFrame
        
    elseif currentTab == "Инфо" then
        local label = Instance.new("TextLabel")
        label.Text = "Автор: Drix707\nВерсия: 2.0\n\nGUI с возможностью:\n- Перемещения\n- Смены клавиши\n- Нескольких вкладок"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1
        label.TextWrapped = true
        label.Parent = tabContent
        
    elseif currentTab == "GUI SETTINGS" then
        local settingsFrame = Instance.new("Frame")
        settingsFrame.Size = UDim2.new(1, 0, 1, 0)
        settingsFrame.BackgroundTransparency = 1
        settingsFrame.Parent = tabContent
        
        local keybindText = Instance.new("TextLabel")
        keybindText.Text = "Текущая клавиша:"
        keybindText.Size = UDim2.new(0, 150, 0, 30)
        keybindText.Position = UDim2.new(0, 10, 0, 10)
        keybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
        keybindText.BackgroundTransparency = 1
        keybindText.Parent = settingsFrame
        
        local currentKeyDisplay = Instance.new("TextLabel")
        currentKeyDisplay.Name = "CurrentKeyDisplay"
        currentKeyDisplay.Text = tostring(currentKeybind):gsub("Enum.KeyCode.", "")
        currentKeyDisplay.Size = UDim2.new(0, 100, 0, 30)
        currentKeyDisplay.Position = UDim2.new(0, 170, 0, 10)
        currentKeyDisplay.TextColor3 = Color3.fromRGB(200, 200, 255)
        currentKeyDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        currentKeyDisplay.Parent = settingsFrame
        
        local rebindButton = Instance.new("TextButton")
        rebindButton.Text = "Сменить клавишу"
        rebindButton.Size = UDim2.new(0.8, 0, 0, 30)
        rebindButton.Position = UDim2.new(0.1, 0, 0, 50)
        rebindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        rebindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        rebindButton.Parent = settingsFrame
        
        rebindButton.MouseButton1Click:Connect(function()
            waitingForInput = true
            rebindButton.Text = "Нажмите новую клавишу..."
            currentKeyDisplay.Text = "..."
        end)
    end
end

-- Создаем кнопки вкладок
for i, tabName in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Text = tabName
    button.Size = UDim2.new(0.3, -5, 0, 30)
    button.Position = UDim2.new(0.3 * (i-1) + 0.05, 0, 0, 25)
    button.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = mainFrame
    tabButtons[tabName] = button
    
    button.MouseButton1Click:Connect(function()
        currentTab = tabName
        updateTabs()
    end)
end

-- Функция переключения видимости GUI
local function toggleGUI()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
end

-- Обработчик ввода для смены клавиши
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if waitingForInput and not gameProcessed then
        currentKeybind = input.KeyCode
        if mainFrame:FindFirstChild("CurrentKeyDisplay") then
            mainFrame.CurrentKeyDisplay.Text = tostring(currentKeybind):gsub("Enum.KeyCode.", "")
        end
        waitingForInput = false
        updateTabs()
    elseif input.KeyCode == currentKeybind and not gameProcessed and not waitingForInput then
        toggleGUI()
    end
end)

-- Инициализация
updateTabs()

-- Защита GUI (если поддерживается)
if protectgui then
    protectgui(gui)
end

print("GUI успешно загружено! Нажмите "..tostring(currentKeybind):gsub("Enum.KeyCode.", "").." для переключения.")
