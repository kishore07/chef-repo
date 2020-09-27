
execute 'system info' do
	command 'dmidecode -t 1 > /tmp/systeminfo.txt'
	creates '/tmp/systeminfo.txt'
end
	
