if node['platform'] == 'windows'
	default.Network.host_loc	= "C:/Windows/System32/drivers/etc/hosts"
else
	default.Network.host_loc	= "/etc/hosts"
end
