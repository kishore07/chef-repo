file '/tmp/arockia/storage.txt' do
end

execute 'Get-Disk-Storage' do
	command 'df -kh >> /tmp/arockia/storage.txt'
	action :nothing
end

ruby_block 'Check for content' do
	block do
		lines = `cat /tmp/arockia/storage.txt | wc -l`
		if Integer(lines) == 0
			resources(:execute => 'Get-Disk-Storage').run_action(:run)
		end
	end
end
