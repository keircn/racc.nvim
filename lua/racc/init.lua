local M = {}
local commands = require("racc.commands")

M.config = {
	register = "+",
}

function M.setup(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})
	commands.setup(M.config)
	vim.api.nvim_create_user_command("Racc", commands.check_status, { desc = "Check Raccoon API status" })
	vim.api.nvim_create_user_command("RaccPlease", function(cmd)
		local params = nil
		if cmd.args == "daily" then
			params = { daily = true }
		elseif cmd.args == "hourly" then
			params = { hourly = true }
		elseif cmd.args == "weekly" then
			params = { weekly = true }
		end
		commands.get_raccoon_url(M.config.register, params)
	end, { desc = "Get raccoon image URL (optional: daily, hourly, weekly)", nargs = "?" })
	vim.api.nvim_create_user_command("RaccVideo", function()
		commands.get_raccoon_video(M.config.register)
	end, { desc = "Get raccoon video URL and copy to register" })
	vim.api.nvim_create_user_command("RaccMeme", function()
		commands.get_raccoon_meme(M.config.register)
	end, { desc = "Get raccoon meme URL and copy to register" })
	vim.api.nvim_create_user_command("RaccFact", function()
		commands.get_raccoon_fact(M.config.register)
	end, { desc = "Get a random raccoon fact" })
	vim.api.nvim_create_user_command("RaccStats", commands.get_api_stats, { desc = "Get API statistics" })
	vim.api.nvim_create_user_command("RaccById", function(cmd)
		commands.get_raccoon_by_id(M.config.register, cmd.args)
	end, { desc = "Get raccoon by ID", nargs = 1 })
	vim.api.nvim_create_user_command("RaccMemeById", function(cmd)
		commands.get_meme_by_id(M.config.register, cmd.args)
	end, { desc = "Get meme by ID", nargs = 1 })
	vim.api.nvim_create_user_command("RaccList", commands.list_raccoons, { desc = "List available raccoons" })
	vim.api.nvim_create_user_command("RaccMemeList", commands.list_memes, { desc = "List available memes" })
end

return M
