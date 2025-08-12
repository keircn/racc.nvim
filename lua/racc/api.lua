local M = {}
local BASE_URL = "https://api.racc.lol/v1"

local function request(path)
	local result = vim.system({ "wget", "-qO-", BASE_URL .. path }):wait()
	if result.code ~= 0 then
		return nil, " Failed to fetch from API"
	end
	local ok, data = pcall(vim.json.decode, result.stdout)
	if not ok or not data then
		return nil, " Failed to parse API response"
	end
	return data, nil
end

function M.get(path)
	return request(path)
end

return M
