
function safe_call( reload_func, func, ... )
    local res = { xpcall( func, debug.traceback, ... ) }
    if res[1] then
        return select(2, unpack(res))
    else
        reload_func = reload_func or function() dofile("main.lua") end
        repeat
            print( select(2, unpack(res)) )
            print( "Waiting for input for reload..." )
            res = { xpcall( reload_func, debug.traceback, io.read() ) } -- send io to reload func
        until res[1]
    end
end

-- Returns a function that will be safe to call and can do hot realoding on failure
function make_safe_func( reload_func, func )
    return function(...)
        return safe_call( reload_func, func, ... )
    end
end

---------------------------------------------------------------------
-- Functions for finding things in tables.
---------------------------------------------------------------------

local function set_found_path( data )
    local last_node
    for idx, v in ipairs( data.stack ) do
        local node = data.found_node[ v.node ]
        local created = false

        if not node or node.depth > idx then
            node = {}
            data.found_node[ v.node ] = node
        end

        node.key = v.key
        node.node = v.node
        node.prev = last_node
        node.depth = idx
        last_node = node
    end
    return last_node
end

function recursive_string_find( item, str, data, key )
    data = data or {stack = {}, found_node = {}, found_leafs = {}, done = {}}
    if type(item) == "table" then
        if not data.done[ item ] then
            data.done[ item ] = true
            table.insert( data.stack, { key = key, node = item } )

            for k, v in pairs( item ) do
                recursive_string_find( v, str, data, k )
                recursive_string_find( k, str, data, "[" .. tostring(k) .. "]" )
            end

            table.remove( data.stack )
        else
            local node = data.found_node[item]
            local my_depth = #data.stack + 1
            if node and node.depth > my_depth then
                node.prev = set_found_path( data )
                node.key = key
                node.depth = my_depth
            end
        end
    elseif string.find( tostring(item), str) then
        local last_node = set_found_path( data )
        table.insert( data.found_leafs, { key = key, leaf = item, prev = last_node } )
    end
    return data
end

function pretty_str(x,seen,raw)
    local w = 60
    if type(x) == "userdata" then
        return tostring(x)
    elseif type(x) == "table" then
        if not seen then seen = {} end
        if seen[x] then return "..." end
        seen[x] = true
        local r = "{"
        for k,v in pairs(x,raw) do
            r = r .. pretty_str(k,seen,raw) .. '=' .. pretty_str(v,seen,raw) .. ', '
            if r:len() > w then
                r = r:sub(1,w)
                r = r .. '...'
                break
            end
        end
        r = r .. '}'
        return r
    elseif type(x) == "string" then
        x = string.gsub(x, '\n', '\\n')
        x = string.gsub(x, '\r', '\\r')
        x = string.gsub(x, '\t', '\\t')
        if x:len() > w then
            x = x:sub(1,w) .. '...'
        end
        return x
    elseif type(x) == "function" then
        local info = debug.getinfo(x)
        if info.source == '=[C]' then
            return "(C++ method)"
        else
            return pretty_str(info.source,nil,raw)
        end
    else
        return tostring(x)
    end
end

----------------------------------------------
-- Searches for anything matching the given string in a table. (we do tostring on every item)
-- Use _G if you want to search everything

function find_in_table( item, str )
    if not str and item then 
        str = item
        item = _G
    end

    local res = recursive_string_find( item, str )
    local printed_tables = {}
    local allow_preview = #res.found_leafs < 80
    for k, v in pairs( res.found_leafs ) do
        local str = tostring(v.key)
        local stack = v.prev
        while stack and stack.prev do
            str = tostring(stack.key) .. '.' .. str
            stack = stack.prev
        end

        local prev_node = v.prev and v.prev.node
        if prev_node and allow_preview then
            if not printed_tables[ prev_node ] then
                print( str, v.leaf, "in: " )
                printed_tables[ prev_node ] = true

                local res = string.rep( "-", 12 )

                local count = 1
                local key, val = next( prev_node )
                local kl, vl = 20, 20

                local strs = {}
                while val and count < 25 do
                    local k = pretty_str( key )
                    local v = pretty_str( val )

                    kl = math.max( kl, k:len() + 2 )
                    vl = math.max( vl, v:len() + 2 )

                    strs[k] = v

                    key, val = next( prev_node, key )
                    count = count + 1
                end

                print( ("-"):rep(kl+vl+5) )
                for k,v in pairs( strs ) do
                    print( "| " .. k:left(kl) .. "| " .. v:left(vl) .."|" )
                end

                if key and count == 25 then
                    print( "..." )
                    print( "(preview was longer the 25 lines so we abort here)")
                else
                    print( ("-"):rep(kl+vl+5) )
                end
            else
                print( str, v.leaf, "found in the same table as a previous item" )
            end
        else
            print( str, v.leaf )
        end
    end
    local num_found = #res.found_leafs
    if num_found == 0 then
        print( "Found nothing!" )
        if not item then
            print( "Item was:", item )
        end
    else
        print( "Found " .. tostring(num_found) .. " items!" )
    end
end