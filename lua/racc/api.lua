local M = {}
local BASE_URL = "https://api.racc.lol/v1"

function M.get(path)
	local handle = io.popen("curl -s " .. BASE_URL .. path)
	if not handle then
		return nil, " Failed to run curl"
	end
	local output = handle:read("*a")
	handle:close()
	local ok, data = pcall(vim.json.decode, output)
	if not ok or not data then
		return nil, " Failed to parse API response"
	end
	return data, nil
end

return M
