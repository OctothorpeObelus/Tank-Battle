AddCSLuaFile()

-- Returns the names of all teams whose names include stringargs' value as a table (for console command autocompletion)
local function getTeamNamesAutocomplete(cmd, stringargs)
    stringargs = string.Trim(stringargs)
    stringargs = string.lower(stringargs)

    local tbl = {}
    
    for k,v in pairs(tank_battle.teams) do
        if string.find(string.lower(v.name), stringargs) then
            table.insert(tbl, cmd .. " \"" .. v.name .. "\"")
        end
    end

    return tbl
end

concommand.Add("tb_create_team", function(ply, cmd, args, argStr)
    if not ply:IsAdmin() or not ply:IsSuperAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You must be an administrator to use this command\n")
        return
    end

    -- Dumbass
    if args[1] == nil then ply:PrintMessage(HUD_PRINTCONSOLE, "No team name provided\n") return end

    -- Set team color if one was provided
    local color = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
    for i = 2, 4 do
        if args[i] ~= nil and tonumber(args[i]) ~= nil then
            color[i-1] = tonumber(args[i])
        end
    end

    net.Start("octo_tank_battle_create_team")
        net.WriteString(args[1])
        net.WriteColor(color, false)
    net.SendToServer()
end, nil, "Creates a team with the given name (use quotation marks) and color (defaults to a random color)")

concommand.Add("tb_remove_team", function(ply, cmd, args, argStr)
    if not ply:IsAdmin() or not ply:IsSuperAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You must be an administrator to use this command\n")
        return
    end
    
    -- Dumbass
    if args[1] == nil then ply:PrintMessage(HUD_PRINTCONSOLE, "No team name provided\n") return end

    net.Start("octo_tank_battle_remove_team")
    net.WriteString(args[1])
    net.SendToServer()
end, getTeamNamesAutocomplete, "Removes the team with the given name, if it exists.")

concommand.Add("tb_join_team", function(ply, cmd, args, argStr)
    -- Dumbass
    if args[1] == nil then ply:PrintMessage(HUD_PRINTCONSOLE, "No team name provided\n") return end

    if ply.tank_battle == nil then ply.tank_battle = {} end
    if LocalPlayer().tank_battle.team ~= nil and string.lower(args[1]) == string.lower(LocalPlayer().tank_battle.team.name) then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You are already on this team\n")
        return
    end

    net.Start("octo_tank_battle_join_team")
        net.WriteString(args[1])
    net.SendToServer()
end, getTeamNamesAutocomplete, "Adds the player to the team with the given name, if it exists.")

concommand.Add("tb_leave_team", function(ply, cmd, args, argStr)
    -- Dumbass
    if args[1] == nil then ply:PrintMessage(HUD_PRINTCONSOLE, "No team name provided\n") return end

    if ply.tank_battle == nil then ply.tank_battle = {} end
    if LocalPlayer().tank_battle.team == nil or string.lower(args[1]) ~= string.lower(LocalPlayer().tank_battle.team.name) then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You are not on this team\n")
        return
    end

    net.Start("octo_tank_battle_leave_team")
        net.WriteString(args[1])
    net.SendToServer()
end, getTeamNamesAutocomplete, "Removes the player from the team with the given name, if it exists.")

concommand.Add("tb_set_team_color", function(ply, cmd, args, argStr)
    if not ply:IsAdmin() or not ply:IsSuperAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You must be an administrator to use this command\n")
        return
    end
    
    -- Dumbass
    if args[1] == nil then ply:PrintMessage(HUD_PRINTCONSOLE, "No team name provided") return end

    if args[2] == nil or args[3] == nil or args[4] == nil then
        ply:PrintMessage(HUD_PRINTCONSOLE, "No color or invalid color provided. Please input r, g, and b as separate integers.\n")
        return
    end

    for i = 2, 4 do
        args[i] = math.Clamp(args[i], 0, 255)
    end

    net.Start("octo_tank_battle_set_team_color")
        net.WriteString(args[1])
        net.WriteColor(Color(args[2], args[3], args[4]), false)
    net.SendToServer()
end, getTeamNamesAutocomplete, "Sets the color of the team with the given name, if it exists.")

concommand.Add("tb_list_teams", function(ply, cmd, args, argStr)
    net.Start("octo_tank_battle_list_teams")
    net.SendToServer()
end, nil, "Prints a list of all teams.")

net.Receive("octo_tank_battle_list_teams_cl", function(len, ply)
    local amt = net.ReadInt(5)
    for i = 1, amt do
        LocalPlayer():PrintMessage(HUD_PRINTCONSOLE, "\"" .. net.ReadString() .. "\"\n")
    end
end)

net.Receive("octo_tank_battle_update_team_cl", function(len, ply)
    local name = net.ReadString()
    local color = net.ReadColor()
    
    if name == "" then
        LocalPlayer():PrintMessage(HUD_PRINTCONSOLE, "Left team \"" .. LocalPlayer().tank_battle.team.name .. "\"\n")
        LocalPlayer().tank_battle.team = nil
    else
        LocalPlayer():PrintMessage(HUD_PRINTCONSOLE, "Joined team \"" .. name .. "\"\n")
        LocalPlayer().tank_battle.team = {name = name, color = color}
    end
end)