--print("Hello world!")

--local source = workspace.index.Text.Value

--Credit to blokav
function removeWhiteSpace(source)
	local newText = ""
	local char, before, after
	--print(#source)
	
	for i = 1, #source do
		char = string.sub(source, i, i)
		if (char == "\\" and (string.sub(source, i - 1, i - 1) == "<" or string.sub(source, i + 1, i + 1) == "/")) then
		else
			newText = newText..char
		end	
	end
	source = newText
	newText = ""
	for i = 1, #source do
		char = string.sub(source, i, i)
		--if (char == " " or char == "\n" or char == "	") then
		if (whitespace(char)) then
			before = string.sub(source, i - 1, i - 1)
			after = string.sub(source, i + 1, i + 1)
			--if (not (before == ">" or before == " " or before == "\n" or before == "	" or after == "<" or after == " " or after == "\n" or after == "	")) then
			if (not (whitespace(before) or whitespace(after) or before == ">" or after == "<")) then
				newText = newText..char
			end
		else
			newText = newText..char
		end
	end
	return newText
end

function setUp(source1)
	local source = removeWhiteSpace(source1)
	local segments = {}
	local start = 1
	local scan = false
	local char, word, x, y
	for i = 1, #source do
		char = string.sub(source, i, i)
		if (not scan) then
			if (char == "<") then
				scan = true
				if (start ~= i) then
					word = string.sub(source, start, i - 1)
					while (string.find(word, "&nbsp", 1, true)) do
						x, y = string.find(word, "&nbsp", 1, true)
						word = string.sub(word, 1, x - 1).." "..string.sub(word, y + 1)
					end
					table.insert(segments, word)
				end
				start = i
			end
		else
			if (char == ">") then
				scan = false
				table.insert(segments, string.lower(string.sub(source, start, i)))
				start = i + 1
			end
		end
	end
	return segments
end

local tags = {
	["a"] = true,
	["abbr"] = true,
	["address"] = true,
	["article"] = true,
	["aside"] = true,
	["audio"] = true,
	["b"] = true,
	["bdi"] = true,
	["bdo"] = true,
	["blockquote"] = true,
	["body"] = true,
	["button"] = true,
	["canvas"] = true,
	["caption"] = true,
	["cite"] = true,
	["code"] = true,
	["colgroup"] = true,
	["data"] = true,
	["datalist"] = true,
	["dd"] = true,
	["del"] = true,
	["details"] = true,
	["dfn"] = true,
	["dialog"] = true,
	["div"] = true,
	["dl"] = true,
	["dt"] = true,
	["em"] = true,
	["fieldset"] = true,
	["figcaption"] = true,
	["figure"] = true,
	["font"] = true,
	["footer"] = true,
	["form"] = true,
	["frame"] = true,
	["h1"] = true,
	["h2"] = true,
	["h3"] = true,
	["h4"] = true,
	["h5"] = true,
	["h6"] = true,
	["head"] = true,
	["header"] = true,
	["html"] = true,
	["i"] = true,
	["iframe"] = true,
	["ins"] = true,
	["kbd"] = true,
	["label"] = true,
	["legend"] = true,
	["li"] = true,
	["main"] = true,
	["map"] = true,
	["mark"] = true,
	["meter"] = true,
	["nav"] = true,
	["noscript"] = true,
	["object"] = true,
	["ol"] = true,
	["optgroup"] = true,
	["option"] = true,
	["output"] = true,
	["p"] = true,
	["picture"] = true,
	["pre"] = true,
	["progress"] = true,
	["q"] = true,
	["rt"] = true,
	["ruby"] = true,
	["s"] = true,
	["samp"] = true,
	["script"] = true,
	["section"] = true,
	["select"] = true,
	["small"] = true,
	["span"] = true,
	["strong"] = true,
	["style"] = true,
	["sub"] = true,
	["summary"] = true,
	["sup"] = true,
	["svg"] = true,
	["table"] = true,
	["tbody"] = true,
	["td"] = true,
	["template"] = true,
	["textarea"] = true,
	["tfoot"] = true,
	["th"] = true,
	["thead"] = true,
	["time"] = true,
	["title"] = true,
	["tr"] = true,
	["u"] = true,
	["ul"] = true,
	["var"] = true,
	["video"] = true,
	["nobr"] = true,
	["center"] = true,
	["ahref"] = true,
}



local singletons = {
	["meta"] = true,
	["link"] = true,
	["br"] = true,
	["hr"] = true,
	["base"] = true,
	["area"] = true,
	["col"] = true,
	["command"] = true,
	["embed"] = true,
	["img"] = true,
	["input"] = true,
	["keygen"] = true,
	["param"] = true,
	["source"] = true,
	["track"] = true,
	["wbr"] = true
}
function isSingleton(tag)
	return singletons[tag] and true or false
end

function isTag(segment)
	local b = (string.sub(segment, 1, 1) == "<" and string.sub(segment, #segment) == ">" and string.sub(segment, 1, 2) ~= "<!")
	if (not b) then
		return false
	end
	local test
	for tag, _ in pairs(tags) do
		test = string.sub(segment, 1, 2 + #tag)
		if (test == "<"..tag..">" or test == "<"..tag.." ") then
			return true
		end
		test = string.sub(segment, 1, 3 + #tag)
		if (test == "</"..tag..">") then
			return true
		end
	end
	for tag, _ in pairs(singletons) do
		test = string.sub(segment, 1, 2 + #tag)
		if (test == "<"..tag..">" or test == "<"..tag.." ") then
			return true
		end
	end
	return false
end

function whitespace(char)
	local b = string.byte(char)
	return (b == 9 or b == 10 or b == 32)
end

--[[
	convert:
	<link rel="shortcut icon" type="image/x-icon" href="favicon/snake.ico">

	into:
	{
		type = "link",
		close = false,
		attr = {
			rel = "shortcut icon",
			type = "image/x-icon",
			href = "favicon/snake.ico"
		},
		content = {}
	}
]]
function getTagInfo(tag)
	local info = {
		["attr"] = {},
		["content"] = {},
		["fulltext"] = tag
	}
	if (string.sub(tag, 1, 2) == "</") then
		info["close"] = true
		local char
		for i = 3, #tag do
			char = string.sub(tag, i, i)
			--if (char == " " or char == ">") then
			if (whitespace(char) or char == ">") then
				info["type"] = string.sub(tag, 3, i - 1)
				break
			end
		end
	else
		info["close"] = false
		local char, found, status, name, mark
		for i = 2, #tag do
			char = string.sub(tag, i, i)
			if (not found) then
				--if (char == " " or char == ">") then
				if (whitespace(char) or char == ">") then
					found = true
					status = "name"
					name = ""
					info["type"] = string.sub(tag, 2, i - 1)
				end
			else
				if (status == "name") then
					if (char == "=") then
						status = "value1"
					--elseif (char ~= " ") then
					elseif (not whitespace(char)) then
						name = name..char
					end
				elseif (status == "value1") then
					if (char == '"') then
						status = "value2"
						mark = i
					elseif (char == "'") then
						status = "value3"
						mark = i
					end
				elseif (status == "value2") then
					if (char == '"') then
						info["attr"][name] = string.sub(tag, mark + 1, i - 1)
						status = "name"
						name = ""
					end
				elseif (status == "value3") then
					if (char == "'") then
						info["attr"][name] = string.sub(tag, mark + 1, i - 1)
						status = "name"
						name = ""
					end
				end
			end
		end
	end
	return info
end

function pad(number, max)
	local digits = #tostring(max)
	local len = #tostring(number)
	return string.rep("0", digits - len)..number
end

function parse(folder, ugh)
	--print(folder.Name)
	--wait()
	local content = {}
	local stuff = folder:GetChildren()
	table.sort(stuff, (function(a, b)
		return (a.Name < b.Name)
	end))
	local segment, element
	for i, v in pairs(stuff) do
		segment = string.sub(v.Name, ugh + 1)
		if (not isTag(segment)) then
			content[i] = segment
		else
			element = getTagInfo(segment)
			element["close"] = nil
			element["content"] = parse(v, ugh)
			content[i] = element
		end
	end
	return content
end

function buildDocument(segments)
	local document = {
		["status"] = false,
		["elements"] = {}
	}
	local folder = Instance.new("Folder")
	folder.Parent = script
	local location = folder
	local segment, element, object
	for i = 1, #segments do
		segment = segments[i]
		if (not isTag(segment)) then
			object = Instance.new("StringValue")
			object.Name = pad(i, #segments).."text"
			object.Value = segment
			object.Parent = location
		else
			element = getTagInfo(segment)
			--print(getTagInfo(string.sub(location.Name, #tostring(#segments) + 1))["type"])
		
			if (element["close"]) then
				if (element["type"] == getTagInfo(string.sub(location.Name, #tostring(#segments) + 1))["type"]) then
					location = location.Parent
					if (location.Parent == folder.Parent) then
						break
					end
				--else
					
				end
			else
				object = Instance.new("Folder")
				object.Name = pad(i, #segments)..segment
				object.Parent = location
				if (not isSingleton(element["type"])) then
					location = object
				end
			end
		end
	end
	document.elements = parse(folder, #tostring(#segments))
	--folder:Destroy()
	return document
end

function getContext(tag)
	local split = tag:split(" ")
	local tagsT = {}
	
	for index,v in pairs(split) do
		if index == #split then
			v = v:sub(1,#v-1)
		end
		
		if not tags[v] then
			if v:find("=") then
				local sub = v:find("=")
				v = v:sub(1, sub - 1)
				tagsT[v] = v
			end
		end
	end
	
	return tagsT
end

local t = {}

function t.Parse(file)
	local segments = setUp(file)
	local tab = {}
	
	for _,v in pairs(segments) do
		table.insert(tab,{(isTag(v) and getTagInfo(v)["type"] or "text"), v, getContext(v)})
	end
	
	return tab
end



--local document = buildDocument(segments)
--function recurse(list, level)
--	if (type(list) == "table") then
--		for i,v in pairs(list) do
--			print(string.rep("	",level)..i)
--			recurse(v, level + 1)
--		end
--	else
--		print(string.rep("	",level)..tostring(list))
--	end
--end


return t
