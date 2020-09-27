cron 'Server stats' do 
	minute '0'
	hour '12'
	day '*'
	month '*'
	weekday '*'
	user 'kishore'
	home '/home/kishore'
	command 'top -b -n 4 > /home/kishore/stat.txt'
end
