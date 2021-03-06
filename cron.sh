#!/bin/sh

# This file gets pulled down OVER THE INTERNET when the classroom machines and re-run every 5 mins (new download every time)
# The purpose here is to easily be able to customize the boxes and add newer files, etc. without refreshing the PXE boot server

su -l student -c "mkdir /home/student/.sync"
su -l student -c "mkdir /home/student/sync"
su -l student -c "ln -s /home/student/sync /home/student/Desktop/sync"

echo '
{
  "listening_port" : 0,                       // 0 - randomize port
  "storage_path" : "/home/student/.sync",

// uncomment next line if you want to set location of pid file
  "pid_file" : "/home/student/.btsync.pid",

  "use_upnp" : true,                              // use UPnP for port mapping

/* limits in kB/s
   0 - no limit
*/
  "download_limit" : 0,
  "upload_limit" : 0,

  "shared_folders" :
  [
    {
      "secret" : "BHPTZDN55QWKGFIUGLGAPBTNJXJZRW7HX",                  
      "dir" : "/home/student/sync", 
      "use_relay_server" : true,
      "use_tracker" : true,
      "use_dht" : false,
      "search_lan" : true,
      "use_sync_trash" : true
    }
  ]
}
' > /home/student/.btsync.conf
chown student.student /home/student/.btsync.conf

su -l student -c "btsync --config /home/student/.btsync.conf"

yum groupinstall "Development Tools" -y
yum install kernel-devel -y

if /etc/init.d/vboxdrv status 
then
	echo "Vbox drivers already built and loaded"
else
	export KERN_DIR=/usr/src/kernels/2.6.32-431.20.3.el6.x86_64
	/etc/init.d/vboxdrv setup
fi

