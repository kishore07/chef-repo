file '/tmp/arockia/storage.txt' do
	action :create_if_missing
end

execute 'Get-Disk-Storage' do
	command 'df -kh >> /tmp/arockia/storage.txt'
	action :nothing
end

file '/tmp/arockia/new-file.csv' do
	content 'Sample File, Arockia, Today'
end

ruby_block 'Check for content' do
	block do
		lines = `cat /tmp/arockia/storage.txt | wc -l`
		if Integer(lines) == 0
			resources(:execute => "Get-Disk-Storage").run_action(:run)
		elsif Integer(lines) > 0
			resources(:file => "/tmp/arockia/new-file.csv").run_action(:create)
		end
	end
end
