# Class: logrotate
#
# This module manages logrotate and is included by the generic module
# to apply to *ALL* hosts
#
class logrotate {

    package { "logrotate": }

    file {
        "/var/log/archive":
            ensure  => directory,
            mode    => "750";
        "/etc/logrotate.conf":
            source  => "puppet:///modules/logrotate/logrotate.conf",
            require => Package["logrotate"];
        "/etc/cron.daily/logrotate":
            mode    => "755",
            source  => "puppet:///modules/logrotate/logrotate.cron",
            require => Package["logrotate"];
    } # file
} # class logrotate
