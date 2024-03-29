--
-- A good set of tools allow to build custom solutions.
--

local utils = require("torchcraft.utils")

local tools = {}

local function count(t)  -- raw count of items in an map-table
    local i = 0
      for k,v in pairs(t) do i = i + 1 end
    return i
end

function tools.pass()
    -- do nothing
    return 'ok'
end

function tools.size(...)
    local args = {...}
    local arg1 = args[1]
    return (type(arg1) == 'table') and count(args[1]) or count(args)
end

--- Performs a deep comparison test between two objects. Can compare strings, functions
-- (by reference), nil, booleans. Compares tables by reference or by values. If `useMt`
-- is passed, the equality operator `==` will be used if one of the given objects has a
-- metatable implementing `__eq`.
-- <br/><em>Aliased as `compare`, `matches`</em>
-- @name isEqual
-- @param objA an object
-- @param objB another object
-- @param[opt] useMt whether or not `__eq` should be used, defaults to false.
-- @return `true` or `false`
function tools.isEqual(objA, objB, useMt)
    local typeObjA = type(objA)
    local typeObjB = type(objB)
    if typeObjA~=typeObjB then return false end
    if typeObjA~='table' then return (objA==objB) end
    local mtA = getmetatable(objA)
    local mtB = getmetatable(objB)
    if useMt then
      if (mtA or mtB) and (mtA.__eq or mtB.__eq) then
        return mtA.__eq(objA, objB) or mtB.__eq(objB, objA) or (objA==objB)
      end
    end
    if tools.size(objA)~=tools.size(objB) then return false end
    local vB
    for i,vA in pairs(objA) do
      vB = objB[i]
      if vB == nil or not tools.isEqual(vA, vB, useMt) then return false end
    end
    for i in pairs(objB) do
      if objA[i] == nil then return false end
    end
    return true
end

--- Counts occurrences of a given value in a table. Uses @{isEqual} to compare values.
-- @name count
-- @param t a table
-- @param[opt] val a value to be searched in the table. If not given, the @{size} of the table will be returned
-- @return the count of occurrences of the given value
-- @see size
function tools.count(t, val)
    if val == nil then return tools.size(t) end
    local count = 0
    for k, v in pairs(t) do
      if tools.isEqual(v, val) then count = count + 1 end
    end
    return count
end

--- Looks for the first occurrence of a given value in an array. Returns the value index if found.
-- Uses @{isEqual} to compare values.
-- @name find
-- @param array an array of values
-- @param value a value to lookup for
-- @param[opt] from the index from where the search will start. Defaults to 1.
-- @return the index of the value if found in the array, `nil` otherwise.
function tools.find(array, value, from)
    for i = from or 1, #array do
      if tools.isEqual(array[i], value) then return i end
    end
end

function tools.check_supported_maps(name)
    --
    -- Check here for supported maps only;
    -- also a good place to move/add/return;
    -- start_locations, previous map analysis, etc.
    --
    local map = {}
    if string.match(name, "Fighting Spirit") then
        map['bases'] = 4
    elseif string.match(name, "Vermeer") then
        map['bases'] = 4
    elseif string.match(name, "Polypoid") then
        map['bases'] = 4
    elseif string.match(name, "Neo Sylphid") then
        map['bases'] = 3
    elseif string.match(name, "Eclipse") then
        map['bases'] = 2
    else
        print("Crash something else")
    end
    return map
end

function tools.get_closest(position, units)
    --
    -- Wink, wink (;
    --
    local min_d = 1E30
    local closest_id = nil
    for id, u in pairs(units) do
        local tmp_d = utils.distance(position, u['position'])
        if tmp_d < min_d then
            min_d = tmp_d
            closest_id = id
        end
    end
    return closest_id
end

function tools.print_table(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

return tools
