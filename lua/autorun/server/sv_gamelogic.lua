hook.Add("PlayerInitialSpawn", "octo_tank_battle_PlayerInitialSpawnSV", function(ply, trans)
    ply.tank_battle = {
        team = nil,
        score = 0,
        lives = 0,
    }
end)

hook.Add("PlayerDeath", "octo_tank_battle_PlayerDeath", function(victim, inflictor, attacker)
    print(victim.tank_battle.lives, attacker.tank_battle.lives)
    if victim.tank_battle == nil or victim.tank_battle.team == nil or victim.tank_battle.lives == nil or victim.tank_battle.lives <= 0 or attacker.tank_battle == nil or attacker.tank_battle.team == nil or attacker.tank_battle.lives == nil or attacker.tank_battle.lives <= 0 then return end

    local plyTeam = tank_battle.getTeam(attacker)

    --TODO: Send Kill notification to attacker's UI.
    if victim.tank_battle.team.name == attacker.tank_battle.team.name then --Teamkill
        local penalty = GetConVar("tb_teamkill_penalty"):GetInt()
        tank_battle.addScore(attacker, -penalty)
        tank_battle.print(attacker:GetName() .. " just teamkilled " .. victim:GetName() .. " and lost " .. tostring(penalty) .. " points! (" .. plyTeam.name .. ": " .. tostring(plyTeam.score) .. " Points)")
    else --Normal Kill
        local award = GetConVar("tb_kill_points"):GetInt()
        tank_battle.addScore(attacker, award)
        victim.tank_battle.lives = victim.tank_battle.lives - 1
        tank_battle.print(attacker:GetName() .. " just killed " .. victim:GetName() .. " and gained " .. tostring(award) .. " points! (" .. plyTeam.name .. ": " .. tostring(plyTeam.score) .. " Points)")
    end
end)