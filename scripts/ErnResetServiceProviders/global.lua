--[[
ErnResetServiceProviders for OpenMW.
Copyright (C) 2026 Erin Pentecost

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]
local MOD_NAME          = require("scripts.ErnResetServiceProviders.ns")
local aux_util = require('openmw_aux.util')

local function onResetLocation(data)
    print("onResetLocation: " .. aux_util.deepToString(data, 5))
    data.actor:teleport(data.actor.startingCell, data.actor.startingPosition, {rotation=data.actor.startingRotation, onGround=true})
end

return {
    eventHandlers = {
        [MOD_NAME .. "onResetLocation"] = onResetLocation,
    },
}
