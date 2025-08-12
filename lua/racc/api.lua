local M = {}
local BASE_URL = "https://api.racc.lol/v1"
local curl = require("plenary.curl")

function M.get(path, callback)
	curl.get(BASE_URL .. path, {
		accept = "application/json",
		callback = function(res)
			if not res or res.status ~= 200 then
				vim.schedule(function()
					callback(nil, " Failed to fetch from API")
				end)
				return
			end
			local ok, data = pcall(vim.json.decode, res.body)
			if not ok or not data then
				vim.schedule(function()
					callback(nil, " Failed to parse API response")
				end)
				return
			end
			vim.schedule(function()
				callback(data, nil)
			end)
		end,
	})
end

return M
