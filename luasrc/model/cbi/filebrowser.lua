m = Map("filebrowser", "File Browser", "FileBrowser is a Go-based online file manager that helps you easily manage files on your device.")

m:section(SimpleSection).template  = "filebrowser/filebrowser_status"

s = m:section(TypedSection, "filebrowser")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enabled", translate("enable"))
enable.rmempty = false

o = s:option(Value, "port", "Port")
o.placeholder = 9898
o.default     = 9898
o.datatype    = "port"
o.rmempty     = false

o = s:option(Value, "root_dir", "Directory")
o.placeholder = "/"
o.default     = "/"
o.rmempty     = false

enable_auth = s:option(Flag, "auth", "Disable Auth")
enable_auth.rmempty = false

o = s:option(Value, "db_dir", "Database Directory")
o.placeholder = "/etc/filebrowser"
o.default     = "/etc/filebrowser"
o.rmempty     = false
o.description = "default = /etc/filebrowser"

return m