--[[
LuCI - Lua Configuration Interface

Copyright 2011 Copyright 2011 flyzjhz <flyzjhz@gmail.com>


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

]]--

require("luci.tools.webadmin")


local sys = require "luci.sys"

m = Map("qosv4", translate("qosv4 title","QOSv4"),
		translate("qosv4 title desc","qosv4 title desc"))


s = m:section(TypedSection, "qos_settings", translate("qos goble setting","qos goble setting"), translate("<p>如需帮助:<a target=\"_blank\" href=\"http://myop.ml/archives/category/firmware-guide/\">请查看使用教程</a></p>")) 
s.anonymous = true
s.addremove = false

enable = s:option(Flag, "enable", translate("qos enable", "qos enable"))
enable.default = false
enable.optional = false
enable.rmempty = false

function enable.write(self, section, value)
	if value == "0" then
		os.execute("/etc/init.d/qosv4 stop")
		os.execute("/etc/init.d/qosv4 disable")
		os.execute("/etc/init.d/qosv4-relay disable")
	else
		os.execute("/etc/init.d/qos_gargoyle stop")
		os.execute("/etc/init.d/qos_gargoyle disable")
		os.execute("/etc/init.d/qos-relay disable")
		os.execute("uci set qos_gargoyle.config.enabled=0 && uci commit")
		os.execute("/etc/init.d/qosv4 enable")
		os.execute("/etc/init.d/qosv4-relay enable")
	end
	Flag.write(self, section, value)
end

qos_scheduler = s:option(Flag, "qos_scheduler", translate("qos scheduler enable", "qos scheduler enable"),
			translate("qos scheduler desc","qos scheduler desc")) 
qos_scheduler.default = false
qos_scheduler.optional = false
qos_scheduler.rmempty = false


crontab = s:option( DummyValue,"crontab", translate("qos scheduler update"))
 crontab.titleref = luci.dispatcher.build_url("admin", "system", "crontab")


DOWN = s:option(Value, "DOWN", translate("DOWN speed","DOWN speed"),
	translate("DOWN speed desc","DOWN speed desc"))
DOWN.optional = false
DOWN.rmempty = false

UP = s:option(Value, "UP", translate("UP speed","UP speed"),
	translate("UP speed desc","UP speed desc"))
UP.optional = false
UP.rmempty = false

--[[
DOWNLOADR2 = s:option(Value, "DOWNLOADR2", translate("DOWNLOADR2 speed","DOWNLOADR2 speed"))
DOWNLOADR2.optional = false
DOWNLOADR2.rmempty = false

UPLOADR2 = s:option(Value, "UPLOADR2", translate("UPLOADR2 speed","UPLOADR2 speed"))
UPLOADR2.optional = false
UPLOADR2.rmempty = false

DOWNLOADC2 = s:option(Value, "DOWNLOADC2", translate("DOWNLOADC2 speed","DOWNLOADC2 speed"))
DOWNLOADC2.optional = false
DOWNLOADC2.rmempty = false

UPLOADC2 = s:option(Value, "UPLOADC2", translate("UPLOADC2 speed","UPLOADC2 speed"))
UPLOADC2.optional = false
UPLOADC2.rmempty = false
]]--


qos_ip = m:section(TypedSection, "qos_ip", translate("qos black ip","qos black ip"))
qos_ip.anonymous = true
qos_ip.addremove = true
qos_ip.sortable  = true
qos_ip.template = "cbi/tblsection"
qos_ip.extedit  = luci.dispatcher.build_url("admin/network/qosv4/qosv4ip/%s")

qos_ip.create = function(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(qos_ip.extedit % sid)
		return
	end
end



enable = qos_ip:option(Flag, "enable", translate("enable", "enable"))
enable.default = false
enable.optional = false
enable.rmempty = false



limit_ips = qos_ip:option(DummyValue, "limit_ips", translate("limit_ips","limit_ips"))
limit_ips.rmempty = true


limit_ipe = qos_ip:option(DummyValue, "limit_ipe", translate("limitp_ipe","limit_ipe"))
limit_ipe.rmempty = true



DOWNLOADC = qos_ip:option(DummyValue, "DOWNLOADC", translate("DOWNLOADC speed","DOWNLOADC speed"))
DOWNLOADC.optional = false
DOWNLOADC.rmempty = false


UPLOADC = qos_ip:option(DummyValue, "UPLOADC", translate("UPLOADC speed","UPLOADC speed"))
UPLOADC.optional = false
UPLOADC.rmempty = false

tcplimit = qos_ip:option(DummyValue, "tcplimit", translate("tcplimit","tcplimit"))
tcplimit.optional = false
tcplimit.rmempty = false

udplimit = qos_ip:option(DummyValue, "udplimit", translate("udplimit","udplimit"))
udplimit.optional = false
udplimit.rmempty = false



s = m:section(TypedSection, "transmission_limit", translate("transmission limit","transmission limit"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = false

enable = s:option(Flag, "enable", translate("enable", "enable"))
enable.default = false
enable.optional = false
enable.rmempty = false

downlimit= s:option(Value, "downlimit", translate("downlimit speed","downlimit speed"))
downlimit.optional = false
downlimit.rmempty = false

uplimit= s:option(Value, "uplimit", translate("uplimit speed","uplimit speed"))
uplimit.optional = false
uplimit.rmempty = false


s = m:section(TypedSection, "qos_nolimit_ip", translate("qos white","qos white"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.sortable  = true

enable = s:option(Flag, "enable", translate("enable", "enable"))
enable.default = false
enable.optional = false
enable.rmempty = false

nolimit_mac= s:option(Value, "nolimit_mac", translate("white mac","white mac"))
nolimit_mac.rmempty = true

nolimit_ip= s:option(Value, "nolimit_ip", translate("white ip","white ip"))
nolimit_ip.rmempty = true


sys.net.arptable(function(entry)
  nolimit_ip:value(entry["IP address"])
	nolimit_mac:value(
		entry["HW address"],
		entry["HW address"] .. " (" .. entry["IP address"] .. ")"
	)
end)

return m


