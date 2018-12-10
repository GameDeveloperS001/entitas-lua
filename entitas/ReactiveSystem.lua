local util = require("util")
local class = util.class
local table_insert = table.insert
local Collector = require("entitas.Collector")

local M = class("ReactiveSystem")

local function get_collector(self, context)
    local trigger = self:get_trigger()
    assert(#trigger%2==0,"")
    local groups = {}
    local matcher, group_event
    for k, v in pairs(trigger) do
        if k % 2 ~= 0 then
            matcher = v
        else
            group_event = v
            local group = context:get_group(matcher)
            groups[group] = group_event
        end
    end
    return Collector.new(groups)
end

function M:ctor(context)
    self._collector = get_collector(self, context)
    self._buffer = {}
end

function M:get_trigger()
    error("not imp")
end

function M:filter()
    error("not imp")
end

function M:react()
    error("not imp")
end

function M:activate()
    self._collector:activate()
end

function M:deactivate()
    self._collector:deactivate()
end

function M:clear()
    self._collector:clear_entities()
end

function M:execute()
    if self._collector.entities then
        self._collector.entities:foreach(function(entity)
            if self:filter(entity) then
                table_insert(self._buffer, entity)
            end
        end)

        self._collector:clear_entities()

        if #self._buffer > 0 then
            self:react(self._buffer)
            self._buffer = {}
        end
    end
end

return M
