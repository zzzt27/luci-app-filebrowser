module("luci.controller.filebrowser", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/filebrowser") then
		return
	end

	local page
	page = entry({"admin", "services", "filebrowser"}, firstchild(), _("File Browser"), 100)
	page.dependent = true
	entry({"admin", "services", "filebrowser", "iframe"}, template("filebrowser/filebrowser"), _("Filebrowser"), 1).leaf = true
	entry({"admin", "services", "filebrowser", "config"}, cbi("filebrowser"), _("Config"), 2).leaf = true
	entry({"admin", "services", "filebrowser", "status"}, call("act_status")).leaf = true
end


function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep filebrowser >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
