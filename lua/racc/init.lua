local M = {}

function M.setup()
	vim.api.nvim_create_user_command("Racc", function()
		local plugin_start = vim.uv.hrtime()

		local url = "https://api.racc.lol/v1"
		local handle = io.popen("curl -s -w '\\n%{time_total}' " .. url)
		if not handle then
			vim.notify(" Failed to run curl", vim.log.levels.ERROR)
			return
		end

		local output = handle:read("*a")
		handle:close()

		local json_str, curl_time_str = output:match("^(.*)\n([%d%.]+)$")
		local curl_time = tonumber(curl_time_str) or 0

		local ok, data = pcall(vim.json.decode, json_str)
		if not ok or not data then
			vim.notify(" Failed to parse API response", vim.log.levels.ERROR)
			return
		end

		local plugin_end = vim.uv.hrtime()

		if data.success then
			local msg = string.format(
				" Raccoon API reachable\nMessage: %s\nAPI time: %.3f sec\nPlugin time: %.3f sec",
				data.message,
				curl_time,
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" API returned an error", vim.log.levels.ERROR)
		end
	end, { desc = "Check Raccoon API status" })
end

return M
