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

function M.get_raccoon_url(register, params)
	local query_params = "json=true"
	if params then
		if params.daily then
			query_params = query_params .. "&daily=true"
		elseif params.hourly then
			query_params = query_params .. "&hourly=true"
		elseif params.weekly then
			query_params = query_params .. "&weekly=true"
		end
	end

	local plugin_start = vim.uv.hrtime()
	api.get("/raccoon?" .. query_params, function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data and data.data.url then
			vim.fn.setreg(register, data.data.url)
			local time_info = ""
			if params and params.daily then
				time_info = " (daily)"
			elseif params and params.hourly then
				time_info = " (hourly)"
			elseif params and params.weekly then
				time_info = " (weekly)"
			end
			local msg = string.format(
				" Copied raccoon URL%s to register '%s'\nURL: %s\nIndex: %d\nDimensions: %dx%d\nAlt: %s\nPlugin time: %.3f sec",
				time_info,
				register,
				data.data.url,
				data.data.index or -1,
				data.data.width or -1,
				data.data.height or -1,
				data.data.alt or "N/A",
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get raccoon URL", vim.log.levels.ERROR)
		end
	end)
end

function M.get_raccoon_video(register)
	local plugin_start = vim.uv.hrtime()
	api.get("/video?json=true", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data and data.data.url then
			vim.fn.setreg(register, data.data.url)
			local msg = string.format(
				" Copied raccoon video URL to register '%s'\nURL: %s\nSize: %s bytes\nContent-Type: %s\nPlugin time: %.3f sec",
				register,
				data.data.url,
				data.data.size or "Unknown",
				data.data.contentType or "video/mp4",
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get raccoon video URL", vim.log.levels.ERROR)
		end
	end)
end

function M.get_raccoon_meme(register)
	local plugin_start = vim.uv.hrtime()
	api.get("/meme?json=true", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data and data.data.url then
			vim.fn.setreg(register, data.data.url)
			local msg = string.format(
				" Copied raccoon meme URL to register '%s'\nURL: %s\nIndex: %d\nDimensions: %dx%d\nAlt: %s\nPlugin time: %.3f sec",
				register,
				data.data.url,
				data.data.index or -1,
				data.data.width or -1,
				data.data.height or -1,
				data.data.alt or "N/A",
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get raccoon meme URL", vim.log.levels.ERROR)
		end
	end)
end

function M.get_raccoon_fact(register)
	local plugin_start = vim.uv.hrtime()
	api.get("/fact?json=true", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data and data.data.fact then
			if register then
				vim.fn.setreg(register, data.data.fact)
			end
			local msg = string.format(
				" Raccoon Fact%s:\n%s\nPlugin time: %.3f sec",
				register and string.format(" (copied to register '%s')", register) or "",
				data.data.fact,
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get raccoon fact", vim.log.levels.ERROR)
		end
	end)
end

function M.get_api_stats()
	local plugin_start = vim.uv.hrtime()
	api.get("/stats", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data then
			local stats = data.data
			local msg = string.format(
				" API Statistics:\nTotal Raccoons: %s\nTotal Memes: %s\nTotal Videos: %s\nTotal Requests: %s\nPlugin time: %.3f sec",
				stats.raccoons or "N/A",
				stats.memes or "N/A",
				stats.videos or "N/A",
				stats.requests or "N/A",
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get API statistics", vim.log.levels.ERROR)
		end
	end)
end

function M.get_raccoon_by_id(register, id)
	if not id or id == "" then
		vim.notify(" Please provide a raccoon ID", vim.log.levels.ERROR)
		return
	end

	local plugin_start = vim.uv.hrtime()
	api.get("/raccoon/" .. id .. "?json=true", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data and data.data.url then
			vim.fn.setreg(register, data.data.url)
			local msg = string.format(
				" Copied raccoon #%s URL to register '%s'\nURL: %s\nDimensions: %dx%d\nAlt: %s\nPlugin time: %.3f sec",
				id,
				register,
				data.data.url,
				data.data.width or -1,
				data.data.height or -1,
				data.data.alt or "N/A",
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get raccoon #" .. id, vim.log.levels.ERROR)
		end
	end)
end

function M.get_meme_by_id(register, id)
	if not id or id == "" then
		vim.notify(" Please provide a meme ID", vim.log.levels.ERROR)
		return
	end

	local plugin_start = vim.uv.hrtime()
	api.get("/meme/" .. id .. "?json=true", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data and data.data.url then
			vim.fn.setreg(register, data.data.url)
			local msg = string.format(
				" Copied meme #%s URL to register '%s'\nURL: %s\nDimensions: %dx%d\nAlt: %s\nPlugin time: %.3f sec",
				id,
				register,
				data.data.url,
				data.data.width or -1,
				data.data.height or -1,
				data.data.alt or "N/A",
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get meme #" .. id, vim.log.levels.ERROR)
		end
	end)
end

function M.list_raccoons()
	local plugin_start = vim.uv.hrtime()
	api.get("/raccoons", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data then
			local count = #data.data
			local msg = string.format(
				" Found %d raccoons available\nUse :RaccById <id> to get a specific raccoon\nPlugin time: %.3f sec",
				count,
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get raccoon list", vim.log.levels.ERROR)
		end
	end)
end

function M.list_memes()
	local plugin_start = vim.uv.hrtime()
	api.get("/memes", function(data, err)
		local plugin_end = vim.uv.hrtime()
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		if data.success and data.data then
			local count = #data.data
			local msg = string.format(
				" Found %d memes available\nUse :RaccMemeById <id> to get a specific meme\nPlugin time: %.3f sec",
				count,
				(plugin_end - plugin_start) / 1e9
			)
			vim.notify(msg, vim.log.levels.INFO)
		else
			vim.notify(" Failed to get meme list", vim.log.levels.ERROR)
		end
	end)
end

return M
