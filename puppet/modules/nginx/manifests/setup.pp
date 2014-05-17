class nginx::setup (
  $ensure  = 'present',
  $enable  = true,
  $service = 'running',
  $version = 'installed',
  $config  = undef) {
  if !($ensure in ['present', 'absent']) {
    fail('ensure parameter must be present or absent')
  }

  if !($enable in ['true', 'false']) {
    fail('enable parameter must be true or false')
  }

  if !($service in ['running', 'stopped']) {
    fail('service parameter must be running or false')
  }

  if $config == undef {
    $config_tpl = template("${module_name}/default-nginx.conf.erb")
  } else {
    $config_tpl = template("${caller_module_name}/${config}")
  }

  case $::osfamily {
    RedHat  : { }
    Debian  : { }
    default : { fail("${module_name} module is not supported on ${::osfamily} based systems") }
  }

  package { 'nginx': ensure => $version, }

  # Make sure we have removed all the config files that come by default
  # We don't want a welcome to Nginx page running on a production server
  file { ['/etc/nginx/conf.d/default.conf', '/etc/nginx/conf.d/ssl.conf', '/etc/nginx/conf.d/virtual.conf']:
    ensure  => absent,
    require => Package['nginx']
  }

  # Either pass a config file to the Class or use a default config file
  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    content => $config_tpl,
    notify  => Service['nginx'],
    require => [
      Package['nginx'],
      File['/etc/nginx/conf.d/default.conf', '/etc/nginx/conf.d/ssl.conf', '/etc/nginx/conf.d/virtual.conf']],
  }

  # Directory for ssl certificates. You can populate it with file using a File resource
  # This provides a flexible way of using this module in any environment
  file { '/etc/nginx/sslcerts':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => 700,
    require => Package['nginx'],
  }

  service { 'nginx':
    ensure     => $service,
    enable     => $enable,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['nginx'],
  }
}
