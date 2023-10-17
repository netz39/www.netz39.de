---
layout: post
title: "Installation of WordPress in a subdirectory with nginx"
date: "2014-08-26"
categories: 
  - "maschinenraum"
tags: 
  - "nginx"
  - "wordpress"
---

The world wide web is full of tutorials on how to setup WordPress and important for our use case also how to do this with nginx. However it seems to me there are only three cases covered: throw WordPress to your document root, access it at / and have a single site installation with nothing else around. The other two cases deal with multisite installations.

This covered not what I wanted. For a recent project we already had an URL like `http://foo.example.com/` with running `http://foo.example.com/redmine` and `http://foo.example.com/phpmyadmin` so I thought if further web applications come along like a wiki or whatever else, it would be a bad idea to put the WordPress to just `http://foo.example.com/` and let the aforementioned look like parts of the blog, maybe even interfere with permalinks or making other later decisions difficult. No, I wanted to have the CMS sitting in `http://foo.example.com/site/` and `http://foo.example.com/` should just contain a static page or redirect with 302 or anything like that.

Turned out configuration was harder than I thought, but that was probably due to my lack of knowledge on how nginx, php5-fpm and an application play together. The config I came up with is this:

server {
        listen 80;
        listen \[::\]:80;

        server\_name foo.example.com;
        root /usr/share/nginx/www;

        location ~ ^/$ {
                return 302 http://$host/site/;
        }

        location = /favicon.ico {
                log\_not\_found off;
                access\_log off;
        }

        location = /robots.txt {
                log\_not\_found off;
                access\_log off;
        }

        # Redmine Config by someone else

        client\_max\_body\_size 100M;

        location /redmine {
                return 301 https://$host$request\_uri;
        }

        # Wordpress Config by me

        location /site {
                alias /srv/wordpress;
                index index.php;
#               try\_files and alias does not work, see http://trac.nginx.org/nginx/ticket/97
#               instead we rewrite by ourselves almost like
#               https://stackoverflow.com/questions/17805576/nginx-rewrite-in-subfolder
#               try\_files $uri $uri/ /site/index.php?$args;
                try\_files $uri $uri/ @site\_rewrite;
        }

        location @site\_rewrite {
                rewrite ^/site/(.\*)$ /site/index.php?$1;
        }

        location ~\* /site/(?:uploads|files)/.\*\\.php$ {
                deny all;
        }

        location ~ ^/site/(.+\\.php)$ {
                alias                           /srv/wordpress/$1;
                fastcgi\_split\_path\_info         ^(.+\\.php)(/.\*)$;

                fastcgi\_intercept\_errors        on;
                fastcgi\_pass                    php;
                fastcgi\_index                   index.php;
                include                         fastcgi\_params;
        }

        # phpsysinfo
        location /phpsysinfo {
                alias   /usr/share/phpsysinfo;
                index   index.php;
        }

        location ~ ^/phpsysinfo/(.+\\.php)$ {
                alias                   /usr/share/phpsysinfo/$1;
                fastcgi\_split\_path\_info ^(.+\\.php)(/.+)$;
                fastcgi\_pass            php;
                fastcgi\_index           index.php;
                include                 fastcgi\_params;
        }
}

The trick is to get the `alias` and `fastcgi_split_path_info` statements right. What really helps here is reading the nginx documentation instead of copying just another config from some blog and trying until something succeeds. So **RTFM** guys!

**Update:** until [#97](http://trac.nginx.org/nginx/ticket/97) is fixed in nginx, this won't work with pretty permalinks. :-/

**Update:** now rewrite like above works with #97 still not fixed.
