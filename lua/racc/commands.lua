local M = {}
local api = require("racc.api")

function M.setup(config)
	M.config = config
end

function M.check_status()
	local plugin_start = vim.uv.hrtime()
	api.get("/", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success then
			local msg = string.format(
				" Raccoon API reachable\nMessage: %s\nPlugin time: %.3f sec",
				data.message,
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" API returned an error", vim.log.levels.ERROR)
		end
	end)
end

function M.get_raccoon_url(register)
	api.get("/raccoon?json=true", function(data, err)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data and data.data.url then
			vim.fn.setreg(register, data.data.url)
			vim.notify(
				string.format(" Copied raccoon URL to register '%s': %s", register, data.data.url),
				vim.log.levels.INFO
			)
		else
			vim.notify(" Failed to get raccoon URL", vim.log.levels.ERROR)
		end
	end)
end

return M
