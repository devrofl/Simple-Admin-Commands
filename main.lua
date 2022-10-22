--[[
    rofl#1356
]]--


--// VARIABLES

local rofl = {cmds = {}}
local pref = "."
local ver = "v0.1b"


--// FUNCTION

function notif(text, time)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Admin",
        Text = text,
        Icon = "rbxassetid://10726145354",
        Duration = time or 2
    })
end

function parseMessage(msg) 
    local args = {}
    msg = string.lower(msg)
    local prefMatch = string.match(msg, "^"..pref)
    if prefMatch then
        msg = string.gsub(msg, prefMatch, "", 1)
        for arg in string.gmatch(msg, "[^%s]+") do
            table.insert(args, arg)
        end
    end
    return args
end


function plrSearch(arg)
    local plr
    for i, v in pairs(game.Players:GetPlayers()) do
        if string.lower(string.sub(v.Name, 1, string.len(arg))) == string.lower(arg) then
            plr = v
        elseif arg == "me" then
            plr = game.Players.LocaPlayer
        end
    end
    if plr then
        return plr
    else
        notif("Player couldn't be found!")
    end
end

function rofl:addCmd(name, desc, aa)
    local info = {name}
    if aa == nil then
        aa = desc
        desc = nil
        table.insert(info, aa)
    else
        table.insert(info, desc)
        table.insert(info, aa)
    end
    table.insert(rofl.cmds, info)
end

--// CMD CHECKER

game.Players.LocalPlayer.Chatted:Connect(function(msg)
    local isCmd = false
    msg:lower()
    if msg:sub(1, 3) == "/e " then
        msg = msg:sub(4)
    end
    local args = parseMessage(msg)
    for i, cmd in pairs(rofl.cmds) do
        if args[1] == cmd[1] then
            isCmd = true
            table.remove(args, 1)
            if type(cmd[3]) == "function" then
                cmd[3](args)
            else
                cmd[2](args)
            end
        end
    end
    if not isCmd then
        notif(args[1].." is not a command!")
    end
end)

--// CMDS

rofl:addCmd("print", "Testing Use.", function(args)
    local msg = table.concat(args," ")
	print(msg)
end)


--// PRINT

for i, v in pairs(rofl.cmds) do
    if type(v[2]) == "string" then
        print(pref..v[1].." - "..v[2])
    else
        print(pref..v[1])
    end

end

notif("Press F9 to see commands.", 4)
