-- MultiPageUI.lua (avec correction de la liste déroulante et Ctrl + Click TP)

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

-- Fonction de téléportation à un joueur
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

-- Fonction de téléportation à des coordonnées
local function teleportToCoordinates(x, y, z)
    local myCharacter = player.Character or player.CharacterAdded:Wait()
    if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then
        warn("Ton personnage n'est pas chargé.")
        return
    end

    myCharacter.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    print("Téléporté aux coordonnées : " .. x .. ", " .. y .. ", " .. z)
end

-- Créer la page Téléportation avec une liste déroulante, des champs de coordonnées et un bouton Ctrl + Click TP
local function createTeleportPage()
    -- Label pour la liste déroulante
    local playerLabel = Instance.new("TextLabel")
    playerLabel.Size = UDim2.new(1, -20, 0, 30)
    playerLabel.Position = UDim2.new(0, 10, 0, 10)
    playerLabel.Text = "Sélectionner un joueur :"
    playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerLabel.BackgroundTransparency = 1
    playerLabel.TextScaled = true
    playerLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerLabel.Parent = teleportPage

    -- Frame pour la liste déroulante
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
    dropdownFrame.Position = UDim2.new(0, 10, 0, 40)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdownFrame.BackgroundTransparency = 0.5
    dropdownFrame.Parent = teleportPage

    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 5)
    dropdownCorner.Parent = dropdownFrame

    -- Bouton pour afficher/masquer la liste déroulante
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Text = "Choisir un joueur"
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.TextScaled = true
    dropdownButton.Parent = dropdownFrame

    -- ScrollingFrame pour la liste déroulante
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(1, 0, 0, 100)
    dropdownList.Position = UDim2.new(0, 0, 0, 30)
    dropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdownList.BackgroundTransparency = 0.5
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropdownList.ScrollBarThickness = 5
    dropdownList.Visible = false
    dropdownList.Parent = dropdownFrame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 5)
    listCorner.Parent = dropdownList

    -- Bouton pour se téléporter au joueur sélectionné
    local teleportToPlayerButton = Instance.new("TextButton")
    teleportToPlayerButton.Size = UDim2.new(0, 100, 0, 25)
    teleportToPlayerButton.Position = UDim2.new(0, 10, 0, 80)
    teleportToPlayerButton.Text = "Téléportation"
    teleportToPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportToPlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    teleportToPlayerButton.BackgroundTransparency = 0.5
    teleportToPlayerButton.TextScaled = true
    teleportToPlayerButton.Parent = teleportPage

    local teleportButtonCorner = Instance.new("UICorner")
    teleportButtonCorner.CornerRadius = UDim.new(0, 5)
    teleportButtonCorner.Parent = teleportToPlayerButton

    teleportToPlayerButton.MouseEnter:Connect(function()
        teleportToPlayerButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    teleportToPlayerButton.MouseLeave:Connect(function()
        teleportToPlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    -- Fonction pour mettre à jour la liste déroulante
    local selectedPlayer = nil
    local function updateDropdown()
        -- Nettoyer complètement la liste
        for _, child in pairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("UIListLayout") then
                child:Destroy()
            end
        end

        -- Ajouter un UIListLayout pour organiser les éléments
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = dropdownList

        -- Ajouter les joueurs à la liste
        local playerList = players:GetPlayers()
        local yOffset = 0
        for _, target in pairs(playerList) do
            if target ~= player then -- Exclure le joueur local
                local playerButton = Instance.new("TextButton")
                playerButton.Size = UDim2.new(1, 0, 0, 30)
                playerButton.Position = UDim2.new(0, 0, 0, yOffset)
                playerButton.Text = target.Name
                playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                playerButton.BackgroundTransparency = 0.5
                playerButton.TextScaled = true
                playerButton.Parent = dropdownList

                playerButton.MouseButton1Click:Connect(function()
                    selectedPlayer = target
                    dropdownButton.Text = target.Name
                    dropdownList.Visible = false
                end)

                yOffset = yOffset + 30
            end
        end
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    end

    -- Initialiser la liste déroulante
    updateDropdown()
    players.PlayerAdded:Connect(updateDropdown)
    players.PlayerRemoving:Connect(updateDropdown)

    -- Afficher/masquer la liste déroulante
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)

    -- Téléportation au joueur sélectionné
    teleportToPlayerButton.MouseButton1Click:Connect(function()
        if selectedPlayer then
            teleportToPlayer(selectedPlayer)
        else
            warn("Aucun joueur sélectionné.")
        end
    end)

    -- Label pour les coordonnées
    local coordsLabel = Instance.new("TextLabel")
    coordsLabel.Size = UDim2.new(1, -20, 0, 30)
    coordsLabel.Position = UDim2.new(0, 10, 0, 110)
    coordsLabel.Text = "Coordonnées (X, Y, Z) :"
    coordsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    coordsLabel.BackgroundTransparency = 1
    coordsLabel.TextScaled = true
    coordsLabel.TextXAlignment = Enum.TextXAlignment.Left
    coordsLabel.Parent = teleportPage

    -- Champs pour les coordonnées X, Y, Z
    local xBox = Instance.new("TextBox")
    xBox.Size = UDim2.new(0, 50, 0, 25)
    xBox.Position = UDim2.new(0, 10, 0, 140)
    xBox.Text = "0"
    xBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    xBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    xBox.BackgroundTransparency = 0.5
    xBox.TextScaled = true
    xBox.Parent = teleportPage

    local xBoxCorner = Instance.new("UICorner")
    xBoxCorner.CornerRadius = UDim.new(0, 5)
    xBoxCorner.Parent = xBox

    local yBox = Instance.new("TextBox")
    yBox.Size = UDim2.new(0, 50, 0, 25)
    yBox.Position = UDim2.new(0, 70, 0, 140)
    yBox.Text = "0"
    yBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    yBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    yBox.BackgroundTransparency = 0.5
    yBox.TextScaled = true
    yBox.Parent = teleportPage

    local yBoxCorner = Instance.new("UICorner")
    yBoxCorner.CornerRadius = UDim.new(0, 5)
    yBoxCorner.Parent = yBox

    local zBox = Instance.new("TextBox")
    zBox.Size = UDim2.new(0, 50, 0, 25)
    zBox.Position = UDim2.new(0, 130, 0, 140)
    zBox.Text = "0"
    zBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    zBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    zBox.BackgroundTransparency = 0.5
    zBox.TextScaled = true
    zBox.Parent = teleportPage

    local zBoxCorner = Instance.new("UICorner")
    zBoxCorner.CornerRadius = UDim.new(0, 5)
    zBoxCorner.Parent = zBox

    -- Bouton pour se téléporter aux coordonnées
    local teleportToCoordsButton = Instance.new("TextButton")
    teleportToCoordsButton.Size = UDim2.new(0, 100, 0, 25)
    teleportToCoordsButton.Position = UDim2.new(0, 10, 0, 170)
    teleportToCoordsButton.Text = "Téléportation"
    teleportToCoordsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportToCoordsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    teleportToCoordsButton.BackgroundTransparency = 0.5
    teleportToCoordsButton.TextScaled = true
    teleportToCoordsButton.Parent = teleportPage

    local coordsButtonCorner = Instance.new("UICorner")
    coordsButtonCorner.CornerRadius = UDim.new(0, 5)
    coordsButtonCorner.Parent = teleportToCoordsButton

    teleportToCoordsButton.MouseEnter:Connect(function()
        teleportToCoordsButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    teleportToCoordsButton.MouseLeave:Connect(function()
        teleportToCoordsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    teleportToCoordsButton.MouseButton1Click:Connect(function()
        local x = tonumber(xBox.Text)
        local y = tonumber(yBox.Text)
        local z = tonumber(zBox.Text)
        if x and y and z then
            teleportToCoordinates(x, y, z)
        else
            warn("Veuillez entrer des coordonnées valides (nombres).")
        end
    end)

    -- Bouton pour activer/désactiver le Ctrl + Click TP
    local ctrlClickTPEnabled = false
    local ctrlClickTPButton = Instance.new("TextButton")
    ctrlClickTPButton.Size = UDim2.new(0, 150, 0, 30)
    ctrlClickTPButton.Position = UDim2.new(0, 10, 0, 200)
    ctrlClickTPButton.Text = "Activer Ctrl + Click TP"
    ctrlClickTPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ctrlClickTPButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ctrlClickTPButton.BackgroundTransparency = 0.5
    ctrlClickTPButton.TextScaled = true
    ctrlClickTPButton.Parent = teleportPage

    local clickTPButtonCorner = Instance.new("UICorner")
    clickTPButtonCorner.CornerRadius = UDim.new(0, 5)
    clickTPButtonCorner.Parent = ctrlClickTPButton

    ctrlClickTPButton.MouseEnter:Connect(function()
        ctrlClickTPButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    ctrlClickTPButton.MouseLeave:Connect(function()
        ctrlClickTPButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)

    -- Gestion du Ctrl + Click TP
    local mouse = player:GetMouse()
    local isCtrlPressed = false

    -- Détecter si Ctrl est pressé
    userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            isCtrlPressed = true
        end
    end)

    userInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            isCtrlPressed = false
        end
    end)

    -- Activer/désactiver le Ctrl + Click TP
    ctrlClickTPButton.MouseButton1Click:Connect(function()
        ctrlClickTPEnabled = not ctrlClickTPEnabled
        if ctrlClickTPEnabled then
            ctrlClickTPButton.Text = "Désactiver Ctrl + Click TP"
            ctrlClickTPButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
            print("Ctrl + Click TP activé")
        else
            ctrlClickTPButton.Text = "Activer Ctrl + Click TP"
            ctrlClickTPButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            print("Ctrl + Click TP désactivé")
        end
    end)

    -- Téléportation avec Ctrl + Clic
    mouse.Button1Down:Connect(function()
        if ctrlClickTPEnabled and isCtrlPressed then
            local targetPosition = mouse.Hit.Position
            teleportToCoordinates(targetPosition.X, targetPosition.Y + 5, targetPosition.Z) -- +5 pour éviter de se téléporter dans le sol
        end
    end)
end

-- Initialiser la page Téléportation
createTeleportPage()

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

-- Gérer l'ouverture/fermeture avec la touche K uniquement
userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Ignorer si l'input est utilisé par le jeu (ex : chat)

    -- Détecter la touche K
    if input.KeyCode == Enum.KeyCode.K then
        screenGui.Enabled = not screenGui.Enabled
        if screenGui.Enabled then
            print("UI ouverte")
        else
            print("UI fermée")
        end
    end
end)
