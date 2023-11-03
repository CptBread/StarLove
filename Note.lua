require("Table");

Note = {}
Note.timedText = {}
Note.text = {}
Note.timer = {}

function Note.showFor(seconds, ...)
	local obj = {...};
	table.transform(obj, tostring);
	Note.timer[#Note.timer + 1] = {t = seconds, text = table.concat(obj, "    ")};
end

function Note.show(...)
	local obj = {...};
	table.transform(obj, tostring);
	Note.text[#Note.text + 1] = table.concat(obj, "    ");
end

function Note.update(dt)
	local toRemove = {}
	Note.timedText = {}
	for k,v in pairs(Note.timer) do
		v.t = v.t - dt;
		if v.t < 0 then
			table.insert(toRemove, k)
		end
		table.insert(Note.timedText, v.text);
	end
	
	for k,v in pairs(toRemove) do
		table.remove(Note.timer, v);
	end
end

function Note.draw()
	local middle = "";
	if #Note.timedText > 0 then
		middle = "\n";
	end
	
	love.graphics.print(table.concat(Note.timedText, "\n") .. middle .. table.concat(Note.text, "\n"), 0, 10)
	Note.text = {}
end