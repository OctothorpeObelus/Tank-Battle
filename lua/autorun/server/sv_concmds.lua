-- Creates a new team with the given name and color
net.Receive("octo_tank_battle_create_team", function (len, ply)
    if not ply:IsAdmin() or not ply:IsSuperAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You must be an administrator to use this command\n")
        return
    end

    local name = net.ReadString()
    local color = net.ReadColor(false)
    local result = tank_battle.createTeam(name, color)
    if not result then
        if #tank_battle.teams >= 32 then
            ply:PrintMessage(HUD_PRINTCONSOLE, "Could not create the team because the maximum number of teams has been reached (32)\n")
        else
            ply:PrintMessage(HUD_PRINTCONSOLE, "A team with that name already exists! Use tb_set_team_color if you're trying to change the color.\n")
        end
        return
    else
        ply:PrintMessage(HUD_PRINTCONSOLE, "Team \"" .. name .. "\" created with color " .. tostring(color))
    end
    tank_battle.updateTeamsCl(len, ply)
end)

-- Removes a team with the given name
net.Receive("octo_tank_battle_remove_team", function (len, ply)
    if not ply:IsAdmin() or not ply:IsSuperAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You must be an administrator to use this command\n")
        return
    end

    local name = net.ReadString()
    local result = tank_battle.removeTeam(name)
    if not result then
        ply:PrintMessage(HUD_PRINTCONSOLE, "No team with the name \"" .. name .. "\" exists\n")
        return
    end

    tank_battle.updateTeamsCl(len, ply)
end)

-- Adds a player to a team
net.Receive("octo_tank_battle_join_team", function (len, ply)
    local nameLower = net.ReadString()

    local result = tank_battle.addPlayerToTeam(ply, nameLower)
    tank_battle.addScore(ply, 0)
    tank_battle.updateTeamsCl(len, ply)
end)

-- Removes a player to a team
net.Receive("octo_tank_battle_leave_team", function (len, ply)
    local nameLower = net.ReadString()

    local result = tank_battle.removePlayerFromTeam(ply, nameLower)
    tank_battle.addScore(ply, 0)
    tank_battle.updateTeamsCl(len, ply)
end)

-- Sets the color of the team of the given name
net.Receive("octo_tank_battle_set_team_color", function (len, ply)
    if not ply:IsAdmin() or not ply:IsSuperAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You must be an administrator to use this command\n")
        return
    end

    local name = net.ReadString()
    local color = net.ReadColor(false)
    if not tank_battle.teamExists(name) then
        ply:PrintMessage(HUD_PRINTCONSOLE, "No team with name \"" .. name .. "\" exists\n")
        return
    end

    for k,v in pairs(tank_battle.teams) do
        if v.name == name then
            v.color = color
        end
    end
    ply:PrintMessage(HUD_PRINTCONSOLE, "Team \"" .. name .. "\" color set to " .. tostring(color) .. "\n")
    tank_battle.updateTeamsCl(len, ply)
end)

-- Sends a list of teams to the client
net.Receive("octo_tank_battle_list_teams", function (len, ply)
    net.Start("octo_tank_battle_list_teams_cl")
        net.WriteInt(#(tank_battle.teams), 5) --No more than 32 teams should be made
        for k,v in pairs(tank_battle.teams) do
            net.WriteString(v.name)
        end
    net.Send(ply)
end)

-- Sends a list of teams to the client
net.Receive("octo_tank_battle_fetch_teams_list", updateTeamsCl)