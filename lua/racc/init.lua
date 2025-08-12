local M = {}
local commands = require("racc.commands")

M.config = {
	register = "+",
}

function M.setup(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})
	commands.setup(M.config)
	vim.api.nvim_create_user_command("Racc", commands.check_status, { desc = "Check Raccoon API status" })
	vim.api.nvim_create_user_command("RaccPlease", function()
		commands.get_raccoon_url(M.config.register)
	end, { desc = "Get raccoon image URL and copy to register" })
end

return M
