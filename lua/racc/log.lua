local M = {}

local function get_log_path()
	local data_path = vim.fn.stdpath("data")
	return data_path .. "/racc.log"
end

local function write_log(level, message, data)
	local log_path = get_log_path()
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")

	local log_entry = string.format("[%s] [%s] %s", timestamp, level, message)

	if data then
		if type(data) == "table" then
			local ok, json_data = pcall(vim.json.encode, data)
			if ok then
				log_entry = log_entry .. "\nData: " .. json_data
			else
				log_entry = log_entry .. "\nData: " .. vim.inspect(data)
			end
		else
			log_entry = log_entry .. "\nData: " .. tostring(data)
		end
	end

	log_entry = log_entry .. "\n"

	local file = io.open(log_path, "a")
	if file then
		file:write(log_entry)
		file:close()
	end
end

function M.info(message, data)
	write_log("INFO", message, data)
end

function M.error(message, data)
	write_log("ERROR", message, data)
end

function M.debug(message, data)
	write_log("DEBUG", message, data)
end

function M.warn(message, data)
	write_log("WARN", message, data)
end

function M.get_log_path()
	return get_log_path()
end

function M.clear_log()
	local log_path = get_log_path()
	local file = io.open(log_path, "w")
	if file then
		file:close()
	end
end

return M
