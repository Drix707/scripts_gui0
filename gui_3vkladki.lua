-- Создаем основной GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AdvancedGUI"
gui.Parent = game:GetService("CoreGui")

-- Главный фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300) -- Средний размер
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Центр экрана
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Заголовок
local title = Instance.new("TextLabel")
title.Text = "Меню управления"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Parent = mainFrame

-- Вкладки
local tabs = {"Главная", "Инфо", "GUI SETTINGS"}
local currentTab = "Главная"

local tabButtons = {}
local tabContent = Instance.new("Frame")
tabContent.Size = UDim2.new(1, 0, 1, -60)
tabContent.Position = UDim2.new(0, 0, 0, 40)
tabContent.BackgroundTransparency = 1
tabContent.Parent = mainFrame

-- Создаем вкладки
for i, tabName in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Text = tabName
    button.Size = UDim2.new(0.3, -5, 0, 30)
    button.Position = UDim2.new(0.3 * (i-1), 5, 0, 5)
    button.BackgroundColor3 = tabName == currentTab and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(40, 40, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = mainFrame
    tabButtons[tabName] = button
    
    button.MouseButton1Click:Connect(function()
        currentTab = tabName
        updateTabs()
    end)
end

-- Контент для вкладок
local contents = {
    ["Главная"] = "Добро пожаловать в главное меню!",
    ["Инфо"] = "Автор: Drix707\nВерсия: 1.0",
    ["GUI SETTINGS"] = function()
        local settingsFrame = Instance.new("Frame")
        settingsFrame.Size = UDim2.new(1, 0, 1, 0)
        settingsFrame.BackgroundTransparency = 1
        settingsFrame.Parent = tabContent
        
        local keybindText = Instance.new("TextLabel")
        keybindText.Text = "Keybind:"
        keybindText.Size = UDim2.new(0, 100, 0, 30)
        keybindText.Position = UDim2.new(0, 10, 0, 10)
        keybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
        keybindText.Parent = settingsFrame
        
        local currentKey = Instance.new("TextLabel")
        currentKey.Text = "Current: LeftAlt"
        currentKey.Size = UDim2.new(0, 150, 0, 30)
        currentKey.Position = UDim2.new(0, 120, 0, 10)
        currentKey.TextColor3 = Color3.fromRGB(200, 200, 255)
        currentKey.Parent = settingsFrame
        
        local rebindButton = Instance.new("TextButton")
        rebindButton.Text = "Нажмите для смены клавиши"
        rebindButton.Size = UDim2.new(0.8, 0, 0, 30)
        rebindButton.Position = UDim2.new(0.1, 0, 0, 50)
        rebindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        rebindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        rebindButton.Parent = settingsFrame
        
        local waitingForInput = false
        
        rebindButton.MouseButton1Click:Connect(function()
            waitingForInput = true
            rebindButton.Text = "Нажмите любую клавишу..."
        end)
        
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if waitingForInput and not gameProcessed then
                currentKey.Text = "Current: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                rebindButton.Text = "Нажмите для смены клавиши"
                waitingForInput = false
            end
        end)
        
        return settingsFrame
    end
}

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
    
    -- Показываем новый контент
    if type(contents[currentTab]) == "function" then
        contents[currentTab]()
    else
        local label = Instance.new("TextLabel")
        label.Text = contents[currentTab] or "Содержимое не найдено"
        label.Size = UDim2.new(1, -20, 1, -20)
        label.Position = UDim2.new(0, 10, 0, 10)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1
        label.TextWrapped = true
        label.Parent = tabContent
    end
end

-- Переключение GUI по клавише
local currentKeybind = Enum.KeyCode.LeftAlt
local function toggleGUI()
    mainFrame.Visible = not mainFrame.Visible
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == currentKeybind and not gameProcessed then
        toggleGUI()
    end
end)

-- Инициализация
updateTabs()

-- Защита GUI
if protectgui then
    protectgui(gui)
end
