--- @since 26.9.1
local M = {}

function M:peek(job)
	if ya.target_os() ~= "windows" or os.getenv("TERM_PROGRAM") ~= "herdr" then
		if job.mime == "image/svg+xml" then
			return require("svg"):peek(job)
		elseif job.mime == "image/avif" or job.mime == "image/jxl" or job.mime:match("^image/hei.?$") then
			return require("magick"):peek(job)
		end
		return require("image"):peek(job)
	end

	if job.area.w == 0 or job.area.h == 0 then
		return
	end

	local output, err = Command("chafa"):arg {
		"-f", "symbols", "--relative", "off", "--probe", "off", "--polite", "on",
		"--passthrough", "none", "--animate", "off", "--view-size",
		string.format("%dx%d", job.area.w, job.area.h), "--", tostring(job.file.path),
	}:output()

	if not output then
		return require("empty").msg(job, "Cannot start Chafa: " .. tostring(err))
	elseif not output.status.success then
		return require("empty").msg(job, "Chafa could not preview this image: " .. output.stderr)
	end
	ya.preview_widget(job, ui.Text.parse(output.stdout):area(job.area))
end

function M:seek() end

return M
