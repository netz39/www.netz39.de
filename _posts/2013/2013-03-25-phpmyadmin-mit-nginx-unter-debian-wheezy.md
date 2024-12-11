---
author: lespocky
layout: post
title: "phpmyadmin mit nginx unter Debian Wheezy"
date: "2013-03-25"
categories: 
  - "maschinenraum"
tags: 
  - "debian"
  - "nginx"
  - "phpmyadmin"
feature-img: "https://cdn.netz39.de/img/post-img/2013/netz39-006-1440x486.jpg"
thumbnail: "https://cdn.netz39.de/img/post-img/2013/netz39-006-1440x486.jpg"
---

# phpmyadmin mit nginx unter Debian Wheezy

Eigentlich wollte ich ja heute einen [status.net Server aufsetzen](http://status.net/), aber da der gerne MySQL und auch noch gern eine eigene Datenbank hätte und das auf dem designierten Server noch nicht installiert war, schob ich erstmal die Installation von MySQL und phpMyAdmin ein. Das Debian-Paket _phpmyadmin_ bringt Beispielkonfigurationsdateien für Apache2 und lighttpd mit, für den hier eingesetzten _nginx_ leider nicht. Das Web ist voll von HowTos zu dem Thema, aber keins passt so richtig (beispielsweise weil mir das reicht phpmyadmin in 'nem Unterordner zu haben) und deswegen gibt's jetzt noch HowTo, dieses hier. Voraussetzung ist ein bereits fertig eingerichteter nginx mit _php5-fpm_ und ein MySQL-Server. In der entsprechenden Config des nginx steht irgendwo etwa folgendes für den php5-fpm:

    upstream php {
        server unix:/var/run/php5-fpm.sock;
    }

Dann gibt es sicher noch einen Abschnitt für den HTTPS-Server und da fügt man dann folgendes ein:

    # phpmyadmin
    location /phpmyadmin {
        alias   /usr/share/phpmyadmin;
        index   index.php;
    }

    location ~ ^/phpmyadmin/libraries {
        deny all;   
    }

    location ~ ^/phpmyadmin/setup/lib {
        deny all;  
    }

    location ~ ^/phpmyadmin/setup/(.+.php)$ {
        auth_basic              "phpMyAdmin Setup";
        auth_basic_user_file    "/etc/phpmyadmin/htpasswd.setup";
        alias                   /usr/share/phpmyadmin/setup/$1;
        fastcgi_split_path_info ^(.+.php)(/.+)$;
        fastcgi_pass            php;
        fastcgi_index           index.php;
        include                 fastcgi_params;   
    }

    location ~ ^/phpmyadmin/(.+.php)$ {
        alias                   /usr/share/phpmyadmin/$1;
        fastcgi_split_path_info ^(.+.php)(/.+)$;
        fastcgi_pass            php;
        fastcgi_index           index.php;
        include                 fastcgi_params;
    }

Damit entspricht das recht genau den von Debian mitgelieferten Configs für die anderen Webserver. Der vorletzte Abschnitt schützt das Setup von phpmyadmin. Ein Passwort würde man mit dem Tool `htpasswd` setzen können, das ist bekanntermaßen im Paket _apache2-utils_ enthalten. Aber: wenn man phpmyadmin über den Debian-Paketmanager installiert hat, kann man sich das sparen, wenn die Konfiguration gleich bei der Installation mit Hilfe von _dbconfig-common_ gemacht wurde. Die Doku in `/usr/share/doc/phpmyadmin/README.Debian.gz` sagt dazu:

> Since 3.0.0, phpMyAdmin can be configured using dbconfig-common. It creates a phpmyadmin database and control user on the chosen server and configures phpMyAdmin to use cookie authentication on this server. The database autoconfiguration might fail if you do not have local MySQL server installed or you have configured too high priority of which questions should debconf ask. To rerun the configuration just invoke:
> 
>> dpkg-reconfigure -plow phpmyadmin
> 
> phpMyAdmin also provides a web-based setup script available at http://localhost/phpmyadmin/setup/index.php

Betonung auf »also«, d.h. wenn man dbconfig-common benutzt hat, ist man bereits fertig.
