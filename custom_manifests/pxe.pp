include pxe::httpd
include pxe::tftpd
include pxe::dhcp
include pxe::centos_iso

Class['pxe::tftpd'] -> Class['pxe::centos_iso'] -> Class['pxe::httpd']