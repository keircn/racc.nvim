local M = {}
local api = require("racc.api")

local function create_float(width, height, title)
	local buf = vim.api.nvim_create_buf(false, true)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = title or "",
		title_pos = "center",
	}
	local win = vim.api.nvim_open_win(buf, true, opts)
	return buf, win
end

local function supports_kitty_graphics()
	return os.getenv("TERM") and os.getenv("TERM"):match("kitty")
end

local function preview_image(url)
	if supports_kitty_graphics() then
		local job = vim.system({ "kitty", "+kitten", "icat", url }, { text = true })
		job:wait()
	elseif vim.fn.executable("chafa") == 1 then
		local buf, _ = create_float(60, 30, "Raccoon Preview")
		local job = vim.system({ "chafa", url }, { text = true })
		local result = job:wait()
		if result.code == 0 then
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result.stdout, "\n"))
		end
	else
		vim.notify(" No supported image preview method found (kitty or chafa required)", vim.log.levels.WARN)
	end
end

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
			preview_image(data.data.url)
		else
			vim.notify(" Failed to get raccoon URL", vim.log.levels.ERROR)
		end
	end)
end

return M
