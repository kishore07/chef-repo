
bash 'newdirectory' do
	code <<-EOF
	ls -l /root/sampledir
	if [ `echo $?` != 0 ]; then
	mkdir -p /root/sampledir
	chown cadmin:cadmin /root/sampledir
	chmod 755 /root/sampledir
	echo "Created new directory"
	else
 	touch /root/sampledir/samplefile
	fi
	EOF
end
