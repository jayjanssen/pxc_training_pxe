class pxe::centos_iso {
    exec { 'copy_iso':
        cwd => '/root',
        command => 'cp /vagrant/isos/CentOS.iso /root',
        path => ['/usr/bin', '/bin'],
        creates => '/root/CentOS.iso';
    }
    
    file {
        '/var/lib/tftpboot/centos6_x86_64':
            ensure => 'directory',
            owner => 'root',
            group => 'root',
    		mode => 0555;
    }
    
    mount { '/var/lib/tftpboot/centos6_x86_64':
        ensure => 'mounted',
        atboot => '1',
        device => '/root/CentOS.iso',
        fstype => 'iso9660',
        options => 'loop',
        require => File['/var/lib/tftpboot/centos6_x86_64'];
    
    }    
}