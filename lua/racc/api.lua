local M = {}
local BASE_URL = "https://api.racc.lol/v1"
local curl = require("plenary.curl")
local log = require("racc.log")

function M.get(path, callback)
	local full_url = BASE_URL .. path
	log.info("Making API request", { url = full_url })
	
	curl.get(full_url, {
		accept = "application/json",
		callback = function(res)
			log.debug("API response received", {
				url = full_url,
				status = res and res.status or "nil",
				body_length = res and res.body and #res.body or 0,
				headers = res and res.headers or {}
			})
			
			if not res then
				log.error("No response received from API", { url = full_url })
				vim.schedule(function()
					callback(nil, " No response received from API")
				end)
				return
			end
			
			if res.status ~= 200 then
				log.error("API returned non-200 status", {
					url = full_url,
					status = res.status,
					body = res.body
				})
				vim.schedule(function()
					callback(nil, string.format(" API returned status %d", res.status))
				end)
				return
			end
			
			log.debug("API response body", { url = full_url, body = res.body })
			
			local ok, data = pcall(vim.json.decode, res.body)
			if not ok then
				log.error("Failed to parse JSON response", {
					url = full_url,
					error = data,
					body = res.body
				})
				vim.schedule(function()
					callback(nil, " Failed to parse API response: " .. tostring(data))
				end)
				return
			end
			
			if not data then
				log.error("Parsed JSON is nil", { url = full_url, body = res.body })
				vim.schedule(function()
					callback(nil, " Empty response from API")
				end)
				return
			end
			
			log.info("API request successful", {
				url = full_url,
				success = data.success,
				data_keys = data.data and vim.tbl_keys(data.data) or {}
			})
			
			vim.schedule(function()
				callback(data, nil)
			end)
		end,
		on_error = function(err)
			log.error("Curl error occurred", {
				url = full_url,
				error = err
			})
			vim.schedule(function()
				callback(nil, " Network error: " .. tostring(err))
			end)
		end,
	})
end

return M
