local module = {}

local typeTags = {
	["background-color"] = function(value)
		value = tostring(value)
		print(type(value))
		value = value:sub(value:find("#"), #value)
		return Color3.fromHex(value)
	end,
	
	["border-radius"] = function(value)
		value = value:sub(2, value:find("e") - 1)
		
		return value
	end,
}

function checkTags(char)
	return {(char == "{" or char == "}"), char}
end

function splitWithChar(char, text)
	
end

function split(text)
	local vars = text:split(";")
	local tags = {}
	
	print(vars)
	
	for _,tag in pairs(vars) do
		if tag[1] ~= "" or tag[1] ~= " " then
			local values = tag:split(":")
			local spaceEnd
			
			print(values)
			
			for i = 1,10000 do
				if values[1]:sub(i,i) ~= " " then
					spaceEnd = i
					break
				end
			end
			
			

			values[1] = values[1]:sub(spaceEnd, string.len(values[1]))
			tags[values[1]] = values[2]
			
			print(tags)

		end
	end
	
	return tags
end

function decodeTagsTable(tags)
	--tag is the name and value is the value
	print(tags)
	for tag,value in pairs(tags) do
		if typeTags[tag] then
			print(tag)
			return typeTags[tag](value)
		end
	end
end

function getCSSTags(text : string)
	local title,startS,endS,endString,mainText
	startS = 1
	
	for i = 1,10000 do
		local tagTable = checkTags(text:sub(i, i))
		
		if tagTable[1] then
			endS = i - 2
			break
		end
	end
	
	title = text:sub(startS, endS)
	
	print(title)
	
	for i = 1,10000 do
		local tagTable = checkTags(text:sub(i, i))

		if tagTable[1] and tagTable[2] == "}" then
			endS = i
			break
		end
	end
	
	endString = text:sub(startS, endS)
	
	print(endString)
	
	for i = 1,10000 do
		local tagTable = checkTags(text:sub(i, i))

		if tagTable[1] and tagTable[2] == "}" then
			endS = i - 2
			break
		elseif tagTable[1] and tagTable[2] == "{" then
			startS = i + 1
		end
	end
	
	mainText = text:sub(startS, endS)
	
	print(mainText)
	
	local tags = split(mainText)
	
	
	if title == "body" then
		for tag,_ in pairs(tags) do
			if tag == "background-color" then
				local value = decodeTagsTable(tags)
				script.Parent.Parent:WaitForChild("PageViewer").BackgroundColor3 = value
			end
		end
	end
	if title == "div" then
		for tag,_ in pairs(tags) do
			if tag == "border-radius" then
				local value = decodeTagsTable(tags)
				for _,divs in pairs(script.Parent.Parent:WaitForChild("PageViewer"):WaitForChild("divs"):GetChildren()) do
					if divs.Name:find("div_") then
						divs.Size = UDim2.new(0,300,0,600)
						script.Parent.Parent:WaitForChild("PageViewer"):WaitForChild(divs).UICorner.CornerRadius = UDim.new(0, value)
					end
				end
			end
		end
	end
end

function module.Parse(css)
	getCSSTags(css)
end

return module
