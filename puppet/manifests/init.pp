exec {'apt_update':
    command => 'apt-get update',
    path => '/usr/bin'
}

class { 'nginx::setup':
    ensure     => 'present',
    enable     => 'true',
    service    => 'running',
    version    => 'installed',
    config     => '/vagrant/puppet/config/default-nginx.conf'
}	

class { 'git::install': }
class { 'mysql::install': }
