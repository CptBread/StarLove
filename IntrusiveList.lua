require("Class")

Class:newClass("IntrusiveList")
iList = IntrusiveList -- short name

---------------------
-- NOTE: NEVER USE THE NODE TABLE IN THESE FUNCTIONS, ALWAYS USE THE ACTUAL ITEM 
--	(todo: add so you can check if tabel is node?)
--	(todo: add so you know what list you are part of?)

function IntrusiveList:init(varName)
	self.name = varName
	self.size = 0
	self.beyond = {isEnd = true} -- beyond last
	self.first = self.beyond
end

-- insert before pos, if pos is nil then insert at the end
function IntrusiveList:insert(item, next)
	local node = self:_makeNode(item)
	
	if self.first.isEnd then
		self.first = node
		self.beyond.prev = node
		node.next = self.beyond
	else
		next = next and self:_node(next) or self.beyond
		
		node.next = next
		node.prev = next.prev

		if next.prev then
			next.prev.next = node
		else
			self.first = node
		end
		next.prev = node
	end

	self.size = self.size + 1
end

function IntrusiveList:back()
	return self.beyond.prev and self.beyond.prev.item
end

function IntrusiveList:front()
	return self.first.item
end

function IntrusiveList:pushFront(item)
	return self:insert(item, self.first.item)
end

function IntrusiveList:pushBack(item)
	return self:insert(item)
end

function IntrusiveList:remove(item)
	self:removeNode(self:_node(item), item)
end

function IntrusiveList:removeNode(node, item)
	item = item or node.item
	node.next.prev = node.prev

	if node.prev then
		node.prev.next = node.next
	else
		self.first = node.next
	end
	self.size = self.size - 1

	item[self.name] = nil
	return item
end

function IntrusiveList:popFront()
	if self.first then
		return self:remove(self.first.item)
	end
end

function IntrusiveList:popBack()
	if self.beyond.prev then
		return self:remove(self.beyond.prev.item)
	end
end

function IntrusiveList:tostring(toString)
	toString = toString or tostring
	local str = "{"
	local s = ""
	for _, child in self:iter() do
		str = str..s..toString(child)
		s = ", "
	end 
	return str.."}"
end

----------------------------
-- Iter

function IntrusiveList:iter()
	local function iterate(_, node)
		node = node.next

		if node.isEnd then
			return nil, nil
		end

		return node, node.item
	end
	return iterate, nil, {next = self.first}
end

function IntrusiveList:riter()
	local function iterate(_, node)
		node = node.prev

		return node, node and node.item
	end
	return iterate, nil, self.beyond
end

----------------------------
-- Node access/creation

function IntrusiveList:_makeNode(item)
	assert(not item[self.name], "ERROR! IntrusiveList: Trying to add an item that is already part of a list of the same list or one with the same name, '"..self.name.."'")
	local node = {item = item, remove = function() self:remove(item) end}
	item[self.name] = node
	return node
end

function IntrusiveList:_node(item)
	return item[self.name]
end

-- Gets or creates node, safe node access
function IntrusiveList:_snode(item)
	local node = self:_node(item)
	if not node then
		return self:_makeNode(item)
	end
	return node
end

local function testing(test, got, expected)
	if not expected then
		expected = got
		got = test
		test = ""
	end

	if got == expected then
		return
	end
	print("TEST FAILED! " .. test .. " Expected: '" .. expected .. "' got '" .. got .. "'")
end

do
	local str = function(t) return tostring(t and t.v or "nil") end
	local function testFrontBack(list, front, back)
		testing("frontTest", str(list:front()), tostring(front))
		testing("backTest", str(list:back()), tostring(back))
	end
	local function listTest(list, expected)
		testing("listTest", list:tostring(str), expected)
	end

	local t0 = {v = 0}
	local t1 = {v = 1}
	local t2 = {v = 2}
	local t3 = {v = 3}

	local list = iList("test")

	testFrontBack(list, "nil", "nil")
	testing(list.size, 0)

	list:insert(t0)
	listTest(list, "{0}")
	testing(list.size, 1)

	list:insert(t1)
	listTest(list, "{0, 1}")
	testFrontBack(list, 0, 1)

	list:insert(t2)
	listTest(list, "{0, 1, 2}")
	testFrontBack(list, 0, 2)

	list:remove(t2)
	listTest(list, "{0, 1}")
	testFrontBack(list, 0, 1)

	list:insert(t2, t0)
	listTest(list, "{2, 0, 1}")

	list:remove(t0)
	listTest(list, "{2, 1}")

	list:insert(t0, t1)
	listTest(list, "{2, 0, 1}")

	list:pushBack(t3)
	listTest(list, "{2, 0, 1, 3}")

	list:popBack()
	listTest(list, "{2, 0, 1}")

	list:pushFront(t3)
	listTest(list, "{3, 2, 0, 1}")
	testFrontBack(list, 3, 1)

	list:popFront()
	listTest(list, "{2, 0, 1}")

	local function rStr(self, toString)
		toString = toString or tostring
		local str = "{"
		local s = ""
		for _, child in self:riter() do
			str = str..s..toString(child)
			s = ", "
		end 
		return str.."}"
	end
	testing("reverse", rStr(list, str), "{1, 0, 2}")
end

-----------------------------------------------
-- Node

-- Class:newClass("IntrusiveNode")

-- function IntrusiveNode:init(item, list)
-- 	self.item = item
-- 	self.list = list
-- end

-- function IntrusiveNode.__index