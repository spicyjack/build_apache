#!/bin/sh -x

# script to build apache

# Instructions:
# 1. Unpack all of the source into the same directory, 
#    like /usr/local/src/apache
# 2. adjust this script to match the locations of the software
# 3. run, sit back, and enjoy

# change these to match current versions
apache="apache_1.3.9"
mm="mm-1.0.11"
mod_perl="mod_perl-1.21"
mod_php="php-3.0.12"
mod_ssl="mod_ssl-2.4.5-1.3.9"
openssl="openssl-0.9.4"
src_base="/usr/local/src/apache"
install="/usr/local"
export SSL_BASE=$src_base/$openssl
export EAPI_MM=$src_base/$mm

# function for checking for a "no" answer

#checkno=()
#{
#	read answer
#	if [ $answer = "n" -o $answer = "N" ]; then
#		exit 1
#	fi
#}

# start of main script
clear
echo Welcome to Brian\'s Apache Web Server Builder
echo
echo "Hopefully, this should make building custom Apache Servers 
a piece of cake.  This script will run through all of the config
steps neccesary to build Apache, and install it for you, if desired."
echo
echo "During the install process, you will be asked for the root password
to install necessary software.  This will happen more than once.
You can either trust that this shell script is benign, or open it up
in an editor and read it for yourself.  Your choice :)"
echo
echo "Continue? [y]"
	read answer
	if [ $answer = "n" -o $answer = "N" ]; then
		exit 1
	fi
clear

echo "STEP #1: Setup"
echo
echo "The following is a list of paths that are currently stored in this 
script.  If you need to make any changes, press <CTRL-C>, and 
open this script in your favorite editor, and make your changes" 
echo
echo "Apache is located in $src_base/$apache"
echo "MM is located in $src_base/$mm"
echo "mod_perl is located in $src_base/$mod_perl"
echo "mod_php is located in $src_base/$mod_php"
echo "mod_ssl is located in $src_base/$mod_ssl"
echo "OpenSSL is located in $src_base/$openssl"
echo "The base of all of the source (for relative path names) is:"
echo $src_base/
echo "The install directory is: $install"
echo
echo Is the above correct? [y]
	read answer
	if [ $answer = "n" -o $answer = "N" ]; then
		exit 1
	fi

clear
echo "Step #2, first apache run"
cd $src_base/$apache
#./configure --prefix=$install
echo
echo Done with 1st Apache run
#sleep 5s

clear
echo "Step #3, mm"
cd ../$mm
#./configure --prefix=$install
#make
#make test

echo
echo First su, for the mm software
echo
#su -c "make install" root
echo
echo Done with mm
echo
echo "Continue? [y]"
	read answer
	if [ $answer = "n" -o $answer = "N" ]; then
		exit 1
	fi
clear

echo "Step #4, openssl"
cd ../$openssl
#./config --prefix=/usr/local 
#make
#make test

echo
echo Done with openssl
echo
echo "Continue? [y]"
	read answer
	if [ $answer = "n" -o $answer = "N" ]; then
		exit 1
	fi
clear

echo "Step #5, PHP"
cd ../$mod_php
#./configure --with-mysql \
#--with-apache=../$apache \
#--enable-track-vars \
#--with-imap=/usr/local \
#--with-mysql=/usr \
#--disable-short-tags \
#--enable-sysvsem \
#--enable-sysvshm 

#make

#make install

echo
echo Done with PHP
echo
echo "Continue? [y]"
	read answer
	if [ $answer = "n" -o $answer = "N" ]; then
		exit 1
	fi
clear

echo "Step #6, mod_perl"
cd ../$mod_perl
#perl Makefile.PL \
#USE_APACI=1 EVERYTHING=1 DO_HTTPD=1 PREP_HTTPD=1 \
#SSL_BASE=../$openssl \
#APACHE_PREFIX=$install \
#APACHE_SRC=../$apache \
#APACI_ARGS=--enable-module=ssl,--enable-module=rewrite

echo Second su, for the mod_perl software
echo
#su -c "make test" root
#make install

echo
echo Done with mod_perl
echo
echo "Continue? [y]"
	read answer
	if [ $answer = "n" -o $answer = "N" ]; then
		exit 1
	fi
clear

echo "Step #7, Apache, 2nd time"
cd ../$apache
SSL_BASE=$src_base/$openssl \
EAPI_MM=$src_base/$mm \
./configure --prefix=$install \
--enable-module=ssl \
--activate-module=src/modules/php3/libphp3.a \
--activate-module=src/modules/perl/libperl.a 

make
make certificate TYPE=custom
su -c "make install" root

echo
echo Fin!

