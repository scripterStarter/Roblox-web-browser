--IAmBanFor June 7 2022
--PlayLib Draw
--This draws the game

local module = {}

local PNG = require(script.Parent:WaitForChild("PNG"))
local GreedyCanvas = require(script:WaitForChild("GreedyCanvas"))

local images = {}

local pixelsImage = {}


function module:LoadImage(name,url,gui,size,pos)
	--nerdy stuff
	local UrlData = game:GetService("HttpService"):GetAsync(url)
	
	if UrlData then
		local parsedImage = PNG.new(UrlData)
		
		if parsedImage and parsedImage ~= "stopped" then
			local Canvas = GreedyCanvas.new(parsedImage.Width,parsedImage.Height)
			local GUICANVAS : Frame = Canvas:GetCanvasGui()
			Canvas:SetParent(gui)
			
			GUICANVAS.Position = pos
			GUICANVAS.Size = size
			
			images[name] = {parsedImage,Canvas}
		end
	else
		error("PlayLib Error | Buffer is not correct. Is the image a PNG or the url is not correct?")
	end
end

function module:DrawImage(name)
	if not images[name] then
		error("PlayLib Error | Image not loaded. Use Draw:LoadImage.")
	end
	
	local Height = images[name][1].Height
	local Width = images[name][1].Width
	local Canvas = images[name][2]
	

	for pX = 1, Width do
		for pY = 1, Height do
			local color, alpha = images[name][1]:GetPixel(pX,pY)
				
			Canvas:SetPixel(pX,pY,color)
		end
	end
	
	Canvas:Render()
end


function module:Clear()
	for _,v in pairs(images) do
		v[2]:Clear()
	end
end


return module