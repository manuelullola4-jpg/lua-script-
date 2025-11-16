-- #########################################################
-- SISTEMA SERVIDOR COMPLETO
-- hecho por: manuel1320652
-- #########################################################

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ====== CREAR REMOTE EVENTS ======
local GiveMoney = Instance.new("RemoteEvent", ReplicatedStorage)
GiveMoney.Name = "GiveMoneyEvent"

local TeleportEvent = Instance.new("RemoteEvent", ReplicatedStorage)
TeleportEvent.Name = "TeleportEvent"

local BankMissionEvent = Instance.new("RemoteEvent", ReplicatedStorage)
BankMissionEvent.Name = "BankMissionEvent"

-----------------------------------------------------
-- 1) LEADERSTATS
-----------------------------------------------------
game.Players.PlayerAdded:Connect(function(player)
    local stats = Instance.new("Folder", player)
    stats.Name = "leaderstats"

    local money = Instance.new("IntValue", stats)
    money.Name = "Money"
    money.Value = 0

    local hasMoney = Instance.new("BoolValue", player)
    hasMoney.Name = "HasBankMoney"
end)

-----------------------------------------------------
-- 2) DAR DINERO (pedido por cliente)
-----------------------------------------------------
GiveMoney.OnServerEvent:Connect(function(player, amount)
    if typeof(amount) == "number" then
        player.leaderstats.Money.Value += amount
    end
end)

-----------------------------------------------------
-- 3) TELEPORT (pedido por cliente)
-----------------------------------------------------
TeleportEvent.OnServerEvent:Connect(function(player, pos)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end)

-----------------------------------------------------
-- 4) SISTEMA DE MISIÓN DEL BANCO
-----------------------------------------------------
-- A) Bóveda → da bandera true
BankMissionEvent.OnServerEvent:Connect(function(player, action)
    if action == "TakeBankMoney" then
        player.HasBankMoney.Value = true
    elseif action == "ClearBankMoney" then
        player.HasBankMoney.Value = false
    elseif action == "Reward" then
        if player.HasBankMoney.Value == true then
            player.leaderstats.Money.Value += 500
            player.HasBankMoney.Value = false
        end
    end
end)

print("SERVER SYSTEM LOADED (manuel1320652)")
