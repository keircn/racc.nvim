local M = {}
local BASE_URL = "https://api.racc.lol/v1"
local Job = require("plenary.job")

function M.get(path, callback)
	Job:new({
		command = "lua",
		args = {
			"-e",
			string.format(
				[[
                local http = require("plenary.curl")
                local res = http.get("%s%s", { accept = "application/json" })
                if res and res.status == 200 then
                    print(res.body)
                else
                    print("")
                end
            ]],
				BASE_URL,
				path
			),
		},
		on_exit = function(j, return_val)
			if return_val ~= 0 then
				vim.schedule(function()
					callback(nil, " Failed to fetch from API")
				end)
				return
			end
			local output = table.concat(j:result(), "\n")
			local ok, data = pcall(vim.json.decode, output)
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
	}):start()
end

return M
