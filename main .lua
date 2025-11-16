-- ###############################################
-- SISTEMA COMPLETO CREADO POR: manuel1320652
-- ###############################################

---------------------------
-- 1) LEADERSTATS
---------------------------
game.Players.PlayerAdded:Connect(function(player)
    local stats = Instance.new("Folder", player)
    stats.Name = "leaderstats"

    local money = Instance.new("IntValue", stats)
    money.Name = "Money"
    money.Value = 0

    -- indicador para misión del banco
    local hasMoney = Instance.new("BoolValue", player)
    hasMoney.Name = "HasBankMoney"
    hasMoney.Value = false
end)

---------------------------
-- 2) TELEPORT A LA BASE
---------------------------
task.defer(function()
    local teleporter = workspace:WaitForChild("BaseTeleporter")
    local basePosition = Vector3.new(0, 5, 0) -- CAMBIA ESTO

    teleporter.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player then
            local hrp = hit.Parent:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(basePosition)
            end
        end
    end)
end)

---------------------------
-- 3) SISTEMA DE ROBO LEGAL
---------------------------
task.defer(function()
    local obj = workspace:WaitForChild("MoneyObject")
    local cooldown = 10
    local reward = 100

    obj.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player and obj.Transparency == 0 then
            player.leaderstats.Money.Value += reward

            obj.Transparency = 1
            obj.CanTouch = false

            task.wait(cooldown)

            obj.Transparency = 0
            obj.CanTouch = true
        end
    end)
end)

---------------------------
-- 4) AUTO-FARM LEGAL
---------------------------
task.defer(function()
    local area = workspace:WaitForChild("AutoFarmArea")
    local reward = 5
    local interval = 2

    area.Touched:Connect(function(hit)
        local char = hit.Parent
        local player = game.Players:GetPlayerFromCharacter(char)

        if player then
            local humanoid = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if humanoid and hrp then
                while humanoid.Health > 0 and hrp:IsDescendantOf(workspace) do
                    player.leaderstats.Money.Value += reward
                    task.wait(interval)
                end
            end
        end
    end)
end)

---------------------------
-- 5) MISIÓN COMPLETA DEL BANCO
---------------------------

-- A) Entrada del banco
task.defer(function()
    local door = workspace:WaitForChild("BankDoor")

    door.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player then
            player.HasBankMoney.Value = false
        end
    end)
end)

-- B) Bóveda del banco
task.defer(function()
    local vault = workspace:WaitForChild("BankVault")

    vault.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player and not player.HasBankMoney.Value then
            player.HasBankMoney.Value = true
        end
    end)
end)

-- C) Zona de escape
task.defer(function()
    local zone = workspace:WaitForChild("EscapeZone")
    local reward = 500

    zone.Touched:Connect(function(hit)
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)

        if player and player.HasBankMoney.Value then
            player.leaderstats.Money.Value += reward
            player.HasBankMoney.Value = false
        end
    end)
end)

-----------------------------------------------------
-- SISTEMA COMPLETO OPERATIVO
-- hecho para: manuel1320652
-----------------------------------------------------
