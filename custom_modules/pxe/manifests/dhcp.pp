class pxe::dhcp {
    package {
        'dhcp': ensure => installed; 
    }
    
    service {
        'dhcpd': ensure => running, enable => true;
    }    
    
    file { '/etc/dhcp/dhcpd.conf':
		ensure => 'present',
		owner => 'root',
		group => 'root',
		mode => 0400,
        content => '# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# option definitions common to all supported networks...
option domain-name "mclabs.com";
#option domain-name-servers bootstrap.mclabs.com

default-lease-time 600;
max-lease-time 7200;

# Use this to enble / disable dynamic dns updates globally.
#ddns-update-style none;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

# A slightly different configuration for an internal subnet.
subnet 10.10.10.0 netmask 255.255.255.0 {
 range 10.10.10.5 10.10.10.100;
 option routers 10.10.10.5;
 option domain-name "mclabs.com";
 option broadcast-address 10.10.10.255;
}

allow booting;
allow bootp;
option option-128 code 128 = string;
option option-129 code 129 = text;
next-server 10.10.10.5;
filename "pxelinux.0";
',
        require => Package['dhcp'],
        notify => Service['dhcpd'];
    }   
    
}