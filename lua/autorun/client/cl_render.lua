AddCSLuaFile()

--Returns whether or not the local player is in the Potential Visible Set of the given position
local function isInPVS(pos)
    return LocalPlayer():TestPVS(pos)
end

local function renderGroundRing(pos, radius, thickness)
    --TODO
end

local function renderCapturePoints()
    --TODO
end

local function renderAirDrops()
    --TODO
end

hook.Add("render", "octo_tank_battle_render_game_objectives", function()
    renderCapturePoints()

    renderAirDrops()
end)