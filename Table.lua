

function table.transform(t, func, ...)
	for k, v in pairs(t) do
		t[k] = func(v, ...)
	end
end

function table.sprint(t, inTabs)
	print(t)
	
	local function sprintRecursive(t, recursion, inTabs)
		if not inTabs then inTabs = "" end
		local tabs = inTabs .. "\t"
		
		if recursion[t] then
			print(tabs .. "RECURSION " .. tostring(t));
			return
		end
		recursion[t] = true;
		
		if #tabs > 6 then
			print(tabs .. "TABLE IS TOO NESTED")
			return
		end
		
		for k,v in pairs(t) do
			print(tabs .. tostring(k), v)
			if type(v) == "table" then
				sprintRecursive(v, recursion, tabs)
			end
		end
	end
	
	local recursion = {}
	if type(t) == "table" then
		sprintRecursive(t, recursion)
	end	
end

function table.print(t, inTabs)
	print(t)
	
	local function printRecursive(t, inTabs)
		if not inTabs then inTabs = "" end
		local tabs = inTabs .. "\t"
		for k,v in pairs(t) do
			print(tabs .. tostring(k), v)
			if type(v) == "table" then
				printRecursive(v, tabs)
			end
		end
	end
	
	if type(t) == "table" then
		printRecursive(t)
	end	
end

----------------------------------------------------------------
-- Array

array = array or {}
function array.findFirst(t, func)
	for i,v in ipairs(t) do
		if func(v) then
			return v
		end
	end
end

-- Returns index of removed item or nil if not found
function array.removeUnique(arr, item)
	for i,v in ipairs(arr) do
		if v == item then
			table.remove(arr, i)
			return i
		end
	end
	return nil
end

-- returns (index, exists) 
function array.addUnique(arr, item)
	for i,v in ipairs(arr) do
		if v == item then
			return i, true
		end
	end
	local idx = #arr + 1
	arr[idx] = item
	return idx, false
end

-- arg can be function or item
function array.removeAll(arr, arg)
	local func = arg
	if type(arg) ~= "function" then
		func = function(item) return arg == item end
	end
	local size = #arr
	local at = 1
    for i = 1,size do
        if func(arr[i]) then
        	arr[i] = nil
        else
        	-- if we have empty spots then move it in
        	if i > at then
        		arr[at] = arr[i]
        		arr[i] = nil
        	end
        	at = at + 1
        end
    end

    return t;
end

function array.shuffle(arr)
	for i = #arr, 2, -1 do
		local j = math.random(i)
		arr[i], arr[j] = arr[j], arr[i]
	end
	return arr
end