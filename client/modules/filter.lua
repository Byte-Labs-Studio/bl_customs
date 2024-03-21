local categories = require 'data.categories'
local colors = require 'data.colors'
local colorFunctions = colors.functions

local table_deepcopy = lib.table.deepclone

local filteredCategories = {}
local namedCategories = {}
local colorTypes = {}

for paint in pairs(colorFunctions) do
    colorTypes[#colorTypes+1] = paint
end

for _, v in ipairs(categories) do
    local mod = v.id
    if v.selector and v.selector.onOpen then
        v.selector.onOpen(v)
    end
    namedCategories[mod] = v
end

for _, v in ipairs(table_deepcopy(categories)) do
    v.selector = nil
    filteredCategories[_] = v
end

return {
    filtered = filteredCategories,
    named = namedCategories,
    colorTypes = colorTypes
}