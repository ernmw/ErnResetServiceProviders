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
local core                  = require('openmw.core')
local types                 = require('openmw.types')
local MOD_NAME = require("scripts.ErnResetServiceProviders.ns")
local const              = require("scripts.ErnResetServiceProviders.const")
local pself    = require('openmw.self')
local settings = require("scripts.ErnResetServiceProviders.settings.settings")
local aux_util = require('openmw_aux.util')
local interfaces = require('openmw.interfaces')

local function getRecord(obj)
    return obj.type.record(obj)
end

local servicesOffered = getRecord(pself).servicesOffered

local function offersAny(keys)
    for _, key in ipairs(keys) do
        settings.debugPrint("offersAny " .. tostring(key))
        if servicesOffered[key] then
            return true
        end
    end
    return false
end

settings.debugPrint("TRAVEL: "..tostring(settings.locations.TRAVEL))

local function doReset()
    local services = {
        (settings.locations.TRAVEL and const.SERVICES.TRAVEL) or {},
        (settings.locations.TRAINING and const.SERVICES.TRAINING) or {},
        (settings.locations.SPELLS and const.SERVICES.SPELLS) or {},
        (settings.locations.ENCHANTING and const.SERVICES.ENCHANTING) or {},
        (settings.locations.REPAIR and const.SERVICES.SPELLS) or {},
        (settings.locations.MERCHANT and const.SERVICES.MERCHANT) or {},
    }
    settings.debugPrint("services " .. aux_util.deepToString(services, 5))
    for _, s in ipairs(services) do
        if offersAny(s) then
            return true
        end
    end
    return false
end

local function isFollower()
    local FollowerDetectionUtil = interfaces.FollowerDetectionUtil
    if FollowerDetectionUtil then
        return FollowerDetectionUtil.getState().leader ~= nil
    end
    return false
end

local function onActive()
    if settings.admin.disable then
        return
    end
    if settings.admin.debugMode and doReset() then
        settings.debugPrint("would reset " .. getRecord(pself).name)
    end
    if pself:isValid() and not types.Actor.isDead(pself) and doReset() and (not isFollower())then
        core.sendGlobalEvent(MOD_NAME .. "onResetLocation", {
            actor = pself,
        })
    end
end

return {
    engineHandlers = {
        onActive = onActive,
    }
}
