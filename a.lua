
local Players = game:GetService("Players")
local TeleportService = game:GetService('TeleportService')
local Dir = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay")
 
local Rejoin_Time = 5
 
function Rejoin()
    if #Players:GetPlayers() <= 1 then
        Players.LocalPlayer:Kick("\nRejoining...")
        wait()
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
end
 
function DisableIdle()
    for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
        v:Disable()
    end
end
 
DisableIdle()
 
Dir.DescendantAdded:Connect(
    function(Err)
        if Err.Name == "ErrorTitle" then
            Err:GetPropertyChangedSignal("Text"):Connect(
                function()
                    if Err.Text:sub(0, 12) == "Disconnected" then
                        Rejoin()
                    end
                end
            )
        end
    end
)
 
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        syn.queue_on_teleport("")
      end
end)
 
local Start = tick()
while wait(1) do
    if (tick() - Start) >= Rejoin_Time then
        Rejoin()
    end
end
