
bash "Ohai attributes" do
code <<-EOC
echo #{node['os_version']} > /tmp/osversion
	EOC
end

