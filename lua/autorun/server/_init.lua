tank_battle = tank_battle or {
    teams = {},
    playerdata = {},
}

-- Checks if a team with the provided name exists
tank_battle.teamExists = function(name)
    for k,v in pairs(tank_battle.teams) do
        if string.lower(name) == string.lower(v.name) then
            return true
        end
    end
    return false
end

-- Creates a new team. Returns false if a team with the desired name already exists
tank_battle.createTeam = function(name, color)
    if #tank_battle.teams >= 32 or tank_battle.teamExists(name) then return false end

    color = color or Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
    color[4] = 255 --No transparent teams for you.

    local newteam = {
        name = name,
        color = color,
        score = 0,
    }

    table.insert(tank_battle.teams, newteam)
    return true
end

-- Removes a team from the game
tank_battle.removeTeam = function(name)
    for k,v in pairs(tank_battle.teams) do
        if v.name == name then
            -- Reset all team values for players who were on the team
            for k,ply in pairs(player.GetAll()) do
                if ply.tank_battle_team ~= nil and ply.tank_battle_team.name == name then
                    tank_battle.removePlayerFromTeam(ply, name)
                end
            end
            table.remove(tank_battle.teams, k)
            return true
        end
    end
    return false 
end

-- Adds a player to a team
tank_battle.addPlayerToTeam = function(ply, name)
    for k,v in pairs(tank_battle.teams) do
        if string.lower(v.name) == string.lower(name) then
            ply.tank_battle_team = {name = v.name, color = v.color}

            net.Start("octo_tank_battle_update_team_cl")
                net.WriteString(v.name)
                net.WriteColor(v.color, false)
            net.Send(ply)
        end
    end
end

-- Removes a player from a team
tank_battle.removePlayerFromTeam = function(ply, name)
    for k,v in pairs(tank_battle.teams) do
        if string.lower(v.name) == string.lower(name) then
            ply.tank_battle_team = nil

            net.Start("octo_tank_battle_update_team_cl")
                net.WriteString("")
                net.WriteColor(v.color, false)
            net.Send(ply)
        end
    end
end