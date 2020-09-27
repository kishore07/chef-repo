#This recipe handles the R&D activities on scripts only.
directory '/tmp/arockia' do
	action :create
	mode '0755'
	user 'root'
	owner 'root'
	group 'root'
end
bash 'create_folder_archive' do
	code <<-EOH
		touch /tmp/arockia/sample_file.txt
		echo "System Platform is #{node['platform']}" >> /tmp/arockia/sample_file.txt
	EOH
	not_if { ::File.exists?("/tmp/arockia/sample_file.txt") }
end

cookbook_file '/tmp/arockia/index.php' do
	source 'sample.php'
	mode '0755'
	action :create_if_missing
end
