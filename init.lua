local M = {}

function M.setup()
	print("trash panda")

	vim.api.nvim_create_user_command("racc", function()
		print("Hello, World!")
	end, { desc = "Says hello" })
end

return M
