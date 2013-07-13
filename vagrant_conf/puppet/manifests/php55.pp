class php55($target_dir = '/opt/php55/', $logoutput = false)
{
  notify
  {
    "class_php55": message => "class php55"
  }

  $tmp_path        = '/vagrant/'
  $php_version    = '5.5.0'

  if defined(Package['wget']) == false
  {
    package
    {
      'wget': ensure => latest
    }
  }

  if defined(Package['build-essential']) == false
  {
    package
    {
      'build-essential': ensure => latest
    }
  }

    package
    {
      'checkinstall': ensure => latest
    }

  if defined(Exec['apt-get update']) == false
  {
	  exec { 'apt-get update':
	      command => 'apt-get update',
	  }
  }

  $php55_packages = ["libfcgi-dev", "libfcgi0ldbl", "libjpeg62-dbg", "libmcrypt-dev", "libssl-dev", "libc-client2007e", "libc-client2007e-dev", "libxml2-dev", "libcurl4-gnutls-dev", "libxslt-dev"]
  package {
      $php55_packages:
          ensure => latest,
          require => Exec['apt-get update'],
  }

  $php_file = "php-${php_version}.tar.bz2"
  $php_src_dir = "/usr/local/src/php5-build"

  exec
  {
    'download_php55':
      command     => "wget http://de.php.net/get/$php_file/from/this/mirror -O $php_file",
      cwd         => $tmp_path,
      require     => [Package['wget']],
      creates     => "$tmp_path/$php_file",
      logoutput   => $logoutput,
  }

  exec
  {
    'compile_php55':
      command => "/bin/sh /vagrant/vagrant_conf/shell/php55_compiler.sh php-$php_version $php_src_dir",
      cwd     => $tmp_path,
      require => [Package['build-essential'],Package['checkinstall'],Exec['download_php55']],
      timeout => 0,
      creates => "$php_src_dir/php-$php_version"
  }
}