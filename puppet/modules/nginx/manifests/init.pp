# Class: nginx
#
# The Nginx module allows Puppet to install, configure and maintain
# the Nginx server.
#
# This module allows the flexibilty of simply adding file resources
# to populate the /etc/nginx/conf.d/ directory and make nginx behave
# accordingly. This module stays out of the way. It does not touch
# the conf.d directory which allows you the freedom to configure
# nginx with file resources by putting a valid nginx configuration file.
#
# Parameters: ensure, enable, autoupdate, config
#
# Sample Usage:
#    class { 'nginx::setup':
#      ensure     => 'running',
#      enable     => true,
#      autoupdate => false
#    }
#
class nginx {

}
