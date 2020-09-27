file '/tmp/arockia/updateschedule.txt' do
	action :create_if_missing
	mode '0777'
end

cron 'update-time' do
	action node.tags.include?('update-time') ? :create : :delete
	minute '0'
	hour '*'
	weekday '*'
	month '*'
	command %w{
		echo $(date) >> /tmp/arockia/updateschedule.txt
	}.join(' ')
end
