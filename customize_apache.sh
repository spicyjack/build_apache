#!/bin/sh

# from a default apache install, customize the install by moving some of the
# files/directories around so they are persistant across installs of different
# versions of apache

# directory that will hold Apache tree + config tree
ROOT_DIR=/usr/local

# apache tree (note: this changes from time to time)
APACHE_DIR=$ROOT_DIR/httpd-worker-2007Q2

# main configuration directory
CFG_DIR=$ROOT_DIR/apache2.2-conf

# TODO
# move/link the following files/directories
# - $APACHE_DIR/conf to $CFG_DIR, with a link back to the original
# - $APACHE_DIR/bin/envvars to $CFG_DIR, with a link back to the original
# - $APACHE_DIR/bin/apachectl to $CFG_DIR, with a link back to the original
# - $CFG_DIR/apachectl to /etc/init.d/httpd
