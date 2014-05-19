$log_level = 'info'

host { 'devbox': ip => "127.0.0.1" }

exec { 'apt_update':
    command => "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && 
                sudo echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | 
                sudo /usr/bin/tee /etc/apt/sources.list.d/mongodb.list && 
                sudo add-apt-repository ppa:webupd8team/java && 
                sudo apt-get update",
    path => '/usr/bin:/bin'
}

package{ [ 'python-software-properties', 'expect', 'expect-dev', 'git', 'mongodb-org', 'putty-tools'] :
    ensure => installed,
    require => Exec['apt_update']
}

class java($version) {
 
  exec { "add-apt-repository-oracle":
    command => "/usr/bin/add-apt-repository -y ppa:webupd8team/java",
    notify => Exec["apt_update"]
  }
 
  exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
 
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }
 
  package { 'oracle-java7-installer':
    ensure => "${version}",
    require => [Package['python-software-properties'], Exec['add-apt-repository-oracle'], Exec['set-licence-selected'], Exec['set-licence-seen']],
  }
}

class { 'java': version => '7u55-0~webupd8~1', }

package{ ['oracle-java7-set-default', 'maven']:
    ensure => installed,
    require => [Class['java'], Exec['apt_update']]
}

class { 'mysql::install': }

file {'/home/vagrant/scripts':
    replace => "yes",
    ensure => "directory",
    recurse => "true",
    source => "file:///vagrant/puppet/scripts"
}

file {'/home/vagrant/.ssh/rdsilva.priv.ppk':
    replace => "no",
    ensure => "present",
    source => "file:///vagrant/puppet/config/rdsilva.priv.ppk"
}

exec { 'generate publickey':
    command => 'expect /home/vagrant/scripts/public.exp && expect /home/vagrant/scripts/private.exp',
    require => [Package['putty-tools'], File['/home/vagrant/scripts']],
    path => '/usr/bin:/bin',
    user => 'vagrant'
}

class { 'nginx::setup':
    ensure     => 'present',
    enable     => 'true',
    service    => 'running',
    version    => 'installed',
    config     => '/vagrant/puppet/config/default-nginx.conf',
    require => [Exec['apt_update']]
}

exec { 'clone dotfiles repo':
    command => "git clone http://github.com/ramseydsilva/dotfiles",
    path => "/usr/bin:/bin",
    cwd => "/home/vagrant",
    user => "vagrant",
    creates => '/home/vagrant/dotfiles',
    require => [Package['git']]
}

exec { 'configure vim':
    command => "git submodule init && git submodule update && ln -s /home/vagrant/dotfiles/.vim /home/vagrant/.vim && ln -s /home/vagrant/dotfiles/.vimrc /home/vagrant/.vimrc",
    path => "/usr/bin:/bin",
    cwd => "/home/vagrant/dotfiles",
    creates => '/home/vagrant/.vim',
    require => Exec['clone dotfiles repo'],
    user => "vagrant"
}
