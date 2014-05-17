nginx
====


Overview
--------

The Nginx module installs and maintains the configuration of the Nginx server.


Module Description
-------------------

The Nginx module allows Puppet to install, configure and maintain the Nginx server.
This module is designed such that you have to populate the nginx configuration directory(/etc/nginx/conf.d) with custom file resource definitions. They must be valid nginx configuration files. By default, this directory is empty. This allows you to configure Nginx any way you want


Setup
-----

**What nginx affects:**

* package installation status
* configuration file 
	
### Beginning with Nginx

To setup Nginx on a server

    class { 'nginx::setup':
      ensure     => 'present',
      enable     => 'true',
	  service 	 => 'running'
	  version 	 => 'installed'
      config     => 'example.com-nginx.conf'
    }

Usage
------

The `nginx::setup` resource definition has several parameters to assist installation of nginx.

**Parameters within `nginx`**

####`ensure`

This parameter specifies whether the resource defination is present or absent.
Valid arguments are 'present' or 'absent'. Default 'present'

####`enable`

This parameter specifies whether nginx should be enabled to start automatically on system boot.
Valid arguments are 'true' or 'false'. Default 'true'

####`service`

This parameter specifies whether service nginx should be running or stopped.
Valid arguments are 'running' or 'stopped'. Default 'running'

####`version`

This parameter specified whether package nginx is autoupdated to latest or just installed and never updated or set to a particular version number
Valid arguments are 'installed' or 'latest' or '<package_version_number>'. Default 'installed'

####`config`

This parameter specifies the nginx.conf file to be placed in the nginx configuration directory. This is main configuration file for nginx.
If specified, this file must be in the files directory in the caller module.

The default configuration file that is installed by default will allow you to put any valid nginx configuration file in /etc/nginx/conf.d/. By default, no files are placed here, and hence, nginx will not open any port.


Limitations
------------

This module has been built and tested using Puppet 2.6.x, 2.7, and 3.x.

The module has been tested on:

* CentOS 5.9
* CentOS 6.4
* Debian 6.0 
* Ubuntu 12.04

Testing on other platforms has been light and cannot be guaranteed. 

Development
------------

Bug Reports
-----------

Release Notes
--------------
**0.0.2**

\#1 module must allow specifying nginx package version

**0.0.1**

First initial release.
