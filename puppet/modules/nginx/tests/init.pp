class { 'nginx::setup':
  ensure     => 'running',
  enable     => true,
  autoupdate => false
}