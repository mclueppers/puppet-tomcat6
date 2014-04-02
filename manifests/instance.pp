define tomcat6::instance (
  $account = undef,
  $ajp_port = undef,
  $http_port = undef,
  $shutdown_port = undef,
  $home_group = undef,
  $log_group = undef,
  $base_dir = '/opt/samvo',
  $resources = undef,
  $tomcat_cluster = false,
  $catalina_opts = undef,
) {
  include tomcat6

  $home_group_r = $home_group ? {
    undef   => $account,
    default => $home_group,
  }

  $log_group_r = $log_group ? {
    undef   => $account,
    default => $log_group,
  }

  file { "/etc/sysconfig/tomcat6-${name}":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('tomcat6/sysconfig.erb')
  }

  file { "/etc/init.d/tomcat6-${name}":
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    target  => '/etc/init.d/tomcat6',
    require => Class['tomcat6::package'],
  }

  ######
  # Cache Directories
  ######
  $cache_dirs = [ "/var/cache/tomcat6-${name}",
                  "/var/cache/tomcat6-${name}/temp",
                  "/var/cache/tomcat6-${name}/work" ]
  file { $cache_dirs:
    ensure  => directory,
    owner   => $account,
    group   => $account,
    mode    => '2775',
  }

  file { "${base_dir}/${account}/tomcat6-${name}/temp":
    ensure  => link,
    owner   => $account,
    group   => $log_group_r,
    mode    => '2775',
    target  => "/var/cache/tomcat6-${name}/temp"
  }

  file { "${base_dir}/${account}/tomcat6-${name}/work":
    ensure  => link,
    owner   => $account,
    group   => $log_group_r,
    mode    => '2775',
    target  => "/var/cache/tomcat6-${name}/work"
  }

  #######
  # Application Home Resources
  #######
  $app_dirs = [ "${base_dir}/${account}",
                "${base_dir}/${account}/tomcat6-${name}",
                "${base_dir}/${account}/tomcat6-${name}/Catalina",
                "${base_dir}/${account}/tomcat6-${name}/Catalina/localhost",
                "${base_dir}/${account}/tomcat6-${name}/Catalina/lib",
                "${base_dir}/${account}/tomcat6-${name}/webapps" ]

  file { $app_dirs:
    ensure  => directory,
    replace => false,
    owner   => $account,
    group   => $home_group_r,
    mode    => '2775',
  }

  file { "/var/log/tomcat6-${name}":
    ensure => directory,
    owner  => $account,
    group  => $log_group_r,
    mode   => '2775',
  }

  file { "${base_dir}/${account}/tomcat6-${name}/logs":
    ensure  => link,
    owner   => $account,
    group   => $log_group_r,
    mode    => '2775',
    target  => "/var/log/tomcat6-${name}",
  }

  file { "${base_dir}/${account}/tomcat6-${name}/bin":
    ensure => link,
    owner  => $account,
    group  => $home_group_r,
    mode   => '2775',
    target => '/usr/share/tomcat6/bin',
  }

  #######
  # Initial Configuration Files
  #######

  #######
  # Cluster configuration
  #######
  if is_hash($tomcat_cluster) {
	if is_hash($tomcat_cluster['deployer']) {
		$deployer = $tomcat_cluster['deployer']
	}
        if is_hash($tomcat_cluster['receiver']) {
		$receiver = $tomcat_cluster['receiver']
        }
        if is_hash($tomcat_cluster['membership']) {
		$membership = $tomcat_cluster['membership']
        }
	$jvmroute = $::hostname
  }

  $defaulthost = "localhost"

  $tomcat_engine = template('tomcat6/server-xml-engine.erb')

  file { "${base_dir}/${account}/tomcat6-${name}/conf":
    replace => false,
    recurse => true,
    purge   => false,
    source  => 'puppet:///modules/tomcat6/app-home/',
    owner   => $account,
    group   => $home_group_r,
    mode    => '0664',
  }

  concat { "${base_dir}/${account}/tomcat6-${name}/conf/server.xml":
      owner  => $account,
      group  => $home_group_r,
      mode   => '0664',
  }

  concat::fragment { "server.xml.header-${name}":
      content => template('tomcat6/server-xml-header.erb'),
      target  => "${base_dir}/${account}/tomcat6-${name}/conf/server.xml",
      order   => 01,
  }

  concat::fragment { "server.xml.footer-${name}":
      content => template('tomcat6/server-xml-footer.erb'),
      target  => "${base_dir}/${account}/tomcat6-${name}/conf/server.xml",
      order   => 99,
  }

  #file { "/${base_dir}/${account}/tomcat6-${name}/conf/server.xml":
  #  replace => false,
  #  content => template('tomcat6/server-xml.erb'),
  #  owner   => $account,
  #  group   => $home_group_r,
  #  mode    => '0664',
  #}

  #######
  # Service Configuration
  #######
  service { "tomcat6-${name}":
    enable  => true,
    require => File["/etc/init.d/tomcat6-${name}"],
  }
}
