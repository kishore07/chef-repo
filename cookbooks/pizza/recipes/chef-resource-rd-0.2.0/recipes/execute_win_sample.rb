execute 'test-cmd' do
	command 'systeminfo >> %temp%//systeminfo.txt'
	action :run
end
