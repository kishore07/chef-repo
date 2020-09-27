filepath="#{Chef::Config['file_cache_path']}"

bash "cache" do
	code <<-EOC
cd #{filepath}
touch example
pwd > /tmp/config.txt
	EOC
end
