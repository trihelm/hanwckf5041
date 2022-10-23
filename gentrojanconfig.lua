local cjson = require "cjson"
local server_section = arg[1]
local proto = arg[2]
local local_port = arg[3] or "0"

local ssrindext = io.popen("dbus get ssconf_basic_json_" .. server_section)
local servertmp = ssrindext:read("*all")
local server = cjson.decode(servertmp)

local trojan = {
log = {
	-- error = "/var/ssrplus.log",
	loglevel = "warning"
},
	-- 传入连接
	inbound = (local_port ~= "0") and {
		port = local_port,
		protocol = "dokodemo-door",
		settings = {
			network = "tcp",
			followRedirect = true
		},
		sniffing = {
			enabled = true,
			destOverride = { "http", "tls" }
		}
	} or nil,
	-- 开启 socks 代理
	inboundDetour = (proto == "tcp" and socks_port ~= "0") and {
		{
		protocol = "socks",
		port = socks_port,
			settings = {
				auth = "noauth",
				udp = true
			}
		}
	} or nil,
	-- 传出连接
	outbound = {
		protocol = "trojan",
		settings = {
			servers = {
				{
					address = server.server,
					port = tonumber(server.server_port),
					password = server.password	
				}
			}
		},
	-- 底层传输配置
		streamSettings = {
			tlsSettings = (server.tls == '1') and 
			{
				allowInsecure = (server.insecure ~= "0") and true or false,
				serverName=server.tls_host
			} or nil,

			xtlsSettings = (server.tls == '2') and
			{
				allowInsecure = (server.insecure ~= "0") and true or false,
				serverName = server.server
			} or nil,
			security = (server.tls == '1') and "tls" or ((server.tls == '2') and "xtls" or "none")
		},
		mux = {
			enabled = (server.mux == "1") and true or false,
			concurrency = 8
		}
	},

	-- 额外传出连接
	outboundDetour = {
		{
			protocol = "freedom",
			tag = "direct",
			settings = { keep = "" }
		}
	}
}

print(cjson.encode(trojan))
