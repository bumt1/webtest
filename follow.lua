local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- The player who can execute the commands
local commander = "speedkitbw2"

-- Check for valid command sender
local function isCommander(player)
    return player.Name == commander
end

-- Tween function to move players smoothly
local function tweenToPosition(character, targetPosition)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tweenGoal = {CFrame = CFrame.new(targetPosition)}
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenGoal)
        tween:Play()
    end
end

-- Command listener for chat messages
Players.PlayerAdded:Connect(function(player)
    -- Announce "ready" 5 times when the player joins and script is executed
    for i = 1, 5 do
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("ready", "All")
    end
    
    -- Chat listener for commands
    player.Chatted:Connect(function(message)
        if message == "!follow" and isCommander(player) then
            local commanderPlayer = Players:FindFirstChild(commander)
            if commanderPlayer and commanderPlayer.Character then
                local targetPosition = commanderPlayer.Character.HumanoidRootPart.Position
                
                -- Move all players to the commander
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer.Character and otherPlayer ~= commanderPlayer then
                        tweenToPosition(otherPlayer.Character, targetPosition)
                        otherPlayer.Character:SetPrimaryPartCFrame(commanderPlayer.Character.HumanoidRootPart.CFrame)
                    end
                end
            end
        elseif message == "!test" and isCommander(player) then
            -- Send the message in public chat
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Your private bot is ready.", "All")
        end
    end)
end)
