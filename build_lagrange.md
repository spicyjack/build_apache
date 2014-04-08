TODO: Install mod_perl on a VM and work with the configuration parameters so
it will install a stowable copy of itself
Note: OpenSSL was not compiled from scratch as of **04Jan2014**

    export PREFIX=/usr/local/stow/httpd-X.X.XX-YYYY.JJJ
    export PREFIX_SUPPORT=/usr/lib

OpenSSL 1.0.1f
--------------
Wants: zlib1g-dev

    ./config --prefix=$PREFIX shared zlib
    time make
    time make test
    sudo make install

Apache 2.2.27
-------------
Wants: libldap2-dev libexpat1-dev

    ./configure --prefix=${PREFIX} --enable-modules=all \
    --enable-mods-shared=all --enable-v4-mapped --enable-authn-dbm \
    --enable-authn-anon --enable-authn-dbd --enable-authn-alias \
    --enable-authz-dbm --enable-authz-owner --enable-auth-digest \
    --enable-file-cache --enable-cache --enable-disk-cache \
    --enable-mem-cache --enable-dbd --enable-echo --enable-deflate \
    --enable-mime-magic --enable-http --enable-dav --enable-info \
    --enable-speling --enable-cgi --enable-dav-fs --enable-dav-lock \
    --enable-vhost-alias --enable-rewrite --enable-so --with-mpm=prefork \
    --enable-proxy --enable-proxy-connect --enable-proxy-ftp \
    --enable-proxy-http --enable-ssl --enable-static-htpasswd \
    --enable-authnz-ldap --with-included-apr \
    --with-ldap=ldap --enable-ldap --with-expat=/usr

    time make
    sudo make install

- `--with-expat=/usr` is apparently needed on 64-bit systems.
- `--with-ssl=${PREFIX}` will use an OpenSSL library installed into
  `${PREFIX}`

PHP 5.4.27
----------
Wants:  libxml2-dev mcrypt libmcrypt-dev libbz2-dev libcurl4-openssl-dev
        libqdbm-dev libgdbm-dev libmysqlclient-dev libjpeg8-dev
        libpng12-dev libfreetype6-dev libsasl2-dev

Other app dependencies are located below.

Can't use the Apache copy of OpenSSL, because libcurl is not linked against
it.  So `--with-openssl` can never be `--with-openssl=${PREFIX}`.

Can't set a path to `libldap`, because the headers are in `/usr/include`, but
the libraries are in `/usr/lib/x86_64-linux-gnu`.

    LDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu" \
    CPPFLAGS="-I/usr/include" \
    ./configure --prefix=${PREFIX} \
    --with-apxs2=${PREFIX}/bin/apxs --with-config-file-path=/etc/httpd \
    --with-config-file-scan-dir=/etc/httpd \
    --with-openssl --with-zlib --with-bz2 --enable-calendar \
    --enable-dba=shared --with-gdbm --enable-ftp \
    --enable-exif --with-gd --enable-gd-native-ttf \
    --with-jpeg-dir=${PREFIX_SUPPORT} --with-freetype-dir=${PREFIX_SUPPORT} \
    --with-gettext --with-ldap --with-ldap-sasl \
    --with-mysql --with-mysqli --with-mysql-sock=/var/run/mysqld/mysqld.sock \
    --enable-sockets --enable-sysvsem --enable-sysvshm \
    --with-curl --enable-zip --with-pear --with-pdo-mysql --with-mcrypt \
    --enable-mbstring --enable-pcntl --with-libdir=lib/x86_64-linux-gnu

    time make
    time make test
    sudo make install

PHP App configs
---------------
phpMyAdmin
- switches: --enable-mbstring --with-mysqli

icinga-web
- switches: --with-xsl --enable-soap --with-xmlrpc 
- packages: libxslt1-dev libltdl-dev packages

WordPress
- switches: --with-mysql

Phabricator 
- switches: --enable-pcntl
- extensions: sudo pecl install apc

OpenPhoto 
- extensions:
  - sudo apt-get install libmagick9-dev
  - sudo pecl install imagick
  - sudo pecl install apc

PHP Misc notes
--------------
You can verify the PHP build from the command line, without
starting/restarting Apache by running:

    ./sapi/cli/php -i

from the PHP source directory.

mod_perl 2.0.7
--------------
Make sure 'libperl.so' exists, it should be a symlink/hardlink back to
libperl.so.5.X.X.  If it doesn't exist, create it as a symlink back to the
library file.

For Linux:
perl Makefile.PL MP_APXS=${PREFIX}/bin/apxs 

For OS X:
perl Makefile.PL MP_APXS=${PREFIX}/bin/apxs MP_CCOPTS=-std=gnu89

time make
time LD_LIBRARY_PATH=${PREFIX}/lib make test
# if you are running a previous instance of mod_perl under stow, unstow that
# instance prior to running make install, as mod_perl's make install is stupid
# and will happily overwrite your existing mod_perl files
sudo make install

To install with a log of what got installed where:
sudo make install 2>&1 | tee install.log

Move /usr/local/lib/perl to /usr/local/stow/httpd-2.2.XX/lib
Move /usr/local/man/man3 to /usr/local/stow/httpd-2.2.XX/man

Testing
-------
See full list of test URLs in machine_upgrades.md

Building fake Debian packages using 'equivs'
--------------------------------------------
apt-get install equivs
equivs-control libapache2-mod-perl2
equivs-build libapache2-mod-perl2
sudo dpkg -i libapache2-mod-perl2_2.0.X_all.deb

you can use 'dpkg -P' to get a list of packages to build with equivs in order
to satisfy dependencies for something.  The equivs dummy packages should have
their version numbers changed when you do a new install of Apache.

Example equivs are stored in:

    hostcfgs.git/httpd/debian_equivs

vim: filetype=markdown tabstop=2 shiftwidth=2
