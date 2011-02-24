logrotate

Released 20100628 - Garrett Honeycutt - GPLv2

This is the logrotate module.

logrotate::dotd idea taken from example config by windowsrefund

example configuration:

    logrotate::dotd { "puppetmaster-production-masterhttp.log": 
        log => "/var/log/puppet.production/masterhttp.log",
        options => [ 'compress', 'weekly', 'rotate 4' ],
        postrotate => "[ -e /etc/init.d/puppetmaster-production ] && /etc/init.d/puppetmaster-production condrestart >/dev/null 2>&1 || true",
        prerotate => "[ -x /usr/bin/logger ] && /usr/bin/logger -t sampleprerotate this is a sample prerotate script",
    }

logrotate::httpdvhost - for directory specific httpd vhost (where logdir is /var/log/httpd|apache2/$vhost)
    
    logrotate::httpdvhost { "www.example.com"; }

