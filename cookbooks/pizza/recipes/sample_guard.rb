
file '/tmp/testfile.txt' do 
	content "Test file is created"
	action :create
	only_if do !File.exist?('/etc/passwd')end
	Chef::Log.info("File exists hence test file is not created")
end
