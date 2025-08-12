local M = {}
local commands = require("racc.commands")

function M.setup()
	vim.api.nvim_create_user_command("Racc", commands.check_status, { desc = "Check Raccoon API status" })
	vim.api.nvim_create_user_command(
		"RaccPlease",
		commands.get_raccoon_url,
		{ desc = "Get raccoon image URL and copy to register" }
	)
end

return M
