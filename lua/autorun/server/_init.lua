tank_battle = tank_battle or {
    teams = {},
    capture_points = {},
    airdrops = {},
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

-- Gets the team object that the given player is one
tank_battle.getTeam = function(ply)
    for k,v in pairs(tank_battle.teams) do
        if string.lower(v.name) == string.lower(ply.tank_battle.team.name) then
            return v
        end
    end
    return nil
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
                if ply.tank_battle.team ~= nil and ply.tank_battle.team.name == name then
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
            ply.tank_battle.team = {name = v.name, color = v.color}
            ply.tank_battle.lives = GetConVar("tb_player_lives"):GetInt()

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
            ply.tank_battle.team = nil
            ply.tank_battle.lives = 0

            net.Start("octo_tank_battle_update_team_cl")
                net.WriteString("")
                net.WriteColor(v.color, false)
            net.Send(ply)
        end
    end
end

-- Sends updated team tables to clients
tank_battle.updateTeamsCl = function(len, ply)
    net.Start("octo_tank_battle_fetch_teams_list_cl")
        net.WriteInt(#tank_battle.teams, 5) --No more than 32 teams should be made
        for k,v in pairs(tank_battle.teams) do
            net.WriteString(v.name)
            net.WriteColor(v.color, false)
        end
    net.Send(ply)
end

tank_battle.setScore = function(ply, amount)
    ply.tank_battle.score = amount

    --Update total team score
    local team = tank_battle.getTeam(ply)
    team.score = 0
    for k,v in pairs(player.GetAll()) do
        if v.tank_battle == nil then continue end
        if v.tank_battle.team.name == team.name then
            team.score = team.score + v.tank_battle.score
        end
    end

    --Update all clients with the new score.
    net.Start("octo_tank_battle_update_players")
        net.WriteEntity(ply)
    net.Broadcast()
end

tank_battle.addScore = function(ply, amount)
    tank_battle.setScore(ply, ply.tank_battle.score + amount)
end

tank_battle.print = function(string)
    print("[Tank Battle] " .. string)
end