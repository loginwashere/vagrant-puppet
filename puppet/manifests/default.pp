package { "apache2":
  ensure => "purged"
}

class { "nginx":
  require => [Package['apache2']]
}

create_resources('nginx::vhost', hiera_hash('nginx_sites'))

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

create_resources('mysql::db', hiera_hash('mysql_databases'))

class { 'redis': }
