#!/bin/bash

MODULES_PATH=$1

if [ ! -d "/vagrant/puppet/modules/nginx" ]; then
  puppet module install example42/nginx --version 2.3.1 --modulepath=$MODULES_PATH;
fi

if [ ! -d "/vagrant/puppet/modules/nginx" ]; then
  puppet module upgrade mayflower-php --version 4.0.0-beta1 --modulepath=$MODULES_PATH;
fi

if [ ! -d "/vagrant/puppet/modules/mysql" ]; then
  puppet module install puppetlabs/mysql --version 3.8.0 --modulepath=$MODULES_PATH;
fi

if [ ! -d "/vagrant/puppet/modules/redis" ]; then
  puppet module install fsalum/redis --version 1.0.3 --modulepath=$MODULES_PATH;
fi