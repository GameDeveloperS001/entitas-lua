local util       = require("util")
local Components = require('Components')
local Matcher = require('entitas').Matcher
local class      = util.class

local CleanupDebugMessageSystem = class("CleanupDebugMessageSystem")

function CleanupDebugMessageSystem:ctor(context)
    self.context = context
    self._debugMessages = context:get_group(Matcher({Components.DebugMessage}))
end

function CleanupDebugMessageSystem:cleanup()
    local entitas = self._debugMessages.entities
    entitas:foreach(function ( e )
        self.context:destroy_entity(e)
    end)
end

return CleanupDebugMessageSystem