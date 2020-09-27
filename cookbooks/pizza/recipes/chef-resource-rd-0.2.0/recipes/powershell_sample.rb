powershell_script 'check-hosts-file' do
	code <<-EOH
		$content = Get-content "#{node.Network.host_loc}"
		Write-Host $content
		Write-Host #{node['platform']}
	EOH
end
