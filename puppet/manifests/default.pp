package { "apache2":
  ensure => "purged"
}

class { "nginx": }

nginx::vhost { 'dev.192.168.66.66.xip.io' :
  template => '/vagrant/puppet/files/nginx/vhost.conf.erb',
  docroot  => '/var/www/dev.192.168.66.66.xip.io/web',
}

class { '::php::globals': }
class { '::php':
  settings   => {
    'PHP/max_execution_time'  => '90',
    'PHP/max_input_time'      => '300',
    'PHP/memory_limit'        => '64M',
    'PHP/post_max_size'       => '32M',
    'PHP/upload_max_filesize' => '32M',
    'Date/date.timezone'      => 'UTC',
  },
}

class { '::mysql::server': }

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

class { 'redis': }