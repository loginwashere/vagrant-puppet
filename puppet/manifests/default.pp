package { "apache2":
  ensure => "purged"
}

class { "nginx":
  process_user => 'vagrant',
  worker_connections => 4096, # the default value 1024 cannot match the needs of a large site
  keepalive_timeout => 120, # increase this according to your app's responde time
  client_max_body_size => '200m', # increase this while your nginx works as an upload server.
  require => [Package['apache2']]
}

nginx::vhost { 'dev.192.168.33.10.xip.io' :
  template => '/vagrant/puppet/files/nginx/vhost.conf.erb',
  docroot  => '/var/www/dev.192.168.33.10.xip.io/web',
}

class { '::php::globals':
  php_version => '7.0',
  config_root => '/etc/php/7.0',
}->
class { '::php':
  manage_repos => true,
  fpm          => true,
  dev          => true,
  composer     => true,
  pear         => true,
  phpunit      => false,
  settings   => {
    'PHP/max_execution_time'  => '90',
    'PHP/max_input_time'      => '300',
    'PHP/memory_limit'        => '64M',
    'PHP/post_max_size'       => '32M',
    'PHP/upload_max_filesize' => '32M',
    'Date/date.timezone'      => 'UTC',
  },
}

class { '::mysql::server':
  root_password    => 'root',

  override_options => {
    'mysqld' => {
      'bind-address' => '127.0.0.1',
      'max_connections' => 500
    }
  }
}

mysql::db { 'site':
  user     => 'siteuser',
  password => 'siteuserpassword',
  host     => '127.0.0.1',
  grant    => ['ALL'],
  import_timeout => 900
}

mysql::db { 'site_test':
  user     => 'siteuser',
  password => 'siteuserpassword',
  host     => '127.0.0.1',
  grant    => ['ALL'],
  import_timeout => 900
}

class { 'redis':
  conf_port => '6379',
  conf_bind => '127.0.0.1',
}