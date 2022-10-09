AddCSLuaFile()

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

--Update player score in playerdata
net.Receive("octo_tank_battle_update_players", function(len, ply)
    local ply = net.ReadEntity()
    PrintTable(ply.tank_battle)
end)

-- Fetch updated team info upon spawning in for the first time
hook.Add("PlayerInitialSpawn", "octo_tank_battle_PlayerInitialSpawn", function(ply, trans)
    net.Start("octo_tank_battle_fetch_teams_list")
    net.SendToServer()
    ply.tank_battle = {
        team = nil,
        score = 0,
    }
end)