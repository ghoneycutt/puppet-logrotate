# Class: logrotate
#
# This module manages logrotate and is included by the generic module
# to apply to *ALL* hosts
#
class logrotate {

    package { "logrotate":
        ensure => installed,
    } # package

    file {
        "/var/log/archive":
            ensure  => directory,
            mode    => "0750";
        "/etc/logrotate.conf":
            source  => "puppet:///modules/logrotate/logrotate.conf",
            require => Package["logrotate"];
        "/etc/logrotate.d":
            ensure => directory,
            owner => "root",
            group => "root",
            mode => "0755",
            require => Package["logrotate"];
        "/etc/cron.daily/logrotate":
            mode    => "0755",
            source  => "puppet:///modules/logrotate/logrotate.cron",
            require => Package["logrotate"];
    } # file
} # class logrotate

define logrotate::dotd( $log, $options, $postrotate = "NONE", $prerotate = "NONE" ) {

    # options should be an array of valid logrotate variables (currently no error checking)

    include logrotate

    file { "/etc/logrotate.d/${name}":
        owner => "root",
        group => "root",
        mode => "0644",
        content => template("logrotate/logrotate.tpl"),
        require => File["/etc/logrotate.d"],
    } # file
}

# httpd vhost configuration
define logrotate::httpdvhost() {

    include logrotate

    $prerotate = "NONE"

    $httpdname = $operatingsystem ? {
        /RedHat|CentOS|Fedora/ => "httpd",
        default => "apache2",
    } # $httpdname

    $postrotate = $operatingsystem ? {
        /RedHat/CentOS/Fedora/ => "/sbin/service $httpdname reload > /dev/null 2>/dev/null || true",
        default => "if [ -f \"`. /etc/$httpdname/envvars ; echo ${APACHE_PID_FILE:-/var/run/$httpdname.pid}`\" ]; then /etc/init.d/$httpdname reload > /dev/null; fi",
    } # $postrotate

    $log = $operatingsystem ? {
        /RedHat/CentOS/Fedora/ => "/var/log/httpd/${name}/*log",
        default => "/var/log/apache2/${name}/*log",
    } # $log

    $options = [ 'daily', 'nocreate', 'notifempty', 'missingok', 'dateext', 'sharedscripts', 'rotate 60' ]

    file { "/etc/logrotate.d/$httpdname-${name}":
        owner => "root",
        group => "root",
        mode => "0644",
        content => template("logrotate/logrotate.tpl"),
        require => File["/etc/logrotate.d"],
    } # file
}

