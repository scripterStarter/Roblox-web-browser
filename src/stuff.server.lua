game:GetService("ReplicatedStorage"):WaitForChild("GetRawData").OnServerInvoke = function(player,url)
	return game:GetService("HttpService"):GetAsync(url)
end
