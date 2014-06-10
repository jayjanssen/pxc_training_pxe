class pxe::tftpd {
    package {
        'tftp-server': ensure => installed; 
        'xinetd': ensure => installed;
        'syslinux': ensure => installed;
    }
    
    service {
        'xinetd': ensure => running, enable => true, require => Package['xinetd'];
    }
    
    file { '/etc/xinetd.d/tftp':
		ensure => 'present',
		owner => 'root',
		group => 'root',
		mode => 0400,
        content => '# default: off
# description: The tftp server serves files using the trivial file transfer \
#       protocol.  The tftp protocol is often used to boot diskless \
#       workstations, download configuration files to network-aware printers, \
#       and to start the installation process for some operating systems.
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /var/lib/tftpboot
        disable                 = no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}',
        require => Package['tftp-server'],
        notify => Service['xinetd'];
    }   
    
    exec { 'setup_pxe':
        cwd => '/usr/share/syslinux',
        command => 'cp pxelinux.0 menu.c32 memdisk mboot.c32 chain.c32 /var/lib/tftpboot/',
        path => ['/usr/bin', '/bin'],
        creates => '/var/lib/tftpboot/pxelinux.0',
        require => Package['syslinux'];
    }
    
    file { 
        '/var/lib/tftpboot/pxelinux.cfg':
            ensure => directory,
    		owner => 'root',
    		group => 'root',
    		mode => 0555,
            require => Package['tftp-server'];
        '/var/lib/tftpboot/pxelinux.cfg/default':
    		ensure => 'present',
    		owner => 'root',
    		group => 'root',
    		mode => 0444,
            content => 'default menu.c32
prompt 0
timeout 300
ONTIMEOUT 1

menu title ########## PXE Boot Menu ##########

label 1
menu label ^1) Install CentOS 6 x86_64 Edition
kernel centos6_x86_64/images/pxeboot/vmlinuz
append initrd=centos6_x86_64/images/pxeboot/initrd.img ks=http://10.10.10.5/centos.cfg
IPAPPEND 2

label 2
menu label ^2) Boot from local drive localboot',
            require => File['/var/lib/tftpboot/pxelinux.cfg'];
    }
   
}