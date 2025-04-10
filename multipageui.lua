local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")

-- Attendre que le PlayerGui soit chargé
if not player:WaitForChild("PlayerGui", 10) then
    warn("PlayerGui non chargé, abandon.")
    return
end

-- Créer un ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.Name = "MultiPageUI"
screenGui.Enabled = false -- Désactivé par défaut (fermé)

-- Créer le Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(1, -310, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.5 -- Fond semi-transparent
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Ajouter un coin arrondi
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Menu Utilitaire"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.BackgroundTransparency = 0.5 -- Semi-transparent
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = frame

-- Frame pour les onglets
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabFrame.BackgroundTransparency = 0.5 -- Semi-transparent
tabFrame.BorderSizePixel = 0
tabFrame.Parent = frame

-- Bouton onglet "Téléportation"
local teleportTabButton = Instance.new("TextButton")
teleportTabButton.Size = UDim2.new(0.5, 0, 1, 0)
teleportTabButton.Position = UDim2.new(0, 0, 0, 0)
teleportTabButton.Text = "Téléportation"
teleportTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportTabButton.BackgroundTransparency = 0.5 -- Semi-transparent
teleportTabButton.TextScaled = true
teleportTabButton.Parent = tabFrame

-- Bouton onglet "Modifications"
local modifyTabButton = Instance.new("TextButton")
modifyTabButton.Size = UDim2.new(0.5, 0, 1, 0)
modifyTabButton.Position = UDim2.new(0.5, 0, 0, 0)
modifyTabButton.Text = "Modifications"
modifyTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
modifyTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
modifyTabButton.BackgroundTransparency = 0.5 -- Semi-transparent
modifyTabButton.TextScaled = true
modifyTabButton.Parent = tabFrame

-- Page Téléportation
local teleportPage = Instance.new("Frame")
teleportPage.Size = UDim2.new(1, 0, 1, -80)
teleportPage.Position = UDim2.new(0, 0, 0, 80)
teleportPage.BackgroundTransparency = 1
teleportPage.Parent = frame

-- ScrollingFrame pour la liste des joueurs dans la page Téléportation
local teleportScrollFrame = Instance.new("ScrollingFrame")
teleportScrollFrame.Size = UDim2.new(1, 0, 1, 0)
teleportScrollFrame.Position = UDim2.new(0, 0, 0, 0)
teleportScrollFrame.BackgroundTransparency = 1
teleportScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
teleportScrollFrame.ScrollBarThickness = 5
teleportScrollFrame.Parent = teleportPage

-- Page Modifications
local modifyPage = Instance.new("Frame")
modifyPage.Size = UDim2.new(1, 0, 1, -80)
modifyPage.Position = UDim2.new(0, 0, 0, 80)
modifyPage.BackgroundTransparency = 1
modifyPage.Visible = false
modifyPage.Parent = frame

-- Fonction pour basculer entre les pages
local function showPage(pageToShow, tabButtonToHighlight)
    teleportPage.Visible = (pageToShow == teleportPage)
    modifyPage.Visible = (pageToShow == modifyPage)
    teleportTabButton.BackgroundColor3 = (tabButtonToHighlight == teleportTabButton) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
    teleportTabButton.BackgroundTransparency = 0.5
    modifyTabButton.BackgroundColor3 = (tabButtonToHighlight == modifyTabButton) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
    modifyTabButton.BackgroundTransparency = 0.5
end

-- Connecter les boutons des onglets
teleportTabButton.MouseButton1Click:Connect(function()
    showPage(teleportPage, teleportTabButton)
end)

modifyTabButton.MouseButton1Click:Connect(function()
    showPage(modifyPage, modifyTabButton)
end)

-- Fonction de téléportation
local function teleportToPlayer(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        warn("Joueur cible introuvable ou pas chargé : " .. (target and target.Name or "nil"))
        return
    end

    local myCharacter = player.Character or player.CharacterAdded:Wait()
    if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then
        warn("Ton personnage n'est pas chargé.")
        return
    end

    myCharacter.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    print("Téléporté à " .. target.Name)
end

-- Mettre à jour la liste des joueurs pour la page Téléportation
local function updateTeleportPage()
    for _, child in pairs(teleportScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local yOffset = 0
    for _, target in pairs(players:GetPlayers()) do
        if target ~= player then
            local playerFrame = Instance.new("Frame")
            playerFrame.Size = UDim2.new(1, 0, 0, 50)
            playerFrame.Position = UDim2.new(0, 0, 0, yOffset)
            playerFrame.BackgroundTransparency = 1
            playerFrame.Parent = teleportScrollFrame

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -20, 0, 30)
            nameLabel.Position = UDim2.new(0, 10, 0, 5)
            nameLabel.Text = target.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            nameLabel.BackgroundTransparency = 0.5 -- Semi-transparent
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextScaled = true
            nameLabel.Parent = playerFrame

            local nameCorner = Instance.new("UICorner")
            nameCorner.CornerRadius = UDim.new(0, 5)
            nameCorner.Parent = nameLabel

            local teleportButton = Instance.new("TextButton")
            teleportButton.Size = UDim2.new(0, 100, 0, 25)
            teleportButton.Position = UDim2.new(0, 10, 0, 40)
            teleportButton.Text = "Téléportation"
            teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            teleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            teleportButton.BackgroundTransparency = 0.5 -- Semi-transparent
            teleportButton.TextScaled = true
            teleportButton.Parent = playerFrame

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 5)
            buttonCorner.Parent = teleportButton

            teleportButton.MouseEnter:Connect(function()
                teleportButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end)
            teleportButton.MouseLeave:Connect(function()
                teleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)

            teleportButton.MouseButton1Click:Connect(function()
                teleportToPlayer(target)
            end)

            yOffset = yOffset + 60
        end
    end
    teleportScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Initialiser la page Téléportation
updateTeleportPage()
players.PlayerAdded:Connect(updateTeleportPage)
players.PlayerRemoving:Connect(updateTeleportPage)

-- Éléments de la page Modifications
local function createModifyPage()
    -- Label et champ pour la vitesse
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, -20, 0, 30)
    speedLabel.Position = UDim2.new(0, 10, 0, 10)
    speedLabel.Text = "Vitesse (WalkSpeed)"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextScaled = true
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = modifyPage

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 50, 0, 25)
    speedBox.Position = UDim2.new(0, 10, 0, 40)
    speedBox.Text = "16" -- Vitesse par défaut
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedBox.BackgroundTransparency = 0.5 -- Semi-transparent
    speedBox.TextScaled = true
    speedBox.Parent = modifyPage

    local speedBoxCorner = Instance.new("UICorner")
    speedBoxCorner.CornerRadius = UDim.new(0, 5)
    speedBoxCorner.Parent = speedBox

    local speedButton = Instance.new("TextButton")
    speedButton.Size = UDim2.new(0, 80, 0, 25)
    speedButton.Position = UDim2.new(0, 70, 0, 40)
    speedButton.Text = "Appliquer"
    speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedBox.BackgroundTransparency = 0.5 -- Semi-transparent
    speedButton.TextScaled = true
    speedButton.Parent = modifyPage

    local speedButtonCorner = Instance.new("UICorner")
    speedButtonCorner.CornerRadius = UDim.new(0, 5)
    speedButtonCorner.Parent = speedButton

    speedButton.MouseEnter:Connect(function()
        speedButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    speedButton.MouseLeave:Connect(function()
        speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    speedButton.MouseButton1Click:Connect(function()
        local newSpeed = tonumber(speedBox.Text)
        if newSpeed then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = newSpeed
                print("Vitesse changée à " .. newSpeed)
            else
                warn("Personnage non chargé.")
            end
        else
            warn("Veuillez entrer un nombre valide pour la vitesse.")
        end
    end)

    -- Label et champ pour la hauteur de saut
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(1, -20, 0, 30)
    jumpLabel.Position = UDim2.new(0, 10, 0, 70)
    jumpLabel.Text = "Hauteur de saut (JumpPower)"
    jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.TextScaled = true
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.Parent = modifyPage

    local jumpBox = Instance.new("TextBox")
    jumpBox.Size = UDim2.new(0, 50, 0, 25)
    jumpBox.Position = UDim2.new(0, 10, 0, 100)
    jumpBox.Text = "50" -- JumpPower par défaut
    jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    jumpBox.BackgroundTransparency = 0.5 -- Semi-transparent
    jumpBox.TextScaled = true
    jumpBox.Parent = modifyPage

    local jumpBoxCorner = Instance.new("UICorner")
    jumpBoxCorner.CornerRadius = UDim.new(0, 5)
    jumpBoxCorner.Parent = jumpBox

    local jumpButton = Instance.new("TextButton")
    jumpButton.Size = UDim2.new(0, 80, 0, 25)
    jumpButton.Position = UDim2.new(0, 70, 0, 100)
    jumpButton.Text = "Appliquer"
    jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    jumpButton.BackgroundTransparency = 0.5 -- Semi-transparent
    jumpButton.TextScaled = true
    jumpButton.Parent = modifyPage

    local jumpButtonCorner = Instance.new("UICorner")
    jumpButtonCorner.CornerRadius = UDim.new(0, 5)
    jumpButtonCorner.Parent = jumpButton

    jumpButton.MouseEnter:Connect(function()
        jumpButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    jumpButton.MouseLeave:Connect(function()
        jumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    jumpButton.MouseButton1Click:Connect(function()
        local newJumpPower = tonumber(jumpBox.Text)
        if newJumpPower then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                if character.Humanoid.UseJumpPower then
                    character.Humanoid.JumpPower = newJumpPower
                    print("JumpPower changé à " .. newJumpPower)
                else
                    character.Humanoid.JumpHeight = newJumpPower / 10 -- Approximation si JumpHeight est utilisé
                    print("JumpHeight changé à " .. newJumpPower / 10)
                end
            else
                warn("Personnage non chargé.")
            end
        else
            warn("Veuillez entrer un nombre valide pour la hauteur de saut.")
        end
    end)

    -- Bouton pour activer/désactiver le God Mode
    local godMode = false
    local godModeButton = Instance.new("TextButton")
    godModeButton.Size = UDim2.new(0, 150, 0, 30)
    godModeButton.Position = UDim2.new(0, 10, 0, 140)
    godModeButton.Text = "Activer God Mode"
    godModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    godModeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    godModeButton.BackgroundTransparency = 0.5 -- Semi-transparent
    godModeButton.TextScaled = true
    godModeButton.Parent = modifyPage

    local godModeButtonCorner = Instance.new("UICorner")
    godModeButtonCorner.CornerRadius = UDim.new(0, 5)
    godModeButtonCorner.Parent = godModeButton

    godModeButton.MouseEnter:Connect(function()
        godModeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    godModeButton.MouseLeave:Connect(function()
        godModeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    godModeButton.MouseButton1Click:Connect(function()
        godMode = not godMode
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            if godMode then
                character.Humanoid.MaxHealth = math.huge
                character.Humanoid.Health = math.huge
                godModeButton.Text = "Désactiver God Mode"
                godModeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
                print("God Mode activé")
            else
                character.Humanoid.MaxHealth = 100
                character.Humanoid.Health = 100
                godModeButton.Text = "Activer God Mode"
                godModeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                print("God Mode désactivé")
            end
        else
            warn("Personnage non chargé.")
        end
    end)
end

-- Initialiser la page Modifications
createModifyPage()

-- Rendre l'UI draggable
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Gérer l'ouverture/fermeture avec Ctrl + K
local isCtrlPressed = false

userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Ignorer si l'input est utilisé par le jeu (ex : chat)

    -- Détecter si Ctrl est pressé
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        isCtrlPressed = true
    end

    -- Détecter Ctrl + K
    if isCtrlPressed and input.KeyCode == Enum.KeyCode.K then
        screenGui.Enabled = not screenGui.Enabled
        if screenGui.Enabled then
            print("UI ouverte")
        else
            print("UI fermée")
        end
    end
end)

userInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    -- Détecter si Ctrl est relâché
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        isCtrlPressed = false
    end
end)
