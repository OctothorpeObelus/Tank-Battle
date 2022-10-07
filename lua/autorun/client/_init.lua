AddCSLuaFile()

tank_battle = tank_battle or {
    teams = {}
}

-- Checks if a team with the provided name exists
tank_battle.teamExists = function(name)
    for k,v in pairs(tank_battle.teams) do
        if name == v.name then
            return true
        end
    end
    return false
end

-- Read team data from server and load it into the client
net.Receive("octo_tank_battle_fetch_teams_list_cl", function(ply, len)
    tank_battle.teams = {}
    local amt = net.ReadInt(5)
    for i = 1, amt do
        local tbl = {}
        local name = net.ReadString()
        local color = net.ReadColor(false)
        tbl.name = name
        tbl.color = color
        table.insert(tank_battle.teams, tbl)
    end
end)

-- Fetch updated team info upon spawning in for the first time
hook.Add("PlayerInitialSpawn", "octo_tank_battle_PlayerInitialSpawn", function(ply, trans)
    net.Start("octo_tank_battle_fetch_teams_list")
    net.SendToServer()
end)