#!/bin/sh
##############################################################################
#
#   Copyright 2004 The Apache Software Foundation.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
##############################################################################
#
# Small shell script to show how to start/stop Tomcat using jsvc
# If you want to have Tomcat running on port 80 please modify the server.xml
# file:
#
#    <!-- Define a non-SSL HTTP/1.1 Connector on port 80 -->
#    <Connector className="org.apache.catalina.connector.http.HttpConnector"
#               port="80" minProcessors="5" maxProcessors="75"
#               enableLookups="true" redirectPort="8443"
#               acceptCount="10" debug="0" connectionTimeout="60000"/>
#
# That is for Tomcat-5.0.x (Apache Tomcat/5.0)
#
# Adapt the following lines to your configuration
JAVA_HOME=/usr/local/stow/jdk1.5.0_12
CATALINA_HOME=/usr/local/tomcat
# for jsvc?
DAEMON_HOME=/usr/local/tomcat
TOMCAT_USER=tomcat

# for multi instances adapt those lines.
TMP_DIR=/var/tmp
PID_FILE=/usr/local/apache/logs/jsvc.pid
CATALINA_BASE=/usr/local/tomcat

CATALINA_OPTS="-Djava.library.path=/usr/local/tomcat/lib"
CLASSPATH=$JAVA_HOME/lib/tools.jar
CLASSPATH=$CATALINA_HOME/bin/commons-daemon.jar:$CLASSPATH
CLASSPATH=$CATALINA_HOME/bin/bootstrap.jar:$CLASSPATH

LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
case "$1" in
  start)
    #
    # Start Tomcat
    #
    $DAEMON_HOME/bin/jsvc \
    -user $TOMCAT_USER \
    -home $JAVA_HOME \
    -Dcatalina.home=$CATALINA_HOME \
    -Dcatalina.base=$CATALINA_BASE \
    -Djava.io.tmpdir=$TMP_DIR \
    -wait 10 \
    -pidfile $PID_FILE \
    -outfile /usr/local/apache/logs/catalina.log \
    -errfile /usr/local/apache/logs/catalina.err \
    $CATALINA_OPTS \
    -cp $CLASSPATH \
    org.apache.catalina.startup.Bootstrap
    #
    # To get a verbose JVM
    #-verbose \
    # To get a debug of jsvc.
    #-debug \
    exit $?
    ;;

  stop)
    #
    # Stop Tomcat
    #
    $DAEMON_HOME/bin/jsvc \
    -stop \
    -pidfile $PID_FILE \
    org.apache.catalina.startup.Bootstrap
    exit $?
    ;;

  *)
    echo "Usage tomcat.sh start/stop"
    exit 1;;
esac
